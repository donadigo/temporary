public class Core.ToolCollection : Object {
    public Gee.ArrayList<ToolItemGroup> groups { get; construct; }

    private static ToolCollection? instance;
    public static unowned ToolCollection get_default () {
        if (instance == null) {
            instance = new ToolCollection ();
        }

        return instance;
    }

    construct {
        groups = new Gee.ArrayList<ToolItemGroup> ();
        groups.add (ToolItemGroup.from_item (new MoveToolItem ()));
        groups.add (ToolItemGroup.from_item (new RectangleSelectToolItem ()));
        groups.add (ToolItemGroup.from_item (new FreeSelectToolItem ()));
        groups.add (ToolItemGroup.from_item (new AutoSelectToolItem ()));
        groups.add (ToolItemGroup.from_item (new DrawPathToolItem ()));
    }
}