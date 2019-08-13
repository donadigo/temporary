

public class Core.ImageLayer : Layer {
    public Image image { get; construct; }
    public File? file { get; construct; }

    public Cogl.Texture texture;
    Cogl.Material material;
    Cogl.PixelFormat format;

    Gegl.Node load;
    Gegl.Node? nbsource;
    Gegl.Node? ntranslate;
    Gegl.Node? nover;
    Gegl.Node? nopacity;


    public ImageLayer (Document doc, File? file) {
        Object (doc: doc, file: file);
    }

    construct {
        populate_name ();
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

    public override void update_internal () {
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

    void populate_name () {
        name = file.get_basename ();
    }

    public async void load_file (File file) {
        var graph = new Gegl.Node ();
        load = graph.create_child ("gegl:load");
        load.set_property ("path", file.get_path ());

        var roi = GeglFixes.get_bounding_box (load);
        int stride = roi.width * 4;

        yield AsyncJob.queue (JobType.LOAD_FILE, null, QueueFlags.NONE, (job) => {
            image.allocate (roi.width, roi.height, 4);
            load.blit (1, roi, Formats.RGBA_u8, image.data, stride, Gegl.BlitFlags.DEFAULT);

            format = Cogl.PixelFormat.RGBA_8888;
            bounding_box = new Gegl.Rectangle (0, 0, roi.width, roi.height);
            return null;
        });
    }

    public override Gegl.Node connect_to_graph (Gegl.Node graph, Gegl.Node source) {
        var roi = new Gegl.Rectangle (0, 0, bounding_box.width, bounding_box.height);
        var buffer = new Gegl.Buffer (roi, Formats.RGBA_u8);
        buffer.set (roi, 0, Formats.RGBA_u8, image.data, roi.width * 4);

        nbsource = graph.create_child ("gegl:buffer-source");
        nbsource.set_property ("buffer", buffer);

        ntranslate = graph.create_child ("gegl:translate");
        ntranslate.set_property ("x", bounding_box.x);
        ntranslate.set_property ("y", bounding_box.y);

        nbsource.connect_to ("output", ntranslate, "input");

        string op = BlendingMode.to_gegl_op (blending_mode);
        nover = graph.create_child (op);
        if (op == "gegl:color-burn") {
            nover.set_property ("srgb", true);
        }

        //  nopacity = graph.create_child ("gegl:opacity");
        ntranslate.connect_to ("output", nover, "aux");

        source.connect_to ("output", nover, "input");
        ntranslate.connect_to ("output", nover, "aux");

        return nover;
    }

    public override void update_bounding_box (Gegl.Rectangle new_bb) {
        base.update_bounding_box (new_bb);
        update_translate_node ();
    }

    public override void move_bounding_box (int xoff, int yoff) {
        base.move_bounding_box (xoff, yoff);
        update_translate_node ();
    }

    void update_translate_node () {
        if (ntranslate != null) {
            ntranslate.set_property ("x", bounding_box.x);
            ntranslate.set_property ("y", bounding_box.y);
        }
    }

    public bool bounding_box_matches_image () {
        return image.width == bounding_box.width && image.height == bounding_box.height;
    }

    public override async Gdk.Pixbuf? create_pixbuf (int width) {
        if (!bounding_box_matches_image ()) {
            return null;
        }

        float ratio = doc.width / (float)doc.height;
        int height = (int)(width / ratio);

        var pixbuf = new Gdk.Pixbuf (Gdk.Colorspace.RGB, true, 8, width, height);
        pixbuf.fill (0x00000000);

        if (texture == null) {
            return pixbuf;
        }

        float thumb_ratio = doc.width / width;
        int scaled_width = int.max (1, (int)(bounding_box.width / thumb_ratio));
        int scaled_height = int.max (1, (int)(bounding_box.height / thumb_ratio));

        yield AsyncJob.queue (JobType.COMPOSITE_PIXBUF, null, QueueFlags.NONE, (job) => {
            var content = new Gdk.Pixbuf.from_data (image.data, Gdk.Colorspace.RGB, true, 8, bounding_box.width, bounding_box.height, bounding_box.width * 4);
            content = content.scale_simple (scaled_width, scaled_height, Gdk.InterpType.BILINEAR);

            int x = (int)(bounding_box.x / thumb_ratio);
            int y = (int)(bounding_box.y / thumb_ratio);
            
            int x_off = x >= 0 ? 0 : x.abs ();
            int y_off = y >= 0 ? 0 : y.abs ();

            int dest_x = int.max (x, 0);
            int dest_y = int.max (y, 0);

            int w = int.min (scaled_width - x_off, pixbuf.get_width () - dest_x);
            int h = int.min (scaled_height - y_off, pixbuf.get_height () - dest_y);

            //  content.composite (pixbuf, dest_x, dest_y, w, h, dest_x, dest_y, 1, 1, Gdk.InterpType.BILINEAR, (int)(opacity * 255));
            content.copy_area (x_off, y_off, w, h, pixbuf, dest_x, dest_y);
            return null;
        });

        return pixbuf;
    }

    // From https://opensourcehacker.com/2011/12/01/calculate-aspect-ratio-conserving-resize-for-images-in-javascript/
	static void calculate_aspect_ratio_size_fit (float src_width, float src_height, float max_width, float max_height,
		out float width, out float height) {
		float ratio = float.min (max_width / src_width, max_height / src_height);
		width = src_width * ratio;
		height = src_height * ratio;
    }    
}