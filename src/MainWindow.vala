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

        EventBus.subscribe (EventType.CHANGE_CURSOR, on_change_cursor);
        EventBus.subscribe (EventType.DRAW_HIGHLIGHT, on_draw_highlight);
        EventBus.subscribe (EventType.FREEZE_CURSOR_CHANGES, on_freeze_cursor_changes);
    }

    void on_change_cursor (Event<ChangeCursorEventData?> event) {
        if (cursor_freezed) {
            return;
        }

        var cursor = new Gdk.Cursor.from_name (Gdk.Display.get_default (), event.data.name);
        unowned Gdk.Window window = event.data.window ?? get_window ();
        window.set_cursor (cursor);        
    }

    void on_freeze_cursor_changes (Event<FreezeCursorChangesEventData?> event) {
        cursor_freezed = event.data.freeze;
    }

    void on_draw_highlight (Event<DrawHighlightEventData?> event) {
        if (highlight_allocate_cb != event.data.allocate_cb) {
            highlight_opacity = 0;
        }

        highlight_allocate_cb = event.data.allocate_cb;
        Timeout.add (5, () => {
            highlight_opacity += HL_OPACITY_DELTA;
            queue_draw ();
            return highlight_opacity < HIGHTLIGHT_MAX_OPACITY;
        });

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