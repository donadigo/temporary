


public class Core.Formats {
    public static void* RGBA_u8;

    public static void init () {
        RGBA_u8 = Babl.format ("R'G'B'A u8");
    }
}