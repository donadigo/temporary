

public class Core.DocumentGraph : AsyncGraph {
    public unowned Document document { get; construct; }
    public Gegl.Node master { get; construct; }

    public DocumentGraph (Document document) {
        Object (document: document);
    }

    construct {
        group_id = document;

        master = new Gegl.Node ();
        output = master;
    }

    public void add_layer (Layer layer) {
        var node = layer.connect_to_graph (master, output);
        output = node;
    }
}