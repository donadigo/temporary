using Core;

public class Widgets.CToolButton : Gtk.ToggleToolButton {
    public ToolItemGroup group { get; construct; }

    construct {
        unowned Gtk.StyleContext ctx = get_style_context ();
        ctx.add_class ("ctool-button");
    }

    public CToolButton (ToolItemGroup group) {
        Object (group: group);
        var item = group.get_first ();
        icon_widget = new Gtk.Image.from_icon_name (item.icon_name, Gtk.IconSize.LARGE_TOOLBAR);
    }
}