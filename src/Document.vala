

public class Document : Object {
    public string? filename { get; set; }
    public LayerStack layer_stack { get; construct; }
    //  public Gegl.Node root_node { get; construct; }
    //  public Gegl.Buffer buffer { get; construct; }
    public int width { get; construct set; }
    public int height { get; construct set; }


    public signal void size_updated ();

    construct {
        layer_stack = new LayerStack ();
    }

    public Document (int width, int height) {
        Object (width: width, height: height);
    }
}