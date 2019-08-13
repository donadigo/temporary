


public class Core.MoveToolItem : ToolItem {
    public override string name {
        get {
            return _("Move");
        }
    }

    public override string icon_name {
        get {
            return "tool-pointer";
        }
    }


    bool dragging = false;
    float drag_x = 0;
    float drag_y = 0;

    Gee.HashMap<Layer, Gegl.Rectangle> start_boxes;

    construct {
        start_boxes = new Gee.HashMap<Layer, Gegl.Rectangle> ();
    }

    public override void activate () {}
    public override void deactivate () {}

    public override void handle_event (Widgets.CanvasView canvas_view, Clutter.Event event, Gee.LinkedList<unowned LayerStackItem> selected) {
        switch (event.type) {
            case BUTTON_PRESS:
                handle_button_press (canvas_view, (Clutter.ButtonEvent)event, selected);
                break;
            case BUTTON_RELEASE:
                handle_button_release (canvas_view, (Clutter.ButtonEvent)event, selected);
                break;
            case MOTION:
                handle_motion (canvas_view, (Clutter.MotionEvent)event, selected);
                break;
            case KEY_PRESS:
                handle_key_press (canvas_view, (Clutter.KeyEvent)event, selected);
                break;
        }
    }

    void handle_button_press (Widgets.CanvasView cv, Clutter.ButtonEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        if (event.button != Gdk.BUTTON_PRIMARY) {
            return;
        }

        EventBus.get_default ().freeze_cursor_changes (true);
        cv.get_stage ().set_key_focus (cv);
        cv.doc.enter_actor_mode ();
        start_boxes.clear ();
        foreach (unowned LayerStackItem item in selected) {
            var layer = item as Layer;
            if (layer == null) {
                return;
            }

            layer.dirty = true;

            var actor = cv.get_actor_by_layer (layer);
            float ex = event.x / (float)actor.scale_x;
            float ey = event.y / (float)actor.scale_y;
            cv.get_parent ().transform_stage_point (ex, ey, out ex, out ey);

            drag_x = ex;
            drag_y = ey;
            start_boxes[layer] = layer.bounding_box;
        }

        cv.doc.layer_stack.update_dirty ();
        dragging = true;
    }

    void handle_button_release (Widgets.CanvasView cv, Clutter.ButtonEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        if (event.button != Gdk.BUTTON_PRIMARY) {
            return;
        }

        EventBus.get_default ().freeze_cursor_changes (false);
        foreach (unowned LayerStackItem item in selected) {
            if (item is Layer) {
                ((Layer)item).dirty = false;
            }
        }

        cv.doc.layer_stack.update_dirty ();
        cv.doc.process_graph ();
        dragging = false;
    }

    void handle_motion (Widgets.CanvasView cv, Clutter.MotionEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        if (dragging) {
            foreach (unowned LayerStackItem item in selected) {
                var layer = item as Layer;
                if (layer == null) {
                    return;
                }

                var actor = cv.get_actor_by_layer (layer);
                
                float ex, ey;
                Canvas.CanvasUtils.translate_to_stage_layer (cv.get_parent (), event, actor, out ex, out ey);

                float delta_x = ex - drag_x;
                float delta_y = ey - drag_y;

                var start_box = start_boxes[layer];
                layer.update_bounding_box (new Gegl.Rectangle (
                    start_box.x + (int)delta_x, start_box.y + (int)delta_y,
                    layer.bounding_box.width, layer.bounding_box.height
                ));
            }
        }        
    }

    void handle_key_press (Widgets.CanvasView cv, Clutter.KeyEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        cv.get_stage ().set_key_focus (cv);
        cv.doc.enter_actor_mode ();
        foreach (unowned LayerStackItem item in selected) {
            var layer = item as Layer;
            if (layer == null) {
                return;
            }

            switch (event.keyval) {
                case Clutter.Key.Left:
                    layer.move_bounding_box (-1, 0);
                    break;
                case Clutter.Key.Right:
                    layer.move_bounding_box (1, 0);
                    break;
                case Clutter.Key.Down:
                    layer.move_bounding_box (0, 1);
                    break;
                case Clutter.Key.Up:
                    layer.move_bounding_box (0, -1);
                    break;
            }
        }

        cv.doc.process_graph ();
    }
}