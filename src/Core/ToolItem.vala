


public abstract class Core.ToolItem : Object {
    public abstract string name { get; }
    public abstract string icon_name { get; }

    public abstract void activate ();
    public abstract void deactivate ();
    public abstract void handle_event (Event<CanvasEventEventData?> event, Gee.LinkedList<unowned LayerStackItem> selected);
}