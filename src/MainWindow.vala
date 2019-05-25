public class CMainWindow : Gtk.ApplicationWindow {

    CHeaderBar header_bar;
    WorkspaceView ws_view;

    public CMainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        header_bar = new CHeaderBar ();
        set_titlebar (header_bar);
        set_default_size (400, 400);

        var doc = new Document (10000, 3000);

        var layer = new ImageLayer (File.new_for_path ("/home/donadigo/sample.jpeg"));
        layer.ready.connect (() => {
            doc.layer_stack.append (layer);
            var layer2 = new ImageLayer (File.new_for_path ("/home/donadigo/rect.png"));
            layer2.opacity = 0.5f;
            layer2.ready.connect (() => {
                doc.layer_stack.append (layer2);

                var layer3 = new ImageLayer (File.new_for_path ("/home/donadigo/Apps.png"));
                layer3.ready.connect (() => doc.layer_stack.append (layer3));                
            });    
        });

        for (int i = 0; i < 50; i++) {
            var layer2 = new ImageLayer (File.new_for_path ("/home/donadigo/rect.png"));
            doc.layer_stack.append (layer2);

        }

        //  layer2.opacity = 0.6f;

        ws_view = new WorkspaceView (doc);
        add (ws_view);
        show_all ();
    }

}