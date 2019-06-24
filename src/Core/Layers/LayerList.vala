

public class Core.LayerList : Gee.LinkedList<unowned LayerStackItem> {
    public Gee.LinkedList<unowned Layer> get_layers () {
        var layers = new Gee.LinkedList<unowned Layer> ();
        foreach (unowned LayerStackItem item in this) {
            if (item is Layer) {
                layers.add ((Layer)item);
            }
        }

        return layers;
    }
}