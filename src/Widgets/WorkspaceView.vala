

using Core;

public class Widgets.WorkspaceView : Dazzle.DockBin {
    public Document doc { get; construct; }
    public CanvasView cv { get; construct; }
    public Clutter.Stage stage { get; construct; }

    GtkClutter.Embed embed;

    construct {
        can_focus = true;

        cv = new CanvasView (doc);
        cv.set_pivot_point (0.5f, 0.5f);

        embed = new GtkClutter.Embed ();
        embed.set_focus_on_click (true);
        embed.set_can_focus (true);
        stage = (Clutter.Stage)embed.get_stage ();
        stage.background_color = Clutter.Color.from_string ("#212326");
        stage.notify["allocation"].connect (update_allocation);

        stage.add_child (cv);
        stage.set_accept_focus (true);
        doc.notify["scale"].connect (update_allocation);

        add (embed);

        unowned EventBus event_bus = EventBus.get_default ();
        event_bus.focus_canvas.connect (on_focus_canvas);
        event_bus.force_redraw_canvas.connect (on_force_redraw_canvas);

        doc.layer_stack.selection_changed.connect (on_layer_stack_selection_changed);
    }

    public WorkspaceView (Document doc) {
        Object (doc: doc);
    }

    public void update_allocation () {
        float w, h;
        calculate_aspect_ratio_size_fit (doc.width, doc.height, stage.width, stage.height, out w, out h);

        float canvas_width = float.min (stage.width, w * doc.scale);
        float canvas_height = float.min (stage.height, h * doc.scale);
        Idle.add (() => {
            cv.update_size (canvas_width, canvas_height);
            return false;            
        });

        foreach (var child in cv.get_children ()) {
            child.set_scale (w * doc.scale / (float)doc.width, h * doc.scale / (float)doc.height);
        }

        cv.set_position (stage.get_width () / 2 - canvas_width / 2, stage.get_height () / 2 - canvas_height / 2);
    }

    //  void update_children_scale () {
    //      float w, h;
    //      calculate_aspect_ratio_size_fit (doc.width, doc.height, stage.width, stage.height, out w, out h);

    //      foreach (var child in cv.get_children ()) {
    //          child.set_scale (w * doc.scale / (float)doc.width, h * doc.scale / (float)doc.height);
    //      }
    //  }

    void on_focus_canvas (Document _doc) {
        if (_doc == doc) {
            embed.grab_focus ();
            stage.set_key_focus (cv);
        }
    }

    void on_force_redraw_canvas (Document _doc) {
        if (_doc == doc) {
            stage.redraw ();
        }        
    }

    void on_layer_stack_selection_changed () {
        //  if (doc.layer_stack.selected.size > 0) {
        //      var layer = (Layer)((Gee.LinkedList<unowned LayerStackItem>)doc.layer_stack.selected)[0];
        //      LayerTransformService.get_default ().activate (stage, cv, layer);
        //  }
    }

    // From https://opensourcehacker.com/2011/12/01/calculate-aspect-ratio-conserving-resize-for-images-in-javascript/
    static void calculate_aspect_ratio_size_fit (float src_width, float src_height, float max_width, float max_height,
		                                        out float width, out float height) {
        float ratio = float.min (max_width / src_width, max_height / src_height);
        width = src_width * ratio;
        height = src_height * ratio;
    }    
}