

using Core;

public class Widgets.LayerDockWidget : CDockWidget {
    unowned Document? current_doc = null;

    Gtk.ComboBoxText blend_combo;
    Gtk.Scale op_scale;

    ulong blend_combo_changed_id;
    ulong op_scale_changed_id;

    Gtk.Stack list_box_stack;

    construct {
        list_box_stack = new Gtk.Stack ();

        blend_combo = new Gtk.ComboBoxText ();
        blend_combo_changed_id = blend_combo.changed.connect (on_blend_combo_changed);
        blend_combo.hexpand = true;

        for (int i = 0; i < BlendingMode.LAST; i++) {
            blend_combo.append (i.to_string (), BlendingMode.get_name ((BlendingMode)i));
        }

        op_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 1.0, 0.01);
        op_scale_changed_id = op_scale.value_changed.connect (on_op_scale_value_changed);
        op_scale.button_press_event.connect (on_op_scale_button_press_event);
        op_scale.button_release_event.connect (on_op_scale_button_release_event);
        op_scale.set_value (1.0);
        op_scale.draw_value = false;
        op_scale.hexpand = true;

        var blend_label = new MouseAdjustableLabel (_("Mode:"), 20);
        blend_label.step.connect (on_blend_label_step);
        blend_label.halign = Gtk.Align.START;

        var op_label = new MouseAdjustableLabel (_("Opacity:"), 3);
        op_label.step.connect (on_op_label_step);
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
        
        var scrolled = new Gtk.ScrolledWindow (null, null);
        scrolled.add (list_box_stack);
        box.add (scrolled);

        EventBus.get_default ().current_document_changed.connect (on_document_changed);
    }

    void on_document_changed (Document? doc) {
        if (current_doc != null) {
            current_doc.layer_stack.selection_changed.disconnect (on_layer_stack_selection_changed);
        }

        current_doc = doc;
        if (current_doc != null) {
            current_doc.layer_stack.selection_changed.connect (on_layer_stack_selection_changed);

            // TODO: find an existing list box 
            var list_box = new LayerListBox (current_doc);
            list_box_stack.add_named (list_box, current_doc.id.to_string ());
        }
    }

    void on_layer_stack_selection_changed () {
        if (current_doc == null) return;

        float opacity;
        BlendingMode mode;
        current_doc.layer_stack.get_best_display_settings (out opacity, out mode);

        SignalHandler.block (op_scale, op_scale_changed_id);
        SignalHandler.block (blend_combo, blend_combo_changed_id);

        op_scale.set_value (opacity);
        blend_combo.set_active_id (((int)mode).to_string ());

        SignalHandler.unblock (op_scale, op_scale_changed_id);
        SignalHandler.unblock (blend_combo, blend_combo_changed_id);
    }

    void on_op_scale_value_changed () {
        if (current_doc == null) return;

        foreach (unowned LayerStackItem item in current_doc.layer_stack.selected) {
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

    void on_blend_combo_changed () {
        string? active_id = blend_combo.get_active_id ();
        if (active_id == null) {
            return;
        }

        mark_selected (true);
        
        var mode = (BlendingMode)int.parse (active_id);
        foreach (unowned LayerStackItem item in current_doc.layer_stack.selected) {
            item.blending_mode = mode;
        }        

        mark_selected (false);
        EventBus.get_default ().force_redraw_canvas (current_doc);
    }

    void mark_selected (bool dirty) {
        if (current_doc == null) return;

        foreach (unowned LayerStackItem item in current_doc.layer_stack.selected) {
            if (item is Layer) {
                ((Layer)item).dirty = dirty;
            }
        }   

        current_doc.layer_stack.update_dirty ();
        EventBus.get_default ().force_redraw_canvas (current_doc);
    }

    void on_op_label_step (int step) {
        op_scale.set_value (op_scale.get_value () + step / 100.0);
    }

    void on_blend_label_step (int step) {
        int active = blend_combo.get_active ();
        int new_active = active + step;

        int n = BlendingMode.LAST;

        // From https://codereview.stackexchange.com/a/57945 and
        // https://web.archive.org/web/20170210025920/http://javascript.about.com/od/problemsolving/a/modulobug.htm
        blend_combo.active = (new_active % n + n) % n;
    }
}