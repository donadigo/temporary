
using Core;

public class TransformActor : Clutter.Actor {
    public unowned Widgets.CanvasView canvas_view { get; construct; }
    public unowned Clutter.Stage stage { get; construct; }
    public LayerActor layer_actor { get; construct; }

    const int HANDLE_SIZE = 8;
    const int HALF_HANDLE = HANDLE_SIZE / 2;
    const int TRIGGER_SIZE = 15;

    const int TRIGGER_HANDLE_DIFF = TRIGGER_SIZE - HANDLE_SIZE;

    TransformHandleActor main;
    TransformHandleActor top_left;
    TransformHandleActor top_middle;
    TransformHandleActor top_right;

    TransformHandleActor bottom_left;
    TransformHandleActor bottom_middle;
    TransformHandleActor bottom_right;

    TransformHandleActor left_middle;
    TransformHandleActor right_middle;

    TransformTriggerActor trigger_resize_top_left;
    TransformTriggerActor trigger_resize_top_middle;
    TransformTriggerActor trigger_resize_top_right;

    TransformTriggerActor trigger_resize_bottom_left;
    TransformTriggerActor trigger_resize_bottom_middle;
    TransformTriggerActor trigger_resize_bottom_right;

    TransformTriggerActor trigger_resize_left_middle;
    TransformTriggerActor trigger_resize_right_middle;

    Gegl.Rectangle original_bounding_box;

    public TransformActor (Clutter.Stage stage, Widgets.CanvasView cv, LayerActor layer_actor) {
        Object (stage: stage, canvas_view: cv, layer_actor: layer_actor);
    }

    construct {
        unowned Layer layer = layer_actor.layer;
        
        main = new TransformHandleActor (0, 0);
        top_left = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);
        top_middle = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);
        top_right = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);

        bottom_left = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);
        bottom_middle = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);
        bottom_right = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);

        left_middle = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);
        right_middle = new TransformHandleActor (HANDLE_SIZE, HANDLE_SIZE);

        trigger_resize_top_left = new TransformTriggerActor (this, "nwse-resize", TRIGGER_SIZE, TRIGGER_SIZE);
        trigger_resize_top_left.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_top_left.delta.connect (on_trigger_resize_top_left_delta);

        trigger_resize_top_middle = new TransformTriggerActor (this, "ns-resize", 0, TRIGGER_SIZE);
        trigger_resize_top_middle.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_top_middle.delta.connect (on_trigger_resize_top_middle_delta);

        trigger_resize_top_right = new TransformTriggerActor (this, "nesw-resize", TRIGGER_SIZE, TRIGGER_SIZE);
        trigger_resize_top_right.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_top_right.delta.connect (on_trigger_resize_top_right_delta);

        trigger_resize_bottom_left = new TransformTriggerActor (this, "nesw-resize", TRIGGER_SIZE, TRIGGER_SIZE);
        trigger_resize_bottom_left.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_bottom_left.delta.connect (on_trigger_resize_bottom_left_delta);

        trigger_resize_bottom_middle = new TransformTriggerActor (this, "ns-resize", 0, TRIGGER_SIZE);
        trigger_resize_bottom_middle.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_bottom_middle.delta.connect (on_trigger_resize_bottom_middle_delta);

        trigger_resize_bottom_right = new TransformTriggerActor (this, "nwse-resize", TRIGGER_SIZE, TRIGGER_SIZE);
        trigger_resize_bottom_right.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_bottom_right.delta.connect (on_trigger_resize_bottom_right_delta);

        trigger_resize_left_middle = new TransformTriggerActor (this, "ew-resize", TRIGGER_SIZE, 0);
        trigger_resize_left_middle.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_left_middle.delta.connect (on_trigger_resize_left_middle_delta);

        trigger_resize_right_middle = new TransformTriggerActor (this, "ew-resize", TRIGGER_SIZE, 0);
        trigger_resize_right_middle.begin_resize.connect (on_trigger_begin_resize);
        trigger_resize_right_middle.delta.connect (on_trigger_resize_right_middle_delta);

        add_child (main);
        add_child (top_left);
        add_child (top_middle);
        add_child (top_right);

        add_child (bottom_left);
        add_child (bottom_middle);
        add_child (bottom_right);

        add_child (left_middle);
        add_child (right_middle);

        add_child (trigger_resize_top_left);
        add_child (trigger_resize_top_middle);
        add_child (trigger_resize_top_right);

        add_child (trigger_resize_bottom_left);
        add_child (trigger_resize_bottom_middle);
        add_child (trigger_resize_bottom_right);

        add_child (trigger_resize_left_middle);
        add_child (trigger_resize_right_middle);

        layer_actor.notify["allocation"].connect (reposition);
        stage.notify["allocation"].connect (reposition);
        stage.motion_event.connect (on_stage_motion_event);
        stage.button_release_event.connect (on_stage_button_release_event);
        stage.key_press_event.connect (on_stage_key_event);        

        reposition ();
    }

    void reposition () {
        update_allocation ();

        float _lwidth, _lheight;
        layer_actor.get_size (out _lwidth, out _lheight);

        _lwidth *= (float)layer_actor.scale_x;
        _lheight *= (float)layer_actor.scale_y;

        float _lx, _ly;
        layer_actor.get_transformed_position (out _lx, out _ly);

        int lx = (int)_lx, ly = (int)_ly;
        int lwidth = (int)_lwidth, lheight = (int)_lheight;


        main.set_size (lwidth + 2, lheight + 2);
        main.set_position (lx, ly);

        // Handles
        top_left.set_position (lx - (HALF_HANDLE - 1), ly - (HALF_HANDLE - 1));
        top_middle.set_position (lx + lwidth / 2 - HALF_HANDLE, ly - (HALF_HANDLE - 1));
        top_right.set_position (lx + lwidth - HALF_HANDLE + 1, ly - (HALF_HANDLE - 1));
        
        bottom_left.set_position (lx - (HALF_HANDLE - 1), ly + lheight - HALF_HANDLE + 1);
        bottom_middle.set_position (lx + lwidth / 2 - HALF_HANDLE, ly + lheight - HALF_HANDLE + 1);
        bottom_right.set_position (lx + lwidth - HALF_HANDLE + 1, ly + lheight - HALF_HANDLE + 1);

        left_middle.set_position (lx - (HALF_HANDLE - 1), ly + lheight / 2 - (HALF_HANDLE - 1));
        right_middle.set_position (lx + lwidth - HALF_HANDLE + 1, ly + lheight / 2 - (HALF_HANDLE - 1));

        // Triggers
        trigger_resize_top_left.set_position (top_left.x - TRIGGER_HANDLE_DIFF, top_left.y - TRIGGER_HANDLE_DIFF);
        trigger_resize_top_middle.set_position (lx + HALF_HANDLE + 1, top_left.y - TRIGGER_HANDLE_DIFF);
        trigger_resize_top_middle.width = lwidth - HALF_HANDLE - 4;
        trigger_resize_top_right.set_position (top_right.x, top_left.y - TRIGGER_HANDLE_DIFF);

        trigger_resize_bottom_left.set_position (top_left.x - TRIGGER_HANDLE_DIFF, bottom_left.y);
        trigger_resize_bottom_middle.set_position (lx + HALF_HANDLE + 1, bottom_left.y);
        trigger_resize_bottom_middle.width = lwidth - HALF_HANDLE - 4;
        trigger_resize_bottom_right.set_position (top_right.x, bottom_left.y);

        trigger_resize_left_middle.set_position (top_left.x - TRIGGER_HANDLE_DIFF, top_left.y + HALF_HANDLE + TRIGGER_HANDLE_DIFF);
        trigger_resize_left_middle.height = lheight - HALF_HANDLE - 4;

        trigger_resize_right_middle.set_position (top_right.x, top_right.y + HALF_HANDLE + TRIGGER_HANDLE_DIFF);
        trigger_resize_right_middle.height = lheight - HALF_HANDLE - 4;

        set_pivot_point (_lx / stage.width, _ly / stage.height);
    }

    void update_allocation () {
        set_position (0, 0);
        set_size (stage.width, stage.height);
    }

    void on_trigger_begin_resize () {
        original_bounding_box = layer_actor.layer.bounding_box.dup ();
    }

    void on_trigger_resize_left_middle_delta (int x, int y) {
        int translated_x = (int)(x / layer_actor.scale_x);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x + translated_x, original_bounding_box.y,
            original_bounding_box.width - translated_x, original_bounding_box.height
        );

        layer_actor.layer.bounding_box_updated ();
    }

    void on_trigger_resize_right_middle_delta (int x, int y) {
        int translated_x = (int)(x / layer_actor.scale_x);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x, original_bounding_box.y,
            original_bounding_box.width + translated_x, original_bounding_box.height
        );

        layer_actor.layer.bounding_box_updated ();
    }

    void on_trigger_resize_bottom_middle_delta (int x, int y) {
        int translated_y = (int)(y / layer_actor.scale_y);

        int ly = original_bounding_box.y;
        int lheight = original_bounding_box.height + translated_y;

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x, ly,
            original_bounding_box.width, lheight
        );

        layer_actor.layer.bounding_box_updated ();
    }

    void on_trigger_resize_bottom_right_delta (int x, int y) {
        int translated_x = (int)(x / layer_actor.scale_x);
        int translated_y = (int)(y / layer_actor.scale_y);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x, original_bounding_box.y,
            original_bounding_box.width + translated_x, original_bounding_box.height + translated_y
        );

        layer_actor.layer.bounding_box_updated ();
    }

    void on_trigger_resize_bottom_left_delta (int x, int y) {
        int translated_x = (int)(x / layer_actor.scale_x);
        int translated_y = (int)(y / layer_actor.scale_y);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x + translated_x, original_bounding_box.y,
            original_bounding_box.width - translated_x, original_bounding_box.height + translated_y
        );

        layer_actor.layer.bounding_box_updated ();
    }

    void on_trigger_resize_top_right_delta (int x, int y) {
        int translated_x = (int)(x / layer_actor.scale_x);
        int translated_y = (int)(y / layer_actor.scale_y);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x, original_bounding_box.y + translated_y,
            original_bounding_box.width + translated_x, original_bounding_box.height - translated_y
        );

        layer_actor.layer.bounding_box_updated ();
    }

    void on_trigger_resize_top_middle_delta (int x, int y) {
        int translated_y = (int)(y / layer_actor.scale_y);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x, original_bounding_box.y + translated_y,
            original_bounding_box.width, original_bounding_box.height - translated_y
        );

        layer_actor.layer.bounding_box_updated ();        
    }

    void on_trigger_resize_top_left_delta (int x, int y) {
        int translated_x = (int)(x / layer_actor.scale_x);
        int translated_y = (int)(y / layer_actor.scale_y);

        layer_actor.layer.bounding_box = new Gegl.Rectangle (
            original_bounding_box.x + translated_x, original_bounding_box.y + translated_y,
            original_bounding_box.width - translated_x, original_bounding_box.height - translated_y
        );

        layer_actor.layer.bounding_box_updated ();
    }

    bool on_stage_button_release_event (Clutter.ButtonEvent event) {
        unowned EventBus event_bus = EventBus.get_default ();
        event_bus.freeze_cursor_changes (false);
        event_bus.change_cursor ("default");

        trigger_resize_top_left.handle_button_release_event (event);
        trigger_resize_top_middle.handle_button_release_event (event);
        trigger_resize_top_right.handle_button_release_event (event);
        trigger_resize_bottom_left.handle_button_release_event (event);
        trigger_resize_bottom_middle.handle_button_release_event (event);
        trigger_resize_bottom_right.handle_button_release_event (event);
        trigger_resize_left_middle.handle_button_release_event (event);
        trigger_resize_right_middle.handle_button_release_event (event);

        return false;
    }

    bool on_stage_key_event (Clutter.KeyEvent event) {
        if (event.keyval == Clutter.Key.KP_Enter ||
            event.keyval == 65293 || 
            event.keyval == Clutter.Key.ISO_Enter || 
            event.keyval == Clutter.Key.@3270_Enter) {
            
        }

        return false;
    }

    bool on_stage_motion_event (Clutter.MotionEvent event) {
        trigger_resize_top_left.handle_motion_event (event);
        trigger_resize_top_middle.handle_motion_event (event);
        trigger_resize_top_right.handle_motion_event (event);
        trigger_resize_bottom_left.handle_motion_event (event);
        trigger_resize_bottom_middle.handle_motion_event (event);
        trigger_resize_bottom_right.handle_motion_event (event);
        trigger_resize_left_middle.handle_motion_event (event);
        trigger_resize_right_middle.handle_motion_event (event);

        return false;
    }
}