/*
* Copyright (c) 2019 Alecaddd (http://alecaddd.com)
*
* This file is part of Akira.
*
* Akira is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* Akira is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with Akira.  If not, see <https://www.gnu.org/licenses/>.
*
* Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
*/

public class LayerListBox : Gtk.ListBox {
    public unowned Document doc { get; construct; }

    //  unowned LayerRow? prev_selected;
    //  bool selection_locked = false;

    public LayerListBox (Document doc) {
        Object (doc: doc);
    }

    construct {
        selection_mode = Gtk.SelectionMode.SINGLE;
        doc.layer_stack.added.connect (on_layer_stack_added);

        get_style_context ().add_class ("layers-panel");

        //  row_selected.connect (on_row_selected);
        selected_rows_changed.connect (on_selected_rows_changed);
    }

    void on_layer_stack_added (Layer layer) {
        var row = new LayerRow (layer);
        row.button_press_event.connect (on_row_button_press_event);
        insert (row, 0);
        Idle.add (() => {
            update_zebra ();
            return false;
        });
    }

    void on_selected_rows_changed () {
    }

    bool on_row_button_press_event (Gtk.Widget row_widget, Gdk.EventButton event) {
        if (event.button == Gdk.BUTTON_PRIMARY) {
            if (GlobalKeyState.any_pressed ({ Gdk.Key.Shift_L, Gdk.Key.Shift_R })) {
                var rows = get_selected_rows ();
                int start = (int)get_children ().length (), end = 0;
                foreach (unowned Gtk.Widget widget in rows) {
                    unowned Gtk.ListBoxRow _row = (Gtk.ListBoxRow)widget;
                    start = int.min (start, _row.get_index ());
                    end = int.max (end, _row.get_index ());
                }

                unowned Gtk.ListBoxRow row = (Gtk.ListBoxRow)row_widget;
                int index = row.get_index ();

                selection_mode = Gtk.SelectionMode.MULTIPLE;
                if (index < start) {
                    select_rows_post (index, start);
                } else if (index > end) {
                    select_rows_post (end, index);
                } else {
                    unselect_all ();
                    select_row_post (row_widget);
                }

                return true;
            } else if (GlobalKeyState.any_pressed ({ Gdk.Key.Control_L, Gdk.Key.Control_R })) {
                selection_mode = Gtk.SelectionMode.MULTIPLE;
                select_row_post (row_widget);
                return true;
            } else {
                selection_mode = Gtk.SelectionMode.SINGLE;
                select_row_post (row_widget);
                return true;
            }
        }

        return false;
    }

    void select_row_post (Gtk.Widget row) {
        var layer_row = (LayerRow)row;
        row.activate ();
        
        var items = new Gee.LinkedList<unowned LayerStackItem> ();
        items.add (layer_row.layer);

        var data = SelectLayersEventData () { items = items };
        EventBus.post<SelectLayersEventData?> (EventType.SELECT_LAYERS, data);
    }

    void select_rows_post (int start, int end) {
        var items = new Gee.LinkedList<unowned LayerStackItem> ();
        for (int i = start; i <= end; i++) {
            var row = get_row_at_index (i);
            var layer_row = (LayerRow)row;
            items.add (layer_row.layer);
            select_row (row);
        }

        var data = SelectLayersEventData () { items = items };
        EventBus.post<SelectLayersEventData?> (EventType.SELECT_LAYERS, data);
    }

    //  void on_row_selected (Gtk.ListBoxRow? row) {
    //      return;
    //      if (selection_locked) {
    //          return;
    //      }

    //      var layer_row = row as LayerRow;
    //      if (layer_row == null) {
    //          return;
    //      }

    //      print ("SELECTED\n");
    //      if (prev_selected != null && (GlobalKeyState.is_pressed (Gdk.Key.Shift_L) || GlobalKeyState.is_pressed (Gdk.Key.Shift_R))) {
    //          selection_mode = Gtk.SelectionMode.MULTIPLE;
    //          int start_index = prev_selected.get_index ();
    //          int end_index = layer_row.get_index ();

    //          start_index = int.min (start_index, end_index);
    //          end_index = int.max (start_index, end_index);
    //          print ("%i %i\n", start_index, end_index);

    //          selection_locked = true;
    //          for (int i = start_index; i < end_index; i++) {
    //              select_row (get_row_at_index (i));
    //          }

    //          selection_locked = false;
    //      } else {
    //          //  unselect_all ();
    //          selection_mode = Gtk.SelectionMode.SINGLE;
    //          select_row (row);
    //      }

    //      prev_selected = layer_row;
    //  }

    //  void on_row_activate (LayerRow row) {
    //  }

    void update_zebra () {
        bool even = true;
        foreach (unowned Gtk.Widget child in get_children ()) {
            unowned Gtk.StyleContext context = child.get_style_context ();
            bool has_even = context.has_class ("even");
            if (has_even && !even)  {
                context.remove_class ("even");
            } else if (!has_even && even) {
                context.add_class ("even");
            }

            even = !even;
        }
    }
}