

public class WorkspaceView : Dazzle.DockBin {
    public Document doc { get; construct; }
    CanvasView cv;
    Clutter.Stage stage;

    float scale = 1.0f;

    construct {
        cv = new CanvasView (doc);
        cv.set_pivot_point (0.5f, 0.5f);

        var embed = new GtkClutter.Embed ();
        stage = (Clutter.Stage)embed.get_stage ();
        stage.background_color = Clutter.Color.from_string ("#282828");
        stage.notify["allocation"].connect (on_allocation_changed);

        stage.add_child (cv);
        cv.update_size (stage.get_width (), stage.get_height ());

        add (embed);
        on_allocation_changed ();
    }

    public WorkspaceView (Document doc) {
        Object (doc: doc);
    }

    void on_allocation_changed () {
        float w, h;
        calculate_aspect_ratio_size_fit (doc.width, doc.height, stage.width, stage.height, out w, out h);

        float canvas_width = float.min (stage.width, w * scale);
        float canvas_height = float.min (stage.height, h * scale);
        Idle.add (() => {
            cv.update_size (canvas_width, canvas_height);
            return false;            
        });

        foreach (var child in cv.get_children ()) {
            child.set_scale (w * scale / (float)doc.width, h * scale / (float)doc.height);
        }

        cv.set_position (stage.get_width () / 2 - canvas_width / 2, stage.get_height () / 2 - canvas_height / 2);
    }

    // From https://opensourcehacker.com/2011/12/01/calculate-aspect-ratio-conserving-resize-for-images-in-javascript/
    static void calculate_aspect_ratio_size_fit (float src_width, float src_height, float max_width, float max_height,
		                                        out float width, out float height) {
        float ratio = float.min (max_width / src_width, max_height / src_height);
        width = src_width * ratio;
        height = src_height * ratio;
    }    
}