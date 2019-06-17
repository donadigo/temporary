

using Core;

public class GlobalWindow : Gtk.Window {
    public override bool key_press_event (Gdk.EventKey event) {
        GlobalKeyState.mark_pressed (event.keyval);
        return base.key_press_event (event);
    }

    public override bool key_release_event (Gdk.EventKey event) {
        GlobalKeyState.mark_released (event.keyval);
        return base.key_release_event (event);
    }
}