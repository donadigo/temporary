
public abstract class Core.Layer : Object, LayerStackItem {
    public unowned Document doc { get; construct; }
    public bool visible { get; set; default = true; }
    public bool locked { get; set; default = false; }
    public string name { get; set; default = _("Layer"); }
    public float opacity { get; set; default = 1.0f; }
    public BlendingMode blending_mode { get; set; default = BlendingMode.NORMAL; }

    public Gegl.Rectangle bounding_box { get; protected set; }
    public signal void repaint ();
    public signal void bounding_box_updated ();
    public signal void ready ();

    // Dirty = is in the actor mode
    public bool dirty { get; set; default = false; }

    static Cogl.Material screen_material;
    int freeze_count = 0;

    static construct {
        screen_material = new Cogl.Material ();
        screen_material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        screen_material.set_layer_filters (1, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        CoglFixes.set_user_program (screen_material, BlendingShader.get_default ().program);
    }

    public virtual void update_bounding_box (Gegl.Rectangle new_bb) {
        bounding_box = new_bb;
        bounding_box_updated ();
    }

    public virtual void move_bounding_box (int xoff, int yoff) {
        bounding_box.x += xoff;
        bounding_box.y += yoff;
        bounding_box_updated ();
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

    public abstract Gegl.Node connect_to_graph (Gegl.Node graph, Gegl.Node source);
    public abstract async Gdk.Pixbuf? create_pixbuf (int width);

    public void update () {
        if (freeze_count > 0) {
            return;
        }

        update_internal ();
    }

    public virtual void update_internal () {
        
    }

    public void freeze_updates () {
        freeze_count++;
    }

    public void thaw_updates () {
        freeze_count--;
    }
}