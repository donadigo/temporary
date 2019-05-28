

public class Document : Object {
    public string? filename { get; set; }
    public LayerStack layer_stack { get; construct; }
    public ImageGraph graph { get; construct; }
    public int width { get; construct set; }
    public int height { get; construct set; }

    public signal void size_updated ();

    construct {
        layer_stack = new LayerStack ();
        graph = new ImageGraph (this);
    }

    public Document (int width, int height) {
        Object (width: width, height: height);
    }

    public void process_graph () {
        AsyncJob.queue (() => {
            var graph = new Gegl.Node ();
            foreach (unowned Layer layer in layer_stack.get_unrolled ()) {
                graph = layer.process (graph);
            }

            //  var save = graph.create_child ("gegl:save");
            //  save.set_property ("path", "/home/donadigo/test.png");
            //  graph.connect_to ("output", save, "input");

            //  save.process ();

            return null;
        });
    }
}