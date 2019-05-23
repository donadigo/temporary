


public class RenderPipeline : Object {
    public unowned CanvasView canvas { get; construct; }

    private Cogl.Offscreen a_fbo;
    public Cogl.Texture a;

    private Cogl.Offscreen b_fbo;
    public Cogl.Texture b;

    private static Cogl.Color transparent;


    bool render_to_b = true;

    static construct {
        transparent = Cogl.Color.from_4ub (0, 0, 0, 0);
    }

    public RenderPipeline (CanvasView canvas) {
        Object (canvas: canvas);
    }

    construct {
        a = new Cogl.Texture.with_size ((uint)canvas.width, (uint)canvas.height, Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY);
        a_fbo = new Cogl.Offscreen.to_texture (a);

        b = new Cogl.Texture.with_size ((uint)canvas.width, (uint)canvas.height, Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY);
        b_fbo = new Cogl.Offscreen.to_texture (b);
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

    public unowned Cogl.Texture get_result () {
        return render_to_b ? b : a;
        //  return current_fbo == a_fbo ? a : b;
    }

    private static void clear_fbo (Cogl.Offscreen fbo) {
        Cogl.push_framebuffer ((Cogl.Framebuffer)fbo);
        Cogl.clear (transparent, Cogl.BufferBit.COLOR);
        Cogl.pop_framebuffer ();
    }
}