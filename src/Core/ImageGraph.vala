

public class Core.ImageGraph : Object {
    public unowned Document document { get; construct; }
    public Gegl.Node master { get; construct; }

    public ImageGraph (Document document) {
        Object (document: document);
    }

    construct {
        master = new Gegl.Node ();
    }
}