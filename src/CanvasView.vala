
public class CanvasView : Clutter.Actor {
    public Document doc { get; construct; }

    RenderPipeline pipeline;

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
        set_size (2000, 1000);
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