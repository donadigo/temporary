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

public class LayerRow : Gtk.ListBoxRow {
    public unowned Layer layer { get; construct; }

    Gtk.Image icon;
    Gtk.Label label;
    Gtk.Entry entry;
    Gtk.EventBox handle;

    Gtk.Grid handle_grid;
    Gtk.Grid label_grid;

    Gtk.ToggleButton button_locked;
    Gtk.ToggleButton button_hidden;

    Gtk.Image icon_locked;
    Gtk.Image icon_unlocked;
    Gtk.Image icon_hidden;
    Gtk.Image icon_visible;

    public LayerRow (Layer layer) {
        Object (layer: layer);
    }

    construct {
        can_focus = true;
        get_style_context ().add_class ("layer");

        label =  new Gtk.Label (layer.name);
        label.halign = Gtk.Align.FILL;
        label.xalign = 0;
        label.expand = true;
        label.set_ellipsize (Pango.EllipsizeMode.END);

        entry = new Gtk.Entry ();
        entry.margin_top = 5;
        entry.margin_bottom = 5;
        entry.margin_end = 10;
        entry.expand = true;
        entry.visible = false;
        entry.no_show_all = true;
        entry.set_text (layer.name);

        //  entry.activate.connect (update_on_enter);
        //  entry.focus_out_event.connect (update_on_leave);
        //  entry.key_release_event.connect (update_on_escape);

        icon = new Gtk.Image ();
        icon.margin_start = 12;
        icon.margin_end = 12;
        icon.margin_top = 6;
        icon.margin_bottom = 6;
        icon.vexpand = true;
        icon.valign = Gtk.Align.CENTER;

        var icon_layer_grid = new Gtk.Grid ();
        icon_layer_grid.attach (icon, 0, 0, 1, 1);
        //  icon_layer_grid.attach (icon_folder_open, 1, 0, 1, 1);

        button_locked = new Gtk.ToggleButton ();
        button_locked.tooltip_text = _("Lock Layer");
        button_locked.get_style_context ().remove_class ("button");
        button_locked.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        button_locked.get_style_context ().add_class ("layer-action");
        button_locked.valign = Gtk.Align.CENTER;
        icon_locked = new Gtk.Image.from_icon_name ("changes-allow-symbolic", Gtk.IconSize.MENU);
        icon_unlocked = new Gtk.Image.from_icon_name ("changes-prevent-symbolic", Gtk.IconSize.MENU);
        icon_unlocked.visible = false;
        icon_unlocked.no_show_all = true;

        var button_locked_grid = new Gtk.Grid ();
        button_locked_grid.margin_end = 6;
        button_locked_grid.attach (icon_locked, 0, 0, 1, 1);
        button_locked_grid.attach (icon_unlocked, 1, 0, 1, 1);
        button_locked.add (button_locked_grid);

        button_hidden = new Gtk.ToggleButton ();
        button_hidden.tooltip_text = _("Hide Layer");
        button_hidden.get_style_context ().remove_class ("button");
        button_hidden.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        button_hidden.get_style_context ().add_class ("layer-action");
        button_hidden.valign = Gtk.Align.CENTER;
        icon_hidden = new Gtk.Image.from_icon_name ("layer-visible-symbolic", Gtk.IconSize.MENU);
        icon_visible = new Gtk.Image.from_icon_name ("layer-hidden-symbolic", Gtk.IconSize.MENU);
        icon_visible.visible = false;
        icon_visible.no_show_all = true;

        var button_hidden_grid = new Gtk.Grid ();
        button_hidden_grid.margin_end = 14;
        button_hidden_grid.attach (icon_hidden, 0, 0, 1, 1);
        button_hidden_grid.attach (icon_visible, 1, 0, 1, 1);
        button_hidden.add (button_hidden_grid);       
        
        handle_grid = new Gtk.Grid ();
        handle_grid.expand = true;
        handle_grid.attach (icon_layer_grid, 0, 0, 1, 1);
        handle_grid.attach (label, 1, 0, 1, 1);
        handle_grid.attach (entry, 2, 0, 1, 1);

        handle = new Gtk.EventBox ();
        handle.expand = true;
        handle.above_child = false;
        handle.add (handle_grid);

        label_grid = new Gtk.Grid ();
        label_grid.expand = true;
        label_grid.attach (handle, 1, 0, 1, 1);
        label_grid.attach (button_locked, 2, 0, 1, 1);
        label_grid.attach (button_hidden, 3, 0, 1, 1);

        add (label_grid);
        show_all ();

        update_icon.begin ();
    }

    async void update_icon () {
        var pixbuf = yield layer.create_pixbuf (30, 30);
        icon.pixbuf = pixbuf;
    }
}