using Core;

public class Widgets.CMainWindow : GlobalWindow {
    const double HIGHTLIGHT_MAX_OPACITY = 0.5;
    const double HL_OPACITY_DELTA = 0.02;

    CHeaderBar header_bar;
    //  HighlightOverlay highlight;
    MainView main_view;
    double highlight_opacity = 0.0;

    bool cursor_freezed = false;

    unowned CDockWindow.AllocateHighlightRectangleCb? highlight_allocate_cb;

    public CMainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/donadigo/temporary");

        header_bar = new CHeaderBar ();
        set_titlebar (header_bar);
        set_default_size (800, 800);

        main_view = new MainView ();

        add (main_view);
        show_all ();

        unowned EventBus event_bus = EventBus.get_default ();
        event_bus.change_cursor.connect (on_change_cursor);
        event_bus.draw_highlight.connect (on_draw_highlight);
        event_bus.freeze_cursor_changes.connect (on_freeze_cursor_changes);
    }

    void on_change_cursor (string name, Gdk.Window? window = null) {
        if (cursor_freezed) {
            return;
        }

        var cursor = new Gdk.Cursor.from_name (Gdk.Display.get_default (), name);
        var _window = window ?? get_window ();
        _window.set_cursor (cursor);        
    }

    void on_freeze_cursor_changes (bool freeze) {
        cursor_freezed = freeze;
    }

    void on_draw_highlight (DrawHighlightEventData data) {
        if (highlight_allocate_cb != data.allocate_cb) {
            highlight_opacity = 0;
        }

        highlight_allocate_cb = data.allocate_cb;
        if (highlight_allocate_cb == null) {
            queue_draw ();
        } else {
            Timeout.add (5, () => {
                highlight_opacity += HL_OPACITY_DELTA;
                queue_draw ();
                return highlight_opacity < HIGHTLIGHT_MAX_OPACITY;
            });
        }
    }

    public override bool draw (Cairo.Context cr) {
        bool result = base.draw (cr);

        // TODO: figure how to draw over Clutter.Stage
        if (highlight_allocate_cb != null) {
            var rect = highlight_allocate_cb (this);

            cr.set_source_rgba (100 / 255.0, 186 / 255.0, 255 / 255.0, highlight_opacity);
            cr.rectangle (rect.x, rect.y, rect.width, rect.height);
            cr.fill ();
        }

        return result;
    }
}