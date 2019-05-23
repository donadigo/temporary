
public class CanvasView : Clutter.Actor {
    public Document doc { get; construct; }

    private Cogl.Texture texture;
    private RenderPipeline pipeline;

    public CanvasView (Document doc) {
        Object (doc: doc);
    }

    construct {
        background_color = Clutter.Color.get_static (Clutter.StaticColor.BLACK);
        reactive = true;

        doc.size_updated.connect (on_doc_size_updated);
        on_doc_size_updated ();

        pipeline = new RenderPipeline (this);

        foreach (var layer in doc.layer_stack.get_unrolled ()) {
            add_layer (layer);
        }

        doc.layer_stack.added.connect ((layer) => {
            add_layer (layer);
        });
    }

    void add_layer (Layer layer) {
        var actor = new LayerActor (doc, layer, pipeline);
        layer.repaint.connect (() => queue_redraw ());
        add_child (actor);
    }

    void on_doc_size_updated () {
        //  set_size (doc.width, doc.height);
        set_size (1000, 1000);
    }

    bool done = false;
    public override void paint () {
        //  if (!done) {
        //  pipeline.begin_paint ();
        //  base.paint ();
        //  }

        pipeline.begin_paint ();
        //  base.paint ();
        foreach (var child in get_children ()) {
            child.paint ();
        }

        var texture = pipeline.get_current_texture ();
        Cogl.set_source_texture (texture);
        Cogl.rectangle (0, 0, texture.get_width (), texture.get_height ());
        //  doc.material = new Cogl.Material ();
        //  Cogl.push_framebuffer ((Cogl.Framebuffer)doc.fbo);
        //  Cogl.clear (new Cogl.Color.from_4ub (0,0,0,0), Cogl.BufferBit.COLOR);
        //  Cogl.pop_framebuffer ();

        //  base.paint ();
        //  Cogl.set_source_texture (doc.texture);
        //  Cogl.rectangle (0, 0, doc.texture.get_width (), doc.texture.get_height ());
    }
}