public class CMainWindow : Gtk.ApplicationWindow {

    CHeaderBar header_bar;


    public CMainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        header_bar = new CHeaderBar ();
        set_titlebar (header_bar);
        set_default_size (800, 800);

        var main_view = new MainView ();

        add (main_view);
        show_all ();
    }
}