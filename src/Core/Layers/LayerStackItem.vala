

public interface LayerStackItem : Object { 
    public abstract bool visible { get; set; }
    public abstract string name { get; set; }
    public abstract float opacity { get; set; }
    public abstract BlendingMode blending_mode { get; set; }
}

public class LayerGroup : Object, LayerStackItem {
    public bool visible { get; set; }
    public string name { get; set; }
    public float opacity { get; set; default = 1.0f; }
    public BlendingMode blending_mode { get; set; }

    public Gee.LinkedList<Layer> layers { get; construct; }

}