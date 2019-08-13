

public class Core.ImageGraph : Object {
    public unowned Document document { get; construct; }
    public Gegl.Node master { get; construct; }
    Gegl.Node last;

    public ImageGraph (Document document) {
        Object (document: document);
    }

    construct {
        master = new Gegl.Node ();
        last = master;
    }

    public void add_layer (Layer layer) {
        var node = layer.connect_to_graph (master, last);
        last = node;
    }

    public async Gegl.Node? process (Gegl.Rectangle roi) {
        bool cancelled = false;
        AsyncJob.queue.begin (JobType.PROCESS_GRAPH, document, QueueFlags.CANCEL_ALL, (job) => {
            var processor = last.new_processor (null);

            double progress = 0.0;
            while (!job.cancelled && processor.work (out progress));
            if (job.cancelled) {
                cancelled = true;
                return null;
            }

            Idle.add (process.callback);
            return null;
        });

        yield;
        if (cancelled) {
            return null;
        }

        return last;
    }
}