


public class AsyncJob<G> : Object {
    public delegate void* JobCallback ();

    static int current_id = 0;

    JobCallback cb;
    int id;

    public AsyncJob (JobCallback cb) {
        this.cb = cb;
        id = current_id++;
    }

    public async G run () {
        G result = null;
        result = new Thread<G> (id.to_string (), () => {
            G res = cb ();
            Idle.add (run.callback);
            return res;
        });

        yield;
        return (G)result;
    }
}