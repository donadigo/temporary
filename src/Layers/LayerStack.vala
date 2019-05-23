



public class LayerStack : Object {
    public Gee.LinkedList<LayerStackItem> items { get; construct; }

    public signal void added (Layer layer);
    public signal void removed (Layer layer);

    construct {
        items = new Gee.LinkedList<Layer> ();
    }

    public LayerStack () {

    }

    public void append (Layer layer) {
        items.add (layer);
        added (layer);
    }

    public int get_index (Layer layer) {
        for (int i = 0; i < items.size; i++) {
            if (items[i] == layer) {
                return i;
            }
        }

        return -1;
    }

    public Layer? get_by_index (int index) {
        var unrolled = get_unrolled ();
        if (index < 0 || index > unrolled.size - 1) {
            return null;
        }
        
        return unrolled[index];
    }

    public Gee.LinkedList<Layer> get_unrolled () {
        var unrolled = new Gee.LinkedList<Layer> ();
        foreach (var item in items) {
            if (item is LayerGroup) {
                unrolled.add_all (((LayerGroup)item).layers);
            } else if (item is Layer) {
                unrolled.add ((Layer)item);
            }
        }

        return unrolled;
    }
}