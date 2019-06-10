

public class ToolDockWidget : Dazzle.DockWidget {

    construct {
        var grid = new Gtk.FlowBox ();
        grid.valign = Gtk.Align.START;
        grid.margin_top = 12;

        foreach (var group in ToolCollection.get_default ().groups) {
            var button = new CToolButton (group);
            grid.add (button);
        }

        add (grid);
    }
    
}