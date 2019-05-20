



public class LayerStack : Object {
    public Gee.LinkedList<Layer> layers { get; construct; }

    public signal void added (Layer layer);
    public signal void removed (Layer layer);

    construct {
        layers = new Gee.LinkedList<Layer> ();
    }

    public LayerStack () {

    }

    public void append (Layer layer) {
        layers.add (layer);
        added (layer);
    }
}