
using Core;

public class Widgets.CanvasView : Clutter.Actor {
    public Document doc { get; construct; }

    RenderPipeline pipeline;
    bool cached = false;

    public CanvasView (Document doc) {
        Object (doc: doc);
    }

    construct {
        background_color = Clutter.Color.get_static (Clutter.StaticColor.WHITE);
        reactive = true;

        pipeline = new RenderPipeline ();

        foreach (var layer in doc.layer_stack.get_unrolled ()) {
            add_layer (layer);
        }

        doc.layer_stack.added.connect ((layer) => {
            add_layer (layer);
        });

        doc.layer_stack.notify["dirty"].connect (() => {
            if (doc.layer_stack.dirty != null) {
                cached = false;
            }
        });

        doc.repaint.connect (queue_redraw);
        doc.layer_stack.selection_changed.connect (on_layer_stack_selection_changed);
    }


    public void update_size (float w, float h) {
        float pw, ph;
        pipeline.get_size (out pw, out ph);
        set_size (w, h);

        if (pw != (uint)w || ph != (uint)h) {
            pipeline.update ((int)w, (int)h);
        }

        cached = false;
    }

    public override bool event (Clutter.Event event) {
        var data = CanvasEventEventData () {
            canvas_view = this,
            event = event
        };

        EventBus.post<CanvasEventEventData?> (EventType.CANVAS_EVENT, data);
        return false;
    }

    public LayerActor? get_actor_by_layer (Layer? layer) {
        foreach (unowned Clutter.Actor actor in get_children ()) {
            if (((LayerActor)actor).layer == layer) {
                return (LayerActor)actor;
            }
        }

        return null;
    }

    //  public Gee.LinkedList<unowned LayerActor?> get_actors_for_items (Gee.LinkedList<unowned LayerStackItem> items) {
    //      var actors = new Gee.LinkedList<unowned LayerActor> ();
    //      foreach (unowned Clutter.Actor actor in get_children ()) {
    //          if (item is Layer) {

    //          } else {
    //              actors.add (null);
    //          }

            
    //      }

    //      return actors;
    //  }

    public override void paint () {
        if (doc.display_mode == GRAPH) {
            paint_graph ();
        } else {
            paint_actors ();
        }
    }

    private void paint_graph () {
        uint width, height;
        pipeline.get_size (out width, out height);

        var texture = new Cogl.Texture.from_data (
            (uint)doc.width, (uint)doc.height,
            Cogl.TextureFlags.NONE, Cogl.PixelFormat.RGBA_8888, Cogl.PixelFormat.ANY,
            4 * doc.width, doc.image.data
        );

        Cogl.set_source_texture (texture);
        Cogl.rectangle (0, 0, width, height);
    }

    private void paint_actors () {
        var timer = new Timer ();
        timer.start ();

        pipeline.begin_paint ();
        var dirty_layer = doc.layer_stack.dirty;
        if (dirty_layer != null) {
            int index = doc.layer_stack.get_index (dirty_layer);
            List<unowned Clutter.Actor> children = get_children ();
            if (!cached) {
                for (int i = 0; i < children.length (); i++) {
                    if (i == index) {
                        pipeline.cache_current ();
                        cached = true;
                    }

                    children.nth_data (i).paint ();
                }
            } else {
                print ("Painting from cache.\n");
                paint_from_cache (index);
            }
        } else {
            base.paint ();
        }

        var texture = pipeline.get_current_texture ();

        Cogl.set_source_texture (texture);
        Cogl.rectangle (0, 0, texture.get_width (), texture.get_height ());
        timer.stop ();
        print ("Paint took %f ms\n", (timer.elapsed () * 1000)); 
    }

    void paint_from_cache (int dirty_index) {
        pipeline.restore_cache ();
        List<unowned Clutter.Actor> children = get_children ();
        for (int i = dirty_index; i < children.length (); i++) {
            children.nth_data (i).paint ();
        }
    }

    void add_layer (Layer layer) {
        var actor = new LayerActor (doc, layer, pipeline);
        layer.repaint.connect (() => queue_redraw ());
        add_child (actor);
    }

    void on_layer_stack_selection_changed () {

    }
}