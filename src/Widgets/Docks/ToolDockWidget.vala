

using Core;

public class Widgets.ToolDockWidget : CDockWidget {
    Gtk.FlowBox grid;
    Gee.ArrayList<unowned CToolButton> tool_buttons;

    construct {
        can_close = true;
        tool_buttons = new Gee.ArrayList<unowned CToolButton> ();

        grid = new Gtk.FlowBox ();
        grid.halign = Gtk.Align.CENTER;
        grid.valign = Gtk.Align.START;
        grid.margin = 3;

        foreach (var group in ToolCollection.get_default ().groups) {
            var button = new CToolButton (group);
            button.notify["active"].connect (() => on_tool_button_active (button));
            tool_buttons.add (button);
            grid.add (button);
        }

        update_current_tool ();

        box.add (grid);
        show_all ();
    }

    void on_tool_button_active (CToolButton button) {
        if (button.active) {
            foreach (unowned CToolButton other in tool_buttons) {
                if (other != button) {
                    other.active = false;
                    other.group.get_first ().deactivate ();
                }
            }
        }

        ToolCollection.get_default ().active = button.group.get_first ();
    }

    void update_current_tool () {
        unowned ToolItem? current = ToolCollection.get_default ().active;
        if (current != null) {
            foreach (unowned CToolButton button in tool_buttons) {
                if (button.group.get_first () == current) {
                    button.active = true;
                    button.group.get_first ().activate ();
                    break;
                }
            }
        }
    }
}