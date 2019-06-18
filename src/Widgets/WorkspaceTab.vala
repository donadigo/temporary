

using Core;

public class Widgets.WorkspaceTab : Granite.Widgets.Tab {
    WorkspaceView ws_view;
    public Document doc { get; construct; }
 
    construct {
        doc = new Document (2000, 2000);
        ws_view = new WorkspaceView (doc);

        var tool_widget = new ToolDockWidget ();

        var left_container = new DockContainer ();
        left_container.add_widget (tool_widget);

        var layer_widget = new LayerDockWidget ();
        var right_container = new DockContainer ();
        right_container.add_widget (layer_widget);

        var page_widget = new Dazzle.DockPaned ();
        page_widget.orientation = Gtk.Orientation.HORIZONTAL;
        page_widget.add (ws_view);

        page = page_widget;

        EventBus.get_default ().current_document_changed (doc);
    }
}