


public class RenderPipeline : Object {
    public unowned CanvasView canvas { get; construct; }

    Cogl.Offscreen a_fbo;
    Cogl.Texture a;

    Cogl.Offscreen b_fbo;
    Cogl.Texture b;

    Cogl.Offscreen layer_fbo;
    Cogl.Texture layer;

    bool render_to_b = true;

    static Cogl.Color transparent;

    static construct {
        transparent = Cogl.Color.from_4ub (0, 0, 0, 0);
    }

    public RenderPipeline (CanvasView canvas) {
        Object (canvas: canvas);
    }

    construct {
        create_fbo ((int)canvas.width, (int)canvas.height, out a, out a_fbo);
        create_fbo ((int)canvas.width, (int)canvas.height, out b, out b_fbo);
        create_fbo ((int)canvas.width, (int)canvas.height, out layer, out layer_fbo);
    }

    static void create_fbo (int width, int height, out Cogl.Texture texture, out Cogl.Offscreen fbo) {
        texture = new Cogl.Texture.with_size ((uint)width, (uint)height, Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY);
        fbo = new Cogl.Offscreen.to_texture (texture);
    }

    public void get_size (out uint width, out uint height) {
        width = a.get_width ();
        height = a.get_height ();
    }

    public void begin_paint () {
        clear_fbo (a_fbo);
        clear_fbo (b_fbo);
        render_to_b = !render_to_b;
    }

    public void bind_layer () {
        Cogl.flush ();
        clear_fbo (layer_fbo);
        Cogl.push_framebuffer ((Cogl.Framebuffer)layer_fbo);
    }

    public void end_layer () {
        Cogl.pop_framebuffer ();
    }

    public void bind_current () {
        unowned Cogl.Framebuffer fbo = render_to_b ? (Cogl.Framebuffer)b_fbo : (Cogl.Framebuffer)a_fbo;
        Cogl.flush ();
        Cogl.push_framebuffer (fbo);
    }

    public void end_current () {
        Cogl.pop_framebuffer ();
        render_to_b = !render_to_b;
    }

    public void draw_current () {
        var current = get_current_texture ();
        Cogl.set_source_texture (current);
        Cogl.rectangle (0, 0, current.get_width (), current.get_height ());
    }

    public unowned Cogl.Texture get_current_texture () {
        return render_to_b ? a : b;
    }

    public unowned Cogl.Texture get_layer_texture () {
        return layer;   
    }

    private static void clear_fbo (Cogl.Offscreen fbo) {
        Cogl.push_framebuffer ((Cogl.Framebuffer)fbo);
        Cogl.clear (transparent, Cogl.BufferBit.COLOR);
        Cogl.pop_framebuffer ();
    }
}