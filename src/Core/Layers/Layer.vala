
public abstract class Layer : Object, LayerStackItem {
    public bool visible { get; set; }
    public string name { get; set; }
    public float opacity { get; set; default = 1.0f; }
    public BlendingMode blending_mode { get; set; default = BlendingMode.NORMAL; }

    public Gegl.Rectangle bounding_box { get; set; }
    public signal void repaint ();
    public signal void ready ();

    // Dirty = is in the actor mode
    public bool dirty { get; set; default = false; }

    public Gegl.Node node { get; protected set; }

    static Cogl.Material screen_material;

    static construct {
        screen_material = new Cogl.Material ();
        screen_material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        screen_material.set_layer_filters (1, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        CoglFixes.set_user_program (screen_material, BlendingShader.get_default ().program);
    }

    public virtual void paint_content (Document document, LayerActor actor) {

    }

    public virtual void paint (Document document, LayerActor actor) {
        BlendingShader.get_default ().set_mode (blending_mode);
        unowned Cogl.Texture current = actor.pipeline.get_current_texture ();
        unowned Cogl.Texture layer = actor.pipeline.get_layer_texture ();
        screen_material.set_layer (0, current);
        screen_material.set_layer (1, layer);
        Cogl.set_source (screen_material);

        Cogl.rectangle (0, 0, current.get_width (), current.get_height ());
    }

    public abstract Gegl.Node process (Gegl.Node graph, Gegl.Node source);

    public virtual void update () {

    }
}