using Core;

public class Widgets.CMainWindow : GlobalWindow {
    public const string ACTION_PREFIX = "win.";
    public const string ACTION_TRANSFORM_CURRENT = "action_transform_current";
    public SimpleActionGroup actions { get; construct; }

    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    private const ActionEntry[] action_entries = {
        { ACTION_TRANSFORM_CURRENT, action_transform_current }
    };

    const double HIGHTLIGHT_MAX_OPACITY = 0.5;
    const double HL_OPACITY_DELTA = 0.02;

    CHeaderBar header_bar;
    //  HighlightOverlay highlight;
    MainView main_view;
    double highlight_opacity = 0.0;

    bool cursor_freezed = false;

    unowned CDockWindow.AllocateHighlightRectangleCb? highlight_allocate_cb;

    static construct {
        action_accelerators[ACTION_TRANSFORM_CURRENT] = "<Control>t";
    }

    public CMainWindow (Gtk.Application app) {
        Object (application: app);

        foreach (var action in action_accelerators.get_keys ()) {
            var accels_array = action_accelerators[action].to_array ();
            accels_array += null;

            app.set_accels_for_action (ACTION_PREFIX + action, accels_array);
        }
    }

    construct {
        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/donadigo/temporary");

        actions = new SimpleActionGroup ();
        actions.add_action_entries (action_entries, this);
        insert_action_group ("win", actions);

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

    void action_transform_current () {
        unowned WorkspaceTab? tab = main_view.get_current_tab ();
        if (tab == null) {
            return;
        }

        unowned LayerTransformService service = LayerTransformService.get_default ();
        service.deactivate_current ();
        
        foreach (unowned Layer layer in tab.ws_view.doc.layer_stack.selected.get_layers ()) {
            service.activate (tab.ws_view.stage, tab.ws_view.cv, layer);
        }
    }
}