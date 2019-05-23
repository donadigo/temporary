
public class Layer : Object, LayerStackItem {
    public bool visible { get; set; }
    public string name { get; set; }
    public float opacity { get; set; default = 1.0f; }
    public BlendingMode blending { get; set; }

    public Rectangle<int> bounding_box { get; set; }
    public signal void repaint ();

    public virtual void paint (Document document, LayerActor actor, Clutter.Matrix matrix) {

    }

    public virtual void update () {

    }
}