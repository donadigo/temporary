

public class Widgets.ToolSettingsBar : Gtk.Grid {

    construct {
        height_request = 40;
        get_style_context ().add_class ("tool-settings-bar");
    }
}