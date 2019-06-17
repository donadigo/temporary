

using Core;

public class Widgets.WorkspaceTab : Granite.Widgets.Tab {
    WorkspaceView ws_view;
    public Document doc { get; construct; }
 
    construct {
        doc = new Document (3000, 3000);
        ws_view = new WorkspaceView (doc);

        var tool_widget = new ToolDockWidget ();

        var left_container = new DockContainer ();
        left_container.add_widget (tool_widget);

        var layer_widget = new LayerDockWidget (doc);
        var right_container = new DockContainer ();
        right_container.add_widget (layer_widget);

        var page_widget = new Dazzle.DockPaned ();
        page_widget.orientation = Gtk.Orientation.HORIZONTAL;
        page_widget.add (left_container);
        page_widget.add (ws_view);
        page_widget.add (right_container);

        page = page_widget;
    }
}