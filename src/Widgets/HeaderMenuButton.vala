

public class Widgets.HeaderMenuButton : Gtk.MenuButton {
    Gtk.Menu menu;

    public HeaderMenuButton (string icon_name, Gtk.IconSize icon_sz) {
        set_image (new Gtk.Image.from_icon_name (icon_name, icon_sz));
    }

    construct {
        menu = new Gtk.Menu ();
        set_popup (menu);
    }
}