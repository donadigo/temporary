

using Core;

public class Widgets.LayerDockWidget : CDockWidget {
    public unowned Core.Document doc { get; construct; }

    Gtk.ComboBox blend_combo;
    Gtk.Scale op_scale;

    public LayerDockWidget (Core.Document doc) {
        Object (doc: doc);
    }

    construct {
        blend_combo = new Gtk.ComboBox ();
        blend_combo.hexpand = true;

        op_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 1.0, 0.01);
        op_scale.value_changed.connect (on_op_scale_value_changed);
        op_scale.button_press_event.connect (on_op_scale_button_press_event);
        op_scale.button_release_event.connect (on_op_scale_button_release_event);
        op_scale.set_value (1.0);
        op_scale.draw_value = false;
        op_scale.hexpand = true;

        var blend_label = new Gtk.Label (_("Mode:"));
        blend_label.halign = Gtk.Align.START;

        var op_label = new Gtk.Label (_("Opacity:"));
        op_label.halign = Gtk.Align.START;

        var prop_grid = new Gtk.Grid ();
        prop_grid.margin_start = prop_grid.margin_end = 6;
        prop_grid.margin_top = prop_grid.margin_bottom = 12;
        prop_grid.column_spacing = 8;
        prop_grid.row_spacing = 6;
        prop_grid.attach (blend_label, 0, 0, 1, 1);
        prop_grid.attach (blend_combo, 1, 0, 1, 1);
        prop_grid.attach (op_label, 0, 1, 1, 1);
        prop_grid.attach (op_scale, 1, 1, 1, 1);

        box.add (prop_grid);
        box.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

        var search_entry = new Gtk.SearchEntry ();
        search_entry.placeholder_text = _("Search Layers…");
        search_entry.margin = 6;
        box.add (search_entry);
        box.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        
        var list_box = new LayerListBox (doc);
        list_box.expand = true;

        var scrolled = new Gtk.ScrolledWindow (null, null);
        scrolled.add (list_box);
        box.add (scrolled);

        doc.layer_stack.selection_changed.connect (on_layer_stack_selection_changed);
    }

    void on_layer_stack_selection_changed () {
        var selection = doc.layer_stack.selected;
        if (selection.size == 1) {
            unowned LayerStackItem item = selection[0];
            op_scale.set_value ((double)item.opacity);
        } else if (selection.size > 1) {
            op_scale.set_value (1.0);
        }
    }

    void on_op_scale_value_changed () {
        foreach (unowned LayerStackItem item in doc.layer_stack.selected) {
            item.opacity = (float)op_scale.get_value ();
        }
    }

    bool on_op_scale_button_press_event (Gdk.EventButton event) {
        if (event.button == Gdk.BUTTON_PRIMARY) {
            mark_selected (true);         
        }

        return false;
    }

    bool on_op_scale_button_release_event (Gdk.EventButton event) {
        if (event.button == Gdk.BUTTON_PRIMARY) {
            mark_selected (false);
        }

        return false;
    }

    void mark_selected (bool dirty) {
        foreach (unowned LayerStackItem item in doc.layer_stack.selected) {
            if (item is Layer) {
                ((Layer)item).dirty = dirty;
            }
        }   
    }
}