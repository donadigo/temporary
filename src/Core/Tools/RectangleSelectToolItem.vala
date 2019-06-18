


public class Core.RectangleSelectToolItem : ToolItem {
    public override string name {
        get {
            return _("Rectangular selection");
        }
    }

    public override string icon_name {
        get {
            return "tool-rectangle-select";
        }
    }

    public override void activate () {}
    public override void deactivate () {
        EventBus.get_default ().change_cursor ("default");
    }


    public override void handle_event (Widgets.CanvasView canvas_view, Clutter.Event event, Gee.LinkedList<unowned LayerStackItem> selected) {
        switch (event.type) {
            case ENTER:
                handle_enter (canvas_view, (Clutter.CrossingEvent)event, selected);
                break;
            case LEAVE:
                handle_leave (canvas_view, (Clutter.CrossingEvent)event, selected);
                break;
        }
    }

    void handle_enter (Widgets.CanvasView cv, Clutter.CrossingEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        EventBus.get_default ().change_cursor ("cell");
    }

    void handle_leave (Widgets.CanvasView cv, Clutter.CrossingEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        EventBus.get_default ().change_cursor ("default");
    }
}