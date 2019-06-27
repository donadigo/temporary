public abstract class Core.Service : Object {
    private static Gee.HashMap<Type, Service> services;

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

    public abstract bool activate (Widgets.CanvasView canvas_view, Gee.HashMap<string, Variant>? options);
    public abstract void deactivate ();
}