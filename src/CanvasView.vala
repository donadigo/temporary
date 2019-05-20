

public class CanvasView : ReactiveActor {
    public Document doc { get; construct; }

    public CanvasView (Document doc) {
        Object (doc: doc);
    }

    construct {
        background_color = Clutter.Color.get_static (Clutter.StaticColor.WHITE);
        reactive = true;

        //  uint8[] data = doc.buffer.introspectable_get (doc.buffer.get_extent (), 1.0, null, 0);
        //  print (data.length.to_string () + "\n");

        //  uint8[] buff = {};
        //  doc.buffer.get ("pixels", out buff);
        foreach (var layer in doc.layer_stack.layers) {
            add_layer (layer);
        }

        doc.layer_stack.added.connect ((layer) => {
            add_layer (layer);
        });
    }

    void add_layer (Layer layer) {
        var actor = new LayerActor (doc, layer);
        layer.repaint.connect (() => queue_redraw ());
        add_child (actor);
    }

    //  public override bool button_press_event (Clutter.ButtonEvent event) {
    //          print ("BUTTON".to_string () + "\n");
    //      //  if (event.button == 2) {
    //      //  }

    //      return false;
    //  }
    //  public override void paint () {
    //      base.paint ();

    //      foreach (var layer in doc.layer_stack.layers) {
    //          layer.paint (doc);
    //      }
    //  }
}