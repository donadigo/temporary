

public class ImageLayer : Layer {
    public Image image { get; construct; }
    public File? file { get; construct; }
    public signal void ready ();

    Cogl.Texture texture;
    Cogl.Material material;
    Cogl.PixelFormat format;

    public ImageLayer (File? file) {
        Object (file: file);
    }

    construct {
        image = new Image ();

        if (file != null) {
            var reader = new PngFileReader ();
            reader.read.begin (file, (obj, res) => {
                var output = reader.read.end (res);
                image.data = output.data;
                bounding_box = { 0, 0, output.width, output.height };
                format = output.format;
                update ();
                ready ();
            });
        } else {
            ready ();
        }

        material = new Cogl.Material ();
        material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
    }
    
    public override void paint (Document doc) {
        Cogl.set_source (material);
        Cogl.rectangle (0, 0, (float)bounding_box.width, (float)bounding_box.height);
    }

    public override void update () {
        rebuild_texture ();
    }

    void rebuild_texture () {
        texture = new Cogl.Texture.from_data (
            bounding_box.width, bounding_box.height,
            Cogl.TextureFlags.NONE, format,
            Cogl.PixelFormat.ANY, 0, image.data
        );

        material.set_layer (0, texture);
    }
}