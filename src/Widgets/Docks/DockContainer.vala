


public class Widgets.DockContainer : Gtk.EventBox {
    private static Gee.LinkedList<DockContainer> containers;
    public static unowned Gee.LinkedList<DockContainer> get_all () {
        init ();
        return containers;
    }

    static construct {
        init ();
    }

    Gtk.Box box;

    construct {
        box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        add (box);
        containers.add (this);
    }

    public void add_widget (Gtk.Widget widget) {
        box.add (widget);
        box.show_all ();
    }

    public Gdk.Rectangle get_absolute_frame () {
        unowned Gdk.Window? window = get_window ();

        Gdk.Rectangle rect = {};
        window.get_origin (out rect.x, out rect.y);

        Gtk.Allocation alloc;
        get_allocation (out alloc);

        rect.width = alloc.width;
        rect.height = alloc.height;

        return rect;
    }

    static void init () {
        if (containers == null) {
            containers = new Gee.LinkedList<DockContainer> ();
        }
    }
}