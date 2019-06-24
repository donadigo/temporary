
using Core;

public class TransformTriggerActor : Clutter.Actor {
    public signal void delta (int x, int y);
    public signal void begin_resize ();

    unowned TransformActor tactor;

    string cursor_name;
    bool dragging = false;
    Gdk.Point start_point;

    public TransformTriggerActor (TransformActor tactor, string cursor_name, int width, int height) {
        this.tactor = tactor;

        this.cursor_name = cursor_name;
        set_size (width, height);
    }

    construct {
        reactive = true;
    }

    public void handle_motion_event (Clutter.MotionEvent event) {
        motion_event (event);
    }

    public void handle_button_release_event (Clutter.ButtonEvent event) {
        button_release_event (event);
    }

    public override bool button_press_event (Clutter.ButtonEvent event) {
        if (event.button != Gdk.BUTTON_PRIMARY) {
            return false;
        }

        EventBus.get_default ().freeze_cursor_changes (true);

        float x, y;
        Canvas.CanvasUtils.translate_to_stage (tactor.stage, event, out x, out y);

        begin_resize ();
        start_point = { (int)x, (int)y };
        dragging = true;
        return true;
    }

    public override bool button_release_event (Clutter.ButtonEvent event) {
        if (event.button != Gdk.BUTTON_PRIMARY) {
            return false;
        }

        dragging = false;
        return true;
    }

    public override bool enter_event (Clutter.CrossingEvent event) {
        EventBus.get_default ().change_cursor (cursor_name);
        return false;
    }

    public override bool motion_event (Clutter.MotionEvent event) {
        if (dragging) {
            float x, y;
            Canvas.CanvasUtils.translate_to_stage (tactor.stage, event, out x, out y);

            delta ((int)x - start_point.x, (int)y - start_point.y);
            return true;
        }

        return false;
    }

    public override bool leave_event (Clutter.CrossingEvent event) {
        if (!dragging) {
            unowned EventBus event_bus = EventBus.get_default ();
            event_bus.freeze_cursor_changes (false);
            event_bus.change_cursor ("default");
        }

        return false;
    }
}