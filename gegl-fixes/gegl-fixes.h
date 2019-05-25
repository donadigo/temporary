#include <glib.h>
#include <gegl.h>

GeglRectangle *gegl_fixes_get_bounding_box(GeglNode *node);
gpointer gegl_fixes_blit(GeglNode *node,
                         gdouble scale,
                         const GeglRectangle *roi,
                         const gchar *format,
                         gint rowstride,
                         GeglBlitFlags flags);