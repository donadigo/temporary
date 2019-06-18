
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
        EventBusUtils.change_cursor ("pointer");
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
        EventBusUtils.change_cursor ("default");
        return true;
    }

    public override bool button_press_event (Gdk.EventButton event) {
        prev_step = 0;
        start_pos = { (int)event.x, (int)event.y };

        EventBusUtils.change_cursor ("col-resize");
        var data = FreezeCursorChangesEventData () {
            freeze = true
        };

        EventBus.post<FreezeCursorChangesEventData?> (EventType.FREEZE_CURSOR_CHANGES, data);
        return true;
    }

    public override bool button_release_event (Gdk.EventButton event) {
        var data = FreezeCursorChangesEventData () {
            freeze = false
        };

        EventBus.post<FreezeCursorChangesEventData?> (EventType.FREEZE_CURSOR_CHANGES, data);
        return true;
    }
}