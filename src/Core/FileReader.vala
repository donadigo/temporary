public struct Core.ReadOutput {
    int width;
    int height;
    uint8[] data;
    Cogl.PixelFormat format;
}

public abstract class Core.FileReader : Object {
    public abstract string[] get_supported_mimes ();
    public abstract async ReadOutput? read (File file);
}