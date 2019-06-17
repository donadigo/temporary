



public class Core.LayerStack : Object {
    public Gee.LinkedList<LayerStackItem> items { get; construct; }

    public signal void added (Layer layer);
    public signal void removed (Layer layer);
    public signal void selection_changed ();

    public Layer? dirty { get; private set; }
    public Gee.LinkedList<unowned LayerStackItem> selected { get; private set; }

    construct {
        items = new Gee.LinkedList<LayerStackItem> ();
        selected = new Gee.LinkedList<unowned LayerStackItem> ();
    }

    public void append (Layer layer) {
        items.add (layer);
        layer.notify["dirty"].connect (() => on_layer_dirty_changed ());
        added (layer);
    }

    public void set_selection (Gee.LinkedList<unowned LayerStackItem> selection) {
        selected = selection;
        selection_changed ();
    }

    public string create_name_for_layer (Layer layer) {
        return "Layer %u".printf (get_unrolled ().size + 1);
    }

    public int get_index (Layer layer) {
        for (int i = 0; i < items.size; i++) {
            if (items[i] == layer) {
                return i;
            }
        }

        return -1;
    }

    public unowned Layer? get_by_index (int index) {
        var unrolled = get_unrolled ();
        if (index < 0 || index > unrolled.size - 1) {
            return null;
        }
        
        return unrolled[index];
    }

    public Gee.LinkedList<unowned Layer> get_unrolled () {
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

    void on_layer_dirty_changed () {
        Idle.add (() => {
            foreach (unowned Layer layer in get_unrolled ()) {
                if (layer.dirty) {
                    dirty = layer;
                    break;
                }
            }

            return false;
        });
    }    
}