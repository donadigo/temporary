


public class MainView : Gtk.Grid {
    NotebookView notebook_view;

    construct {
        notebook_view = new NotebookView ();

        var tab = new WorkspaceTab ();
        notebook_view.insert_tab (tab, 0);

        var paned = new Dazzle.DockPaned ();
        paned.orientation = Gtk.Orientation.HORIZONTAL;
        paned.add (notebook_view);

        add_layers.begin (tab);

        add (paned);
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

        for (int i = 0; i < 100; i++) {
            layer = new ImageLayer (tab.doc, File.new_for_path ("/home/donadigo/rect.png"));
            layer.blending_mode = BlendingMode.OVERLAY;
            yield add_layer (tab.doc, layer);
        }
    }

    async void add_layer (Document doc, Layer layer) {
        layer.ready.connect (() => {
            doc.layer_stack.append (layer);
            Idle.add (add_layer.callback);
        });

        yield;
    }
}