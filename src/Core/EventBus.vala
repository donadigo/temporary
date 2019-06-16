
public class EventBus : Object {
    struct Subscriber {
        EventType flags;
        unowned ReceiveCallback callback;
    }

    Gee.HashMap<uint, Subscriber?> subscribers;
    uint current_id = 1U;

    public delegate void ReceiveCallback (Event event);

    static EventBus? instance = null;
    public static unowned EventBus get_default () {
        if (instance == null) {
            instance = new EventBus ();
        }

        return instance;
    }

    public static uint subscribe (EventType flags, ReceiveCallback callback) {
        return get_default ()._subscribe (flags, callback);
    }

    public static void post<G> (EventType type, G data) {
        var event = Event<G> () {
            type = type,
            data = data
        };
        get_default ()._post (event);
    }

    construct {
        subscribers = new Gee.HashMap<uint, Subscriber?> ();
    }

    protected EventBus () {

    }

    internal uint _subscribe (EventType flags, ReceiveCallback callback) {
        var sub = Subscriber () {
            flags = flags,
            callback = callback
        };

        subscribers[current_id] = sub;
        return current_id++;

    }

    internal void _post (Event event) {
        foreach (var sub in subscribers.values) {
            if (event.type in sub.flags) {
                sub.callback (event);
            }
        }
    }
}