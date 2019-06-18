
using Core;

public class Widgets.CDockWindow : GlobalWindow {
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

    public delegate Gdk.Rectangle AllocateHighlightRectangleCb (Gtk.Widget toplevel);

    const uint HOVER_TIMEOUT = 500;
    const int MIN_HIGHLIGHT_SIZE = 10;
    uint hover_timeout_id = 0U;
    MoveStage move_stage = MoveStage.MOVE;

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
        bool intersects = false;
        foreach (var container in containers) {
            var crect = container.get_absolute_frame ();

            Gdk.Rectangle intersection;
            if (rect.intersect (crect, out intersection)) {
                stop_hover_timeout ();
                setup_hover_timeout (container);
                intersects = true;
                break;
            } else {
                stop_hover_timeout ();
            }
        }

        if (!intersects) {
            hide_highlight ();
        }

        return base.configure_event (event);
    }

    //  static inline bool rect_contains (Gdk.Rectangle rect, int x, int y) {
    //      return x >= rect.x && x <= rect.x + rect.width
    //          && y >= rect.y && y <= rect.y + rect.height;
    //  }

    void setup_hover_timeout (DockContainer container) {
        hover_timeout_id = Timeout.add (HOVER_TIMEOUT, () => {
            hover_timeout_id = 0U;
            current_hover = container;
            show_highlight ();
            return false;
        });
    }

    void stop_hover_timeout () {
        if (hover_timeout_id != 0U) {
            Source.remove (hover_timeout_id);
            hover_timeout_id = 0U;
        }
    }

    void show_highlight () {
        AllocateHighlightRectangleCb cb = (toplevel) => {
            int x = 0, y = 0;
            if (toplevel != null) {
                current_hover.translate_coordinates (toplevel, 0, 0, out x, out y);
            }

            Gtk.Allocation alloc;
            current_hover.get_allocation (out alloc);

            alloc.width = int.max (alloc.width, MIN_HIGHLIGHT_SIZE);
            alloc.height = int.max (alloc.height, MIN_HIGHLIGHT_SIZE);

            alloc.x = x;
            alloc.y = y;
            return alloc;
        };

        var data = DrawHighlightEventData () {
            allocate_cb = cb
        };

        EventBus.post<DrawHighlightEventData?> (EventType.DRAW_HIGHLIGHT, data);
    }

    void hide_highlight () {
        var data = DrawHighlightEventData () {
            allocate_cb = null
        };

        EventBus.post<DrawHighlightEventData?> (EventType.DRAW_HIGHLIGHT, data);
    }

    bool on_button_press_event (Gdk.EventButton event) {
        if (event.button == Gdk.BUTTON_PRIMARY && event.get_window () == get_titlebar ().get_window ()) {
            move_stage = MoveStage.GRAB;
            return true;
        }

        return base.button_press_event (event);
    }

    bool on_enter_notify_event (Gdk.EventCrossing event) {
        stop_hover_timeout ();
        hide_highlight ();

        if (event.get_window () != get_titlebar ().get_window () && move_stage == MoveStage.MOVE) {
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