


public class Core.DrawPathToolItem : ToolItem {
    public override string name {
        get {
            return _("Draw a path");
        }
    }

    public override string icon_name {
        get {
            return "draw-path";
        }
    }

    public override void activate () {}
    public override void deactivate () {}

    public override void handle_event (Widgets.CanvasView canvas_view, Clutter.Event event, Gee.LinkedList<unowned LayerStackItem> selected) {

    }
}