public class Image : Object {
    public uint8[] data { get; set; }

    public Image () {

    }

    public void allocate (int width, int height, int stride) {
        data = new uint8[width * stride * height];
    }
}