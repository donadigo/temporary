


public class CDockWindow : GlobalWindow {
    /**
     * Unfortunately Gtk does not provide a way to check
     * if moving a window is finished by the user.
     * 
     * We have to go through pre-defined stages and catch
     * specific events to know that.
     * 
     * At the beggining we set move_stage to MOVE since
     * when detaching a CDockWidget the window is in the move stage.
     */
    enum MoveStage {
        NONE = 0,
        GRAB = 1,
        MOVE = 2,
    }

    const uint HOVER_TIMEOUT = 200;
    //  uint hover_timeout_id = 0U;
    MoveStage move_stage = MoveStage.MOVE;
    bool escaped_source_dock = false;

    unowned DockContainer? current_hover = null;

    construct {
        skip_pager_hint = true;
        skip_taskbar_hint = true;
        resizable = true;
        deletable = false;
        type_hint = Gdk.WindowTypeHint.UTILITY;
        
        configure_event.connect (on_configure_event);
        button_press_event.connect (on_button_press_event);
        enter_notify_event.connect (on_enter_notify_event);
    }

    public void set_handle (Gtk.Widget handle) {
        set_titlebar (handle);
    }

    public CDockWidget? create_dock_widget () {
        var contents = get_child ();
        remove (contents);

        var widget = new CDockWidget ();
        widget.add_external (contents);

        return widget;
    }

    bool on_configure_event (Gdk.EventConfigure event) {
        unowned Gee.LinkedList<DockContainer> containers = DockContainer.get_all ();

        unowned Gdk.Window? window = get_window ();
        if (window == null) {
            return base.configure_event (event);
        }

        if (move_stage == MoveStage.GRAB) {
            move_stage = MoveStage.MOVE;
        }

        Gdk.Rectangle rect = {};
        get_position (out rect.x, out rect.y);
        get_size (out rect.width, out rect.height);

        /**
         * Extend the window rectangle by 1 so that it snaps to the right-most 
         * dock containers.
         */
        rect.width += 1;
        rect.height += 1;

        current_hover = null;
        foreach (var container in containers) {
            var crect = container.get_absolute_frame ();

            Gdk.Rectangle intersection;
            if (rect.intersect (crect, out intersection)) {
                current_hover = container;
                break;
            } else if (!escaped_source_dock) {
                escaped_source_dock = true;
                //  Source.remove (hover_timeout_id);
                //  hover_timeout_id = 0U;
            }
        }

        return base.configure_event (event);
    }

    //  static inline bool rect_contains (Gdk.Rectangle rect, int x, int y) {
    //      return x >= rect.x && x <= rect.x + rect.width
    //          && y >= rect.y && y <= rect.y + rect.height;
    //  }

    bool on_button_press_event (Gdk.EventButton event) {
        if (event.button == Gdk.BUTTON_PRIMARY && event.get_window () == get_titlebar ().get_window ()) {
            move_stage = MoveStage.GRAB;
            return true;
        }

        return base.button_press_event (event);
    }

    bool on_enter_notify_event (Gdk.EventCrossing event) {
        if (event.get_window () != get_titlebar ().get_window () && move_stage == MoveStage.MOVE && escaped_source_dock) {
            on_drop ();
            return true;
        }

        move_stage = MoveStage.NONE;
        return false;
    }
        
    void on_drop () {
        if (current_hover != null) {
            current_hover.add_widget (create_dock_widget ());
            destroy ();
        }
    }

    //  void on_hover (DockContainer container) {
    //      if (hover_timeout_id != 0U) {
    //          Source.remove (hover_timeout_id);
    //          hover_timeout_id = 0U;
    //      }

    //      hover_timeout_id = Timeout.add (HOVER_TIMEOUT, () => {
    //          hover_timeout_id = 0U;
    //          container.add_widget (create_dock_widget ());
    //          destroy ();
    //          return false;
    //      });
    //  }
}