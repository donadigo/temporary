using Core;

public class Widgets.DockHandle : Gtk.EventBox {
    public signal void detached (Gdk.EventMotion event);
    public Gdk.Point relative_start;

    const int DETACH_DISTANCE = 25;

    bool dragging = false;
    Gdk.Point start;

    construct {
        attach ();    
    }

    public void attach () {
        add_events (Gdk.EventMask.KEY_PRESS_MASK | Gdk.EventMask.KEY_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK);
        button_press_event.connect (on_handle_button_press_event);
        button_release_event.connect (on_handle_button_release_event);
        motion_notify_event.connect (on_handle_motion_notify_event);
    }

    public void detach () {
        button_press_event.disconnect (on_handle_button_press_event);
        button_release_event.disconnect (on_handle_button_release_event);
        motion_notify_event.disconnect (on_handle_motion_notify_event);
    }

    private bool on_handle_button_press_event (Gdk.EventButton event) {
        if (event.button == 1) {
            dragging = true;
            start = { (int)event.x, (int)event.y };

            double cx, cy;
            event.get_coords (out cx, out cy);
            relative_start = { (int)cx, (int)cy };
            EventBus.get_default ().change_cursor ("grabbing", get_window ());
        }

        return true;
    }

    private bool on_handle_button_release_event (Gdk.EventButton event) {
        if (dragging && event.button == 1) {
            dragging = false;
            EventBus.get_default ().change_cursor ("default", get_window ());
        }
        
        return true;
    }

    private bool on_handle_motion_notify_event (Gdk.EventMotion event) {
        if (dragging) {
            Gdk.Point p = { (int)event.x, (int)event.y };
            if (distance (start, p) > DETACH_DISTANCE) {
                detach ();
                detached (event);
                dragging = false;
            }
        }

        return true;
    }

    private static double distance (Gdk.Point p1, Gdk.Point p2) {
        return Math.sqrt (Math.pow (p2.x - p1.x, 2) + Math.pow (p2.y - p1.y, 2));
    }    
}