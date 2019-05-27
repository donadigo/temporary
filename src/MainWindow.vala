public class CMainWindow : Gtk.ApplicationWindow {

    CHeaderBar header_bar;
    WorkspaceView ws_view;

    Document doc;

    public CMainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        header_bar = new CHeaderBar ();
        set_titlebar (header_bar);
        set_default_size (400, 400);

        doc = new Document (10000, 3000);

        add_layers ();

        ws_view = new WorkspaceView (doc);
        add (ws_view);
        show_all ();
    }

    async void add_layers () {
        var layer = new ImageLayer (doc, File.new_for_path ("/usr/share/icons/elementary/status/64/dialog-error.svg"));
        layer.opacity = 0.5f;
        yield add_layer (layer);

        layer = new ImageLayer (doc, File.new_for_path ("/home/donadigo/sample.jpeg"));
        yield add_layer (layer);

        layer = new ImageLayer (doc, File.new_for_path ("/home/donadigo/sample.jpeg"));
        layer.blending_mode = BlendingMode.LINEAR_BURN;
        //  layer.opacity = 0.5f;
        yield add_layer (layer);

        for (int i = 0; i < 100; i++) {
            layer = new ImageLayer (doc, File.new_for_path ("/home/donadigo/rect.png"));
            layer.blending_mode = BlendingMode.OVERLAY;
            yield add_layer (layer);
        }
    }

    async void add_layer (Layer layer) {
        layer.ready.connect (() => {
            doc.layer_stack.append (layer);
            Idle.add (add_layer.callback);
        });

        yield;
    }

}