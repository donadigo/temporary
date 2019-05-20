

public class Document : Object {
    public string? filename { get; set; }
    public LayerStack layer_stack { get; construct; }
    //  public Gegl.Node root_node { get; construct; }
    //  public Gegl.Buffer buffer { get; construct; }

    construct {
        layer_stack = new LayerStack ();

    }
}