public class CMainWindow : GlobalWindow {
    CHeaderBar header_bar;

    public CMainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/donadigo/temporary");

        header_bar = new CHeaderBar ();
        set_titlebar (header_bar);
        set_default_size (800, 800);

        var main_view = new MainView ();

        add (main_view);
        show_all ();
    }
}