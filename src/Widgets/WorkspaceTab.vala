

public class WorkspaceTab : Granite.Widgets.Tab {
    WorkspaceView ws_view;
    public Document doc { get; construct; }
 
    construct {
        doc = new Document (3000, 3000);
        ws_view = new WorkspaceView (doc);

        var tool_window = new ToolDockWidget ();

        var page_widget = new Dazzle.DockPaned ();
        page_widget.orientation = Gtk.Orientation.HORIZONTAL;
        page_widget.add (tool_window);
        page_widget.add (ws_view);

        page = page_widget;
    }
}