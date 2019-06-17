
public class Core.GlobalKeyState {
    private static Gee.LinkedList<uint> pressed;
    public static void init () {
        pressed = new Gee.LinkedList<uint> ();
    }

    public static bool is_pressed (uint key) {
        return key in pressed;
    }

    public static bool any_pressed (int[] keys) {
        foreach (var key in keys) {
            if (is_pressed (key)) {
                return true;
            }
        }

        return false;
    }

    public static void mark_pressed (uint key) {
        pressed.add (key);
    }

    public static void mark_released (uint key) {
        pressed.remove (key);
    }
}