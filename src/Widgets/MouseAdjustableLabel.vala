
using Core;

public class Widgets.MouseAdjustableLabel : Gtk.EventBox {
    public Gtk.Label label { get; construct; }
    public signal void step (int step);
    public int resolution { get; construct; }

    int prev_step = 0;

    Gdk.Point start_pos;

    public MouseAdjustableLabel (string _label, int resolution) {
        Object (resolution: resolution);
        label.label = _label;
    }

    construct {
        add_events (Gdk.EventMask.ENTER_NOTIFY_MASK |
                    Gdk.EventMask.LEAVE_NOTIFY_MASK |
                    Gdk.EventMask.BUTTON_PRESS_MASK |
                    Gdk.EventMask.BUTTON_RELEASE_MASK);
        label = new Gtk.Label (null);
        add (label);
    }

    public override bool enter_notify_event (Gdk.EventCrossing event) {
        EventBus.get_default ().change_cursor ("pointer");
        return true;
    }

    public override bool motion_notify_event (Gdk.EventMotion event) {
        int delta_x = (int)event.x - start_pos.x;
        int _step = delta_x / resolution;
        if (_step != prev_step) {
            step (_step - prev_step);
            prev_step = _step;
        }
        
        return true;
    }

    public override bool leave_notify_event (Gdk.EventCrossing event) {
        EventBus.get_default ().change_cursor ("default");
        return true;
    }

    public override bool button_press_event (Gdk.EventButton event) {
        prev_step = 0;
        start_pos = { (int)event.x, (int)event.y };

        unowned EventBus event_bus = EventBus.get_default ();
        event_bus.change_cursor ("col-resize");
        event_bus.freeze_cursor_changes (true);
        return true;
    }

    public override bool button_release_event (Gdk.EventButton event) {
        EventBus.get_default ().freeze_cursor_changes (false);
        return true;
    }
}