


public class Core.AutoSelectToolItem : ToolItem {
    public override string name {
        get {
            return _("Magic wand");
        }
    }

    public override string icon_name {
        get {
            return "image-auto-adjust";
        }
    }

    public override void activate () {}
    public override void deactivate () {}

    public override void handle_event (Event<CanvasEventEventData?> event, Gee.LinkedList<unowned LayerStackItem> selected) {

    }

}