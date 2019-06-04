[Flags]
public enum QueueFlags {
    NONE = 0,
    CANCEL_ALL
}

public enum JobType {
    LOAD_FILE,
    PROCESS_GRAPH
}

public class Job {
    public AsyncJob.JobCallback callback;
    public int type;
    public int id;
    public bool cancelled;

    public signal void finished ();
}

public class AsyncJob : Object {
    public delegate void* JobCallback (Job job);    

    private Thread worker_thread;
    private Gee.LinkedList<Job?> jobs;

    private int current_id = 0;

    private static AsyncJob? instance;
    public static unowned AsyncJob get_default () {
        if (instance == null) {
            instance = new AsyncJob ();
        }

        return instance;
    }

    public static async void queue (int type, QueueFlags flags, JobCallback cb) {
        yield AsyncJob.get_default ()._queue_async (type, flags, cb);
    }

    construct {
        jobs = new Gee.LinkedList<Job?> ();
        worker_thread = new Thread<void*> ("job-worker", worker_func);
        current_id = 0;
    }

    private void* worker_func () {
        while (true) {
            if (jobs.size == 0) {
                Thread.@yield ();
                continue;
            }

            var job = jobs.poll_head ();
            job.callback (job);
            job.finished ();
        }

        return null;
    }

    internal Job _queue (int type, QueueFlags flags, JobCallback cb) {
        if (QueueFlags.CANCEL_ALL in flags) {
            cancel_all (type);
        }

        var job = new Job ();
        job.callback = cb;
        job.type = type;
        job.id = current_id++;
        jobs.add (job);
        return job;
    }

    internal async void _queue_async (int type, QueueFlags flags, JobCallback cb) {
        var job = _queue (type, flags, cb);
        job.finished.connect (() => {
            Idle.add (_queue_async.callback);
        });

        yield;
    }

    private void cancel_all (int type) {
        foreach (var job in jobs) {
            if (job.type == type) {
                job.cancelled = true;
            }
        }
    }
}