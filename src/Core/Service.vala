public abstract class Core.Service : Object {
    private static Gee.HashMap<Type, Service> services;

    public bool activated { get; set; default = false; }

    public static void init () {
        services = new Gee.HashMap<Type, Service> ();

        register (new LayerTransformService ());
    }

    public static void register (Service service) {
        services[service.get_type ()] = service;
    }

    public new static T? get<T> (Type type) {
        return services[type];
    }

    public virtual bool activate (Widgets.CanvasView canvas_view, Gee.HashMap<string, Variant>? options) {
        activated = true;
        return true;
    }

    public virtual void deactivate () {
        activated = false;
    }
}