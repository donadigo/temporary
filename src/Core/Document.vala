public enum Core.DisplayMode {
    ACTOR,
    GRAPH
}

public class Core.Document : Object {
    public string? filename { get; set; }
    public LayerStack layer_stack { get; construct; }
    public ImageGraph graph { get; construct; }
    public int width { get; construct set; }
    public int height { get; construct set; }
    public DisplayMode display_mode { get; set; default = DisplayMode.ACTOR; }
    public Image image { get; construct; }

    public uint64 id { get; construct; }

    public float scale { get; set; default = 1.0f; }

    public signal void size_updated ();
    public signal void repaint ();

    static uint64 current_id = 0U;

    construct {
        id = current_id++;

        layer_stack = new LayerStack ();
        layer_stack.added.connect (on_layer_stack_added);
        graph = new ImageGraph (this);
        image = new Image ();

        EventBus.get_default ().canvas_event.connect (on_canvas_event);
    }

    public Document (int width, int height) {
        Object (width: width, height: height);
    }

    public void enter_actor_mode () {
        display_mode = DisplayMode.ACTOR;
        repaint ();
    }

    public void process_graph () {
        var roi = new Gegl.Rectangle (0, 0, width, height);
        graph.process.begin (roi, (obj, res) => {
            var node = graph.process.end (res);
            if (node != null) {
                Idle.add (() => {
                    image.allocate (width, height, 4);

                    node.blit (1, roi, Formats.RGBA_u8, image.data, Gegl.AUTO_ROWSTRIDE, Gegl.BlitFlags.DEFAULT);
                    display_mode = DisplayMode.GRAPH;
                    repaint ();
                    return false;    
                });

                //  var save = node.create_child ("gegl:save");
                //  node.connect_to ("output", save, "input");
                //  save.set_property ("path", "/home/donadigo/test.png");
                //  save.process ();
            }
        });
    }

    void on_layer_stack_added (Layer layer) {
        graph.add_layer (layer);
    }

    void on_canvas_event (Widgets.CanvasView cv, Clutter.Event event) {
        unowned ToolItem? current = ToolCollection.get_default ().active;
        if (current != null) {
            current.handle_event (cv, event, layer_stack.selected);
        }
    }
}