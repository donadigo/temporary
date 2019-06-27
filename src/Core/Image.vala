public class Core.Image : Object {
    public uint8[] data;
    public int width { get; set; }
    public int height { get; set; }

    public Image () {

    }

    public void allocate (int width, int height, int stride) {
        data = new uint8[width * stride * height];
        this.width = width;
        this.height = height;
    }
}