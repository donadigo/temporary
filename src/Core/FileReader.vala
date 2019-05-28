public struct ReadOutput {
    int width;
    int height;
    uint8[] data;
    Cogl.PixelFormat format;
}

public abstract class FileReader : Object {
    public abstract string[] get_supported_mimes ();
    public abstract async ReadOutput? read (File file);
}