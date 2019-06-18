

public class Core.ToolItemGroup : Gee.ArrayList<ToolItem> {
 
    public static ToolItemGroup from_item (ToolItem item) {
        var group = new ToolItemGroup ();
        group.add (item);
        return group;
    }

    public ToolItem get_first () {
        return this[0];
    }
}