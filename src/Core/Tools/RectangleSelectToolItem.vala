


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
        EventBusUtils.change_cursor ("default");
    }


    public override void handle_event (Event<CanvasEventEventData?> event, Gee.LinkedList<unowned LayerStackItem> selected) {
        switch (event.data.event.type) {
            case ENTER:
                handle_enter (event.data.canvas_view, (Clutter.CrossingEvent)event.data.event, selected);
                break;
            case LEAVE:
                handle_leave (event.data.canvas_view, (Clutter.CrossingEvent)event.data.event, selected);
                break;
        }
    }

    void handle_enter (Widgets.CanvasView cv, Clutter.CrossingEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        EventBusUtils.change_cursor ("cell");
    }

    void handle_leave (Widgets.CanvasView cv, Clutter.CrossingEvent event, Gee.LinkedList<unowned LayerStackItem> selected) {
        EventBusUtils.change_cursor ("default");
    }
}