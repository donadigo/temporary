
using Core;

public class Widgets.MainView : Gtk.Grid {
    NotebookView notebook_view;
    ToolSettingsBar tool_settings_bar;

    construct {
        notebook_view = new NotebookView ();
        tool_settings_bar = new ToolSettingsBar ();

        var tool_widget = new ToolDockWidget ();

        var left_container = new DockContainer ();
        left_container.add_widget (tool_widget);

        var layer_widget = new LayerDockWidget ();
        var right_container = new DockContainer ();
        right_container.add_widget (layer_widget);

        var page_widget = new Dazzle.DockPaned ();
        page_widget.orientation = Gtk.Orientation.HORIZONTAL;

        var tab = new WorkspaceTab ();
        notebook_view.insert_tab (tab, 0);

        var paned = new Dazzle.DockPaned ();
        paned.orientation = Gtk.Orientation.HORIZONTAL;
        paned.add (left_container);
        paned.add (notebook_view);
        paned.add (right_container);

        add_layers.begin (tab);

        attach (tool_settings_bar, 0, 0, 1, 1);
        attach (paned, 0, 1, 1, 1);
    }

    public unowned WorkspaceTab? get_current_tab () {
        return (WorkspaceTab)notebook_view.current;
    }

    async void add_layers (WorkspaceTab tab) {
        var layer = new ImageLayer (tab.doc, File.new_for_path ("/usr/share/icons/elementary/status/64/dialog-error.svg"));
        layer.opacity = 0.5f;
        yield add_layer (tab.doc, layer);

        layer = new ImageLayer (tab.doc, File.new_for_path ("/home/donadigo/sample.jpeg"));
        yield add_layer (tab.doc, layer);

        layer = new ImageLayer (tab.doc, File.new_for_path ("/home/donadigo/sample.jpeg"));
        layer.blending_mode = BlendingMode.LINEAR_BURN;
        //  layer.opacity = 0.5f;
        yield add_layer (tab.doc, layer);

        for (int i = 0; i < 50; i++) {
            layer = new ImageLayer (tab.doc, File.new_for_path ("/home/donadigo/rect.png"));
            layer.blending_mode = BlendingMode.OVERLAY;
            yield add_layer (tab.doc, layer);
        }

        tab.ws_view.update_allocation ();
    }

    async void add_layer (Document doc, Layer layer) {
        layer.ready.connect (() => {
            doc.layer_stack.append (layer);
            Idle.add (add_layer.callback);
        });

        yield;
    }
}