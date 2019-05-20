

public class Layer : Object {
    public Rectangle<int> bounding_box { get; set; }
    public signal void repaint ();

    public virtual void paint (Document document) {

    }

    public virtual void update () {

    }
}