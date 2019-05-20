

public class LayerActor : Clutter.Actor {
    public Document doc { get; construct; }
    public Layer layer { get; construct; }

    bool dragging = false;
    float drag_x = 0;
    float drag_y = 0;

    Rectangle<int> start_box;

    public LayerActor (Document doc, Layer layer) {
        Object (doc: doc, layer: layer);
    }

    construct {
        reactive = true;
        layer.notify["bounding-box"].connect (update_bounding_box);
        //  set_scale (20.0, 20.0);
    }

    public override bool motion_event (Clutter.MotionEvent event) {
        float delta_x = event.x - drag_x;
        float delta_y = event.y - drag_y;

        if (dragging) {
            layer.bounding_box = { 
                start_box.x + (int)delta_x, start_box.y + (int)delta_y,
                layer.bounding_box.width, layer.bounding_box.height
            };

            layer.update ();
        }
            
        return true;
    }

    public override bool button_release_event (Clutter.ButtonEvent event) {
        if (event.button == 1) {
            dragging = false;
            return true;
        }

        return false;
    }

    public override bool button_press_event (Clutter.ButtonEvent event) {
        if (event.button == 1) {
            drag_x = event.x;
            drag_y = event.y;
            start_box = layer.bounding_box;
            dragging = true;
            return true;
        }

        return false;
    }

    public override void paint () {
        base.paint ();
        layer.paint (doc);
    }

    void update_bounding_box () {
        set_position (layer.bounding_box.x, layer.bounding_box.y);
        set_size (layer.bounding_box.width, layer.bounding_box.height);
    }
}