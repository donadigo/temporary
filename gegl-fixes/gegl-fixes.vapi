[CCode (cheader_filename = "gegl-fixes/gegl-fixes.h")]
namespace GeglFixes { 
    public Gegl.Rectangle get_bounding_box (Gegl.Node node);
    [CCode (simple_generics = true)]
    public G blit<G> (Gegl.Node node, double scale, Gegl.Rectangle roi, string? format, int rowstride, Gegl.BlitFlags flags);
}