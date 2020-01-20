

public class Core.AsyncGraph : Object {
    public signal void progress (double val);
    protected void* group_id;

    protected Gegl.Node output;

    public AsyncGraph (Gegl.Node output) {
        this.output = output;
    }

    public virtual async Gegl.Node? process (Gegl.Rectangle? roi) {
        bool cancelled = false;
        AsyncJob.queue.begin (JobType.PROCESS_GRAPH, group_id, QueueFlags.CANCEL_ALL, (job) => {
            var processor = output.new_processor (null);

            double p = 0.0;
            while (!job.cancelled && processor.work (out p)) {
                progress (p);
            };

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

        return output;
    }
}