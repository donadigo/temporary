

using Core;

public class Widgets.TransformSettingsWidget : Gtk.Grid {
    construct {
        hexpand = true;
        valign = halign = Gtk.Align.CENTER;

        var decline_button = new Gtk.Button.from_icon_name ("process-stop", Gtk.IconSize.LARGE_TOOLBAR);
        decline_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);


        var apply_button = new Gtk.Button.from_icon_name ("media-playback-start", Gtk.IconSize.LARGE_TOOLBAR);
        apply_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        attach (decline_button, 0, 0, 1, 1);
        attach (apply_button, 1, 0, 1, 1);
    }
}