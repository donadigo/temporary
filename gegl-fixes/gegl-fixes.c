#include <glib.h>
#include <gegl.h>
#include "gegl-fixes.h"

GeglRectangle* gegl_fixes_get_bounding_box (GeglNode* node)
{
    g_return_if_fail (node);

    GeglRectangle box;
    box = gegl_node_get_bounding_box (node);
    return gegl_rectangle_dup (&box);
}

gpointer gegl_fixes_blit (GeglNode* node,
                          gdouble scale,
                          const GeglRectangle* roi,
                          const gchar* format,
                          gint rowstride,
                          GeglBlitFlags flags)
{
    g_return_if_fail (node);
    Babl* bformat;
    gpointer buf;

    bformat = babl_format (format);
    buf = g_malloc (roi->height * rowstride);
    gegl_node_blit(node, scale, roi, bformat, (gpointer)buf, GEGL_AUTO_ROWSTRIDE, flags);
    return buf;
}