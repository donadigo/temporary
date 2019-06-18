



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
        added (layer);
    }

    public void get_best_display_settings (out float opacity, out BlendingMode mode) {
        if (selected.size == 1) {
            opacity = (float)selected[0].opacity;
            mode = selected[0].blending_mode;
        } else if (selected.size > 1) {
            float dominant_opacity = selected[0].opacity;
            var dominant_mode = selected[0].blending_mode;

            bool opacity_equal = true;
            bool mode_equal = true;
            for (int i = 1; i < selected.size; i++) {
                if (opacity_equal && selected[i].opacity != dominant_opacity) {
                    opacity_equal = false;
                }

                if (mode_equal && selected[i].blending_mode != dominant_mode) {
                    mode_equal = false;
                }

                if (!mode_equal && !opacity_equal) {
                    break;
                }
            }

            if (opacity_equal) {
                opacity = dominant_opacity;
            } else {
                opacity = 1.0f;
            }

            if (mode_equal) {
                mode = dominant_mode;
            } else {
                mode = BlendingMode.NORMAL;
            }
        } else {
            opacity = 1.0f;
            mode = BlendingMode.NORMAL;
        }
    }

    public void set_selection (Gee.LinkedList<unowned LayerStackItem> selection) {
        selected = selection;
        selection_changed ();
    }

    public void add_to_selection (Gee.LinkedList<unowned LayerStackItem> items) {
        selected.add_all (items);
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

    public void update_dirty () {
        foreach (unowned Layer layer in get_unrolled ()) {
            if (layer.dirty) {
                dirty = layer;
                break;
            }
        }
    }    
}