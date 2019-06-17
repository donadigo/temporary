

using Core;

public class Widgets.ToolDockWidget : CDockWidget {

    construct {
        can_close = true;
        //  title = _("Tools");

        var grid = new Gtk.FlowBox ();
        grid.valign = Gtk.Align.START;

        foreach (var group in ToolCollection.get_default ().groups) {
            var button = new CToolButton (group);
            grid.add (button);
        }

        box.add (grid);
        show_all ();
    }
    
}