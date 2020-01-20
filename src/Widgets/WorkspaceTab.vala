

using Core;

public class Widgets.WorkspaceTab : Granite.Widgets.Tab {
    public WorkspaceView ws_view { get; construct; }
    public Document doc { get; construct; }
 
    construct {
        doc = new Document (2000, 2000);
        ws_view = new WorkspaceView (doc);

        var page_widget = new Dazzle.DockPaned ();
        page_widget.orientation = Gtk.Orientation.HORIZONTAL;
        page_widget.add (ws_view);

        page = page_widget;

        EventBus.get_default ().current_document_changed (doc);
    }
}