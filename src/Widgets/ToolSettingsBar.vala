

public class Widgets.ToolSettingsBar : Gtk.Box {
    unowned Gtk.Widget? current_widget;

    construct {
        height_request = 40;
        get_style_context ().add_class ("tool-settings-bar");
    }

    public void set_widget (Gtk.Widget? widget) {
        if (current_widget != null) {
            remove (current_widget);
            current_widget = null;
        }

        if (widget != null) {
            add (widget);
            show_all ();

            current_widget = widget;
        }
    }
}