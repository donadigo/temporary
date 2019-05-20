
public class CApp : Gtk.Application {
    static CApp? instance;
    public static unowned CApp get_instance () {
        if (instance == null) instance = new CApp ();
        return instance;
    }

    construct {
        application_id = "com.github.donadigo.crazy-project";
    }

    public override void activate () {
        unowned List<Gtk.Window> windows = get_windows ();
        if (windows.length () > 0) {
            windows.nth (0).data.present ();
            return;
        }

        var window = new CMainWindow (this);
        window.show_all ();
    }

    public static int main (string[] args) {
        //  Gegl.init (ref args);
        Clutter.init (ref args);

        //  foreach (var op in Gegl.list_operations ()) {
        //      print (op + "\n");
        //  }

        Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
        unowned CApp app = get_instance ();
        return app.run (args);
    }
}