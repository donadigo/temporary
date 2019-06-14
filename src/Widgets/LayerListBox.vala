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

    public LayerListBox (Document doc) {
        Object (doc: doc);
    }

    construct {
        doc.layer_stack.added.connect (on_layer_stack_added);
    }

    void on_layer_stack_added (Layer layer) {
        var row = new LayerRow (layer);
        insert (row, 0);
        update_zebra ();
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
}