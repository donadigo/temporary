

public class PngFileReader : FileReader {
    public override string[] get_supported_mimes () {
        return {
            "image/png",
            "image/jpeg"
        };
    }

    public override async ReadOutput? read (File file) {
        //  var job = new AsyncJob<Gee.ArrayList<uint8?>> (() => {
        var array = new Gee.ArrayList<uint8?> ();

        var stream = yield file.open_readwrite_async ();
        var pixbuf = yield new Gdk.Pixbuf.from_stream_async (stream.input_stream);

        //  return {
        //      0, 0, {}
        //  };

        return {
            pixbuf.get_width (),
            pixbuf.get_height (),
            pixbuf.get_pixels_with_length (),
            pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888
            //  {}
        };
        //  });
    }
}