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

using Core;

public class Widgets.LayerListBox : Gtk.ListBox {
    public unowned Document doc { get; construct; }

    public LayerListBox (Document doc) {
        Object (doc: doc);
    }

    construct {
        selection_mode = Gtk.SelectionMode.SINGLE;
        doc.layer_stack.added.connect (on_layer_stack_added);
        key_press_event.connect (on_key_press_event);

        get_style_context ().add_class ("layers-panel");
    }

    void on_layer_stack_added (Layer layer) {
        var row = new LayerRow (layer);
        row.button_press_event.connect (on_row_button_press_event);
        insert (row, 0);

        if (get_children ().length () == 1) {
            select_row_post (row);
        }

        Idle.add (() => {
            update_zebra ();
            return false;
        });
    }

    bool on_key_press_event (Gdk.EventKey event) {
        switch (event.keyval) {
            case Gdk.Key.uparrow:
            case Gdk.Key.downarrow:
                return true;
            default:
                break;
        }

        return false;
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

                focus_canvas ();
                return true;
            } else if (GlobalKeyState.any_pressed ({ Gdk.Key.Control_L, Gdk.Key.Control_R })) {
                selection_mode = Gtk.SelectionMode.MULTIPLE;
                select_row_post (row_widget, true);
                focus_canvas ();
                return true;
            } else {
                selection_mode = Gtk.SelectionMode.SINGLE;
                select_row_post (row_widget);
                focus_canvas ();
                return true;
            }
        }

        return false;
    }

    void select_row_post (Gtk.Widget row, bool add_existing = false) {
        var layer_row = (LayerRow)row;
        row.activate ();
        
        var items = new Gee.LinkedList<unowned LayerStackItem> ();
        items.add (layer_row.layer);

        if (add_existing) {
            doc.layer_stack.add_to_selection (items);
        } else {
            doc.layer_stack.set_selection (items);
        }
    }

    void select_rows_post (int start, int end) {
        var items = new Gee.LinkedList<unowned LayerStackItem> ();
        for (int i = start; i <= end; i++) {
            var row = get_row_at_index (i);
            var layer_row = (LayerRow)row;
            items.add (layer_row.layer);
            select_row (row);
        }

        doc.layer_stack.add_to_selection (items);
    }

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

    void focus_canvas () {
        var data = FocusCanvasEventData () {
            doc = doc
        };

        EventBus.post<FocusCanvasEventData?> (EventType.FOCUS_CANVAS, data);        
    }
}