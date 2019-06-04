

public class ImageLayer : Layer {
    public Image image { get; construct; }
    public File? file { get; construct; }

    public Cogl.Texture texture;
    Cogl.Material material;
    Cogl.PixelFormat format;

    Gegl.Node load;

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
        //  material.set_layer_filters (0, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
        //  material.set_layer_filters (1, Cogl.MaterialFilter.NEAREST, Cogl.MaterialFilter.NEAREST);
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
        load = graph.create_child ("gegl:load");
        load.set_property ("path", file.get_path ());

        var roi = GeglFixes.get_bounding_box (load);
        int stride = roi.width * 4;

        yield AsyncJob.queue (JobType.LOAD_FILE, QueueFlags.NONE, (job) => {
            image.allocate (roi.width, roi.height, 4);
            load.blit (1, roi, Formats.RGBA_u8, image.data, stride, Gegl.BlitFlags.DEFAULT);

            format = Cogl.PixelFormat.RGBA_8888;
            bounding_box = new Gegl.Rectangle (0, 0, roi.width, roi.height);
            return null;
        });
    }

    public override Gegl.Node process (Gegl.Node graph, Gegl.Node source) {
        var roi = new Gegl.Rectangle (0, 0, bounding_box.width, bounding_box.height);
        var buffer = new Gegl.Buffer (roi, Formats.RGBA_u8);
        buffer.set (roi, 0, Formats.RGBA_u8, image.data, roi.width * 4);

        var bsource = graph.create_child ("gegl:buffer-source");
        bsource.set_property ("buffer", buffer);

        var translate = graph.create_child ("gegl:translate");
        translate.set_property ("x", bounding_box.x);
        translate.set_property ("y", bounding_box.y);

        bsource.connect_to ("output", translate, "input");

        string op = BlendingMode.to_gegl_op (blending_mode);
        var over = node.get_parent ().create_child (op);
        source.connect_to ("output", over, "input");
        translate.connect_to ("output", over, "aux");

        return over;
    }
}