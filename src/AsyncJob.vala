


public class AsyncJob<G> : Object {
    public delegate void* JobCallback ();

    static int current_id = 0;
    static int jobs = 0;

    JobCallback cb;
    int id;

    public static async void queue (JobCallback cb) {
        var job = new AsyncJob<void*> (cb);
        yield job.run ();
    }

    public AsyncJob (JobCallback cb) {
        this.cb = cb;
        id = current_id++;
    }

    public async G run () {
        G result = null;
        result = new Thread<G> (id.to_string (), () => {
            while (AtomicInt.get (ref jobs) > 0);

            AtomicInt.add (ref jobs, 1);
            G res = cb ();
            Idle.add (run.callback);
            return res;
        });

        yield;
        jobs--;
        return (G)result;
    }
}