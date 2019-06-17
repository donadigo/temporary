

public class Widgets.CDockWidget : Dazzle.DockWidget {
    internal Gtk.Box box;
    DockHandle handle;
    
    construct {
        var title_label = new Gtk.Label (null);
        title_label.margin = 3;
        bind_property ("title", title_label, "label", BindingFlags.SYNC_CREATE);

        var image = new Gtk.Image.from_icon_name ("view-more-horizontal-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        image.margin_end = 3;

        var handle_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        handle_box.get_style_context ().add_class ("handle");
        handle_box.pack_end (image, false, false);

        handle = new DockHandle ();
        handle.detached.connect (detach);

        handle.add (handle_box);

        box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.add (handle);
        add (box);
    }

    public void add_external (Gtk.Widget widget) {
        box.add (widget);
    }

    private void detach (Gdk.EventMotion event) {
        var window = new CDockWindow ();
        box.remove (handle);
        remove (box);

        double rx, ry;
        event.get_root_coords (out rx, out ry);

        Gtk.Allocation alloc;
        get_allocation (out alloc);

        ulong map_id = 0U;
        map_id = window.map.connect (() => {
            window.begin_move_drag (1, (int)rx, (int)ry, event.get_time ());
            window.disconnect (map_id);
        });

        window.set_handle (handle);
        window.set_default_size (alloc.width, -1);
        window.move ((int)rx - handle.relative_start.x, (int)ry - handle.relative_start.y);
        window.add (box);
        window.show_all ();

        ((Gtk.Widget)this).get_parent ().remove (this);
        destroy ();
    }
}