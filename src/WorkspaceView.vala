

public class WorkspaceView : Gtk.Grid {
    public Document doc { get; construct; }
    CanvasView cv;
    Clutter.Stage stage;

    construct {
        cv = new CanvasView (doc);

        var embed = new GtkClutter.Embed ();
        stage = (Clutter.Stage)embed.get_stage ();
        stage.accept_focus = true;
        
        stage.event.connect ((e) => {
            cv.emit_event (e, false);
            return false;
        });

        stage.add_child (cv);

        add (embed);
    }

    public WorkspaceView (Document doc) {
        Object (doc: doc);
    }
}