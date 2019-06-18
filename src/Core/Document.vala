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

    public float scale { get; set; default = 1.0f; }

    public signal void size_updated ();
    public signal void repaint ();

    construct {
        layer_stack = new LayerStack ();
        graph = new ImageGraph (this);
        image = new Image ();

        EventBus.subscribe (EventType.CANVAS_EVENT, on_canvas_event);
    }

    public Document (int width, int height) {
        Object (width: width, height: height);
    }

    public void enter_actor_mode () {
        display_mode = DisplayMode.ACTOR;
        repaint ();
    }

    public void process_graph () {
        AsyncJob.queue.begin (JobType.PROCESS_GRAPH, QueueFlags.CANCEL_ALL, (job) => {
            var graph = new Gegl.Node ();
            var current = graph;
            foreach (unowned Layer layer in layer_stack.get_unrolled ()) {
                current = layer.process (graph, current);
            }

            var roi = new Gegl.Rectangle (0, 0, width, height);

            //  var save = graph.create_child ("gegl:save");
            //  save.set_property ("path", "/home/donadigo/test.png");
            //  current.connect_to ("output", save, "input");

            var processor = current.new_processor (roi);

            double progress = 0.0;
            while (!job.cancelled && processor.work (out progress));
            if (job.cancelled) {
                return null;
            }

            image.allocate (width, height, 4);
            current.blit (1, roi, Formats.RGBA_u8, image.data, Gegl.AUTO_ROWSTRIDE, Gegl.BlitFlags.DEFAULT);
            Idle.add (() => {
                //  display_mode = DisplayMode.GRAPH;
                repaint ();
                return false;
            });

            return null;
        });
    }

    void on_canvas_event (Event<CanvasEventEventData?> event) {
        unowned ToolItem? current = ToolCollection.get_default ().active;
        if (current != null) {
            current.handle_event (event, layer_stack.selected);
        }
    }
}