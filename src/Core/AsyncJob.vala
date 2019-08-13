[Flags]
public enum Core.QueueFlags {
    NONE = 0,
    CANCEL_ALL
}

public enum Core.JobType {
    LOAD_FILE,
    PROCESS_GRAPH,
    COMPOSITE_PIXBUF
}

public class Core.AsyncJob : Object {
    public class Job {
        public unowned AsyncJob.JobCallback callback;
        public uint16 type;
        public void* group_id;
        public int id;
        public bool cancelled;

        public signal void finished ();
    }

    public delegate void* JobCallback (Job job);    

    private Thread worker_thread;
    private Gee.LinkedList<Job?> jobs;
    private bool running = true;

    private int current_id = 0;

    private static AsyncJob? instance;
    public static unowned AsyncJob get_default () {
        if (instance == null) {
            instance = new AsyncJob ();
        }

        return instance;
    }

    public static async void queue (uint16 type, void* group_id, QueueFlags flags, JobCallback cb) {
        yield AsyncJob.get_default ()._queue_async (type, group_id, flags, cb);
    }

    construct {
        jobs = new Gee.LinkedList<Job?> ();
        worker_thread = new Thread<void*> ("job-worker", worker_func);
        current_id = 0;
    }

    ~AsyncJob () {
        running = false;
    }

    private void* worker_func () {
        while (running) {
            lock (jobs) {
                if (jobs.size == 0) {
                    Thread.@yield ();
                    continue;
                }

                var job = jobs.poll_head ();
                job.callback (job);
                job.finished ();
            }
        }

        return null;
    }

    internal Job _queue (uint16 type, void* group_id, QueueFlags flags, JobCallback cb) {
        if (QueueFlags.CANCEL_ALL in flags) {
            cancel_all (type, group_id);
        }

        var job = new Job ();
        job.callback = cb;
        job.type = type;
        job.group_id = group_id;
        job.id = current_id++;

        lock (jobs) {
            jobs.add (job);
        }

        return job;
    }

    internal async void _queue_async (uint16 type, void* group_id, QueueFlags flags, JobCallback cb) {
        var job = _queue (type, group_id, flags, cb);
        job.finished.connect (() => {
            Idle.add (_queue_async.callback);
        });

        yield;
    }

    private void cancel_all (uint16 type, void* group_id) {
        foreach (var job in jobs) {
            if (job.type == type && (group_id == null || job.group_id == group_id)) {
                job.cancelled = true;
            }
        }
    }
}