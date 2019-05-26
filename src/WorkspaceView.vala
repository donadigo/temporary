

public class WorkspaceView : Gtk.Grid {
    public Document doc { get; construct; }
    CanvasView cv;
    Clutter.Stage stage;

    construct {
        cv = new CanvasView (doc);

        var embed = new GtkClutter.Embed ();
        stage = (Clutter.Stage)embed.get_stage ();
        stage.notify["allocation"].connect (() => {
            cv.update_size (stage.get_width (), stage.get_height ());
        });

        stage.add_child (cv);
        cv.update_size (stage.get_width (), stage.get_height ());

        add (embed);
    }

    public WorkspaceView (Document doc) {
        Object (doc: doc);
    }
}