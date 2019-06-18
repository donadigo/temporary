


public class Core.FreeSelectToolItem : ToolItem {
    public override string name {
        get {
            return _("Free selection");
        }
    }

    public override string icon_name {
        get {
            return "tool-free-select";
        }
    }

    public override void activate () {}
    public override void deactivate () {}


    public override void handle_event (Widgets.CanvasView canvas_view, Clutter.Event event, Gee.LinkedList<unowned LayerStackItem> selected) {

    }
}