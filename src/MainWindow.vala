
public class CMainWindow : Gtk.ApplicationWindow {

    CHeaderBar header_bar;
    WorkspaceView ws_view;

    public CMainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        header_bar = new CHeaderBar ();
        set_titlebar (header_bar);

        var doc = new Document ();

        //  var layer = new ImageLayer (File.new_for_path ("/home/donadigo/testbg.png"));
        //  layer.ready.connect (() => doc.layer_stack.append (layer));

        var layer2 = new ImageLayer (File.new_for_path ("/home/donadigo/Obrazy/actions.png"));
        layer2.ready.connect (() => doc.layer_stack.append (layer2));


        ws_view = new WorkspaceView (doc);
        add (ws_view);

        show_all ();
    }

}