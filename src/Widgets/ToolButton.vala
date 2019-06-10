public class CToolButton : Gtk.ToggleToolButton {

    public CToolButton (ToolItemGroup group) {
        var item = group[0];
        icon_widget = new Gtk.Image.from_icon_name (item.icon_name, Gtk.IconSize.LARGE_TOOLBAR);
    }
}