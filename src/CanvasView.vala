
public class CanvasView : Clutter.Actor {
    public Document doc { get; construct; }

    RenderPipeline pipeline;

    public CanvasView (Document doc) {
        Object (doc: doc);
    }

    construct {
        background_color = Clutter.Color.get_static (Clutter.StaticColor.BLACK);
        reactive = true;

        pipeline = new RenderPipeline ();

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

    public void update_size (float w, float h) {
        float pw, ph;
        pipeline.get_size (out pw, out ph);
        set_size (w, h);

        if (pw != (uint)w || ph != (uint)h) {
            pipeline.update ((int)w, (int)h);
        }
    }

    public override void paint () {
        var timer = new Timer ();
        timer.start ();

        pipeline.begin_paint ();
        base.paint ();
        var texture = pipeline.get_current_texture ();

        Cogl.set_source_texture (texture);
        Cogl.rectangle (0, 0, texture.get_width (), texture.get_height ());
        timer.stop ();
        print ("Paint took %f ms\n", (timer.elapsed () * 1000)); 
    }
}