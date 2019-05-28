

public class WorkspaceTab : Granite.Widgets.Tab {
    WorkspaceView ws_view;
    public Document doc { get; construct; }
 
    construct {
        doc = new Document (1000, 1000);
        ws_view = new WorkspaceView (doc);

        var page_widget = new Gtk.Grid ();
        page_widget.add (ws_view);

        page = page_widget;
    }
}