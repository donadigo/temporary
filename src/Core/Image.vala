public class Core.Image : Object {
    public uint8[] data;

    public Image () {

    }

    public void allocate (int width, int height, int stride) {
        data = new uint8[width * stride * height];
    }
}