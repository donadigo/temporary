

public class ImageLayer : Layer {
    public Image image { get; construct; }
    public File? file { get; construct; }

    public Cogl.Texture texture;
    Cogl.Material material;
    Cogl.PixelFormat format;

    public ImageLayer (Document doc, File? file) {
        Object (file: file);
        node = doc.graph.master.create_child ("gegl:layer");
    }

    construct {
        image = new Image ();

        if (file != null) {
            load_file.begin (file, () => {
                update ();
                ready ();
            });
        } else {
            ready ();
        }

        material = new Cogl.Material ();
        material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        material.set_layer_filters (1, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
    }

    public override void paint_content (Document doc, LayerActor actor) {
        material.set_layer (0, texture);

        uchar opacity = (uchar)actor.get_paint_opacity ();
        material.set_color4ub (opacity, opacity, opacity, opacity);

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

    public async void load_file (File file) {
        var graph = new Gegl.Node ();
        var load = graph.create_child ("gegl:load");
        load.set_property ("path", file.get_path ());

        var roi = GeglFixes.get_bounding_box (load);
        int stride = roi.width * 4;

        yield AsyncJob.queue (() => {
            uint8* data = GeglFixes.blit<uint8*> (load, 1, roi, "R'G'B'A u8", stride * 4, Gegl.BlitFlags.DEFAULT);

            image.data = new uint8[stride * roi.height];
            Posix.memcpy (image.data, data, image.data.length);

            format = Cogl.PixelFormat.RGBA_8888;
            bounding_box = { 0, 0, roi.width, roi.height };            
            return null;
        });
    }
}