/* gegltest.c generated by valac 0.40.15, the Vala compiler
 * generated from gegltest.vala, do not modify */

/*  //  public static Polkit.Permission? get_permission () {*/
/*  //      //  if (Posix.setuid (0) == 0) {*/
/*  //      //      print ("YAY!\n");*/
/*  //      //  }*/
/*  //      Polkit.Permission? permission = null;*/
/*  //      if (permission != null)*/
/*  //          return permission;*/
/*  //      try {*/
/*  //          permission = new Polkit.Permission.sync ("io.elementary.initial-setup", new Polkit.UnixProcess (Posix.getpid ()));*/
/*  //          return permission;*/
/*  //      } catch (Error e) {*/
/*  //          critical (e.message);*/
/*  //          return null;*/
/*  //      }*/
/*  //  }*/
/*  //  public static bool rc_blur_parser (string str, Value val) throws Error {*/
/*  //      print ("PARSE\n");*/
/*  //      return true;*/
/*  //  }*/
/*  //  public static int main(string[] args) {*/
/*  //      Gtk.init (ref args);*/
/*  //      var pspec = new ParamSpecBoolean ("blur", "Blur", "If blur behind should be enabled", false, ParamFlags.READWRITE);*/
/*  //      Gtk.ThemingEngine.register_property ("granite",  null, pspec );*/
/*  //      var w = new Gtk.Window ();*/
/*  //      var sc = w.get_style_context ();*/
/*  //      sc.changed.connect (() => {*/
/*  //      //     print ("CHANGED".to_string () + "\n"); */
/*  //      //     var prop = sc.get_property ("blur", Gtk.StateFlags.NORMAL);*/
/*  //      //     print (prop.type_name () + "\n");*/
/*  //      foreach (var n in sc.list_classes ()) {*/
/*  //          print (n.to_string () + "\n");*/
/*  //      }*/
/*  //      });*/
/*  //      //  w.install_style_property_parser (pspec, rc_blur_parser);*/
/*  //      w.show_all ();*/
/*  //      Gtk.main ();*/
/*  //      return 0;*/
/*  //  }*/
/*  class Application : Gtk.Application {*/
/*      construct {*/
/*          application_id = "xd.xd";*/
/*      }*/
/*      public override void activate () {*/
/*  var w = new Gtk.ApplicationWindow (this);*/
/*          var embed = new GtkClutter.Embed ();*/
/*          var stage = (Clutter.Stage)embed.get_stage ();*/
/*          stage.set_size (10000, 10000);*/
/*          var a = new Clutter.Texture.from_file ("10k.png");*/
/*          //  a.set_size (10000, 10000);*/
/*          //  a.set_position (-5000, -5000);*/
/*          a.background_color = Clutter.Color.get_static (Clutter.StaticColor.RED);*/
/*          stage.add_child (a);*/
/*          print (a.tile_waste.to_string () + "\n");*/
/*          //  var a = new Clutter.Actor ();*/
/*          //  a.button_press_event.connect (() => {*/
/*          //  print ("PRESS EVENT\n");*/
/*          //  return false; */
/*          //  });*/
/*          //  a.reactive = true;*/
/*          //  a.width = 600;*/
/*          //  a.height = 400;*/
/*          //  a.background_color = Clutter.Color.get_static (Clutter.StaticColor.BLACK);*/
/*          //  stage.add_child (a);*/
/*          var g = new Gtk.Grid ();*/
/*          g.add(embed);*/
/*          w.add (g);*/
/*          w.show_all ();*/
/*          add_window (w);*/
/*          //  Gtk.main ();*/
/*      }*/
/*      static int main (string[] args) {*/
/*          GtkClutter.init (ref args);*/
/*          var t = new Cogl.Texture.from_file ("10k.png", Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY);*/
/*          var off = new Cogl.Offscreen.to_texture (t);*/
/*          Cogl.push_framebuffer ((Cogl.Framebuffer)off);*/
/*          //  Cogl.set_source_color4ub(255, 0, 0, 255);*/
/*          //  Cogl.pop_framebuffer ();*/
/*          return 0;*/
/*          //  var app = new Application ();*/
/*          //  return app.run (args);*/
/*          //  Gtk.main ();*/
/*      }*/
/*  }*/


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gegl.h>


#define EXAMPLES_TYPE_BASIC (examples_basic_get_type ())
#define EXAMPLES_BASIC(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), EXAMPLES_TYPE_BASIC, ExamplesBasic))
#define EXAMPLES_BASIC_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), EXAMPLES_TYPE_BASIC, ExamplesBasicClass))
#define EXAMPLES_IS_BASIC(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), EXAMPLES_TYPE_BASIC))
#define EXAMPLES_IS_BASIC_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), EXAMPLES_TYPE_BASIC))
#define EXAMPLES_BASIC_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), EXAMPLES_TYPE_BASIC, ExamplesBasicClass))

typedef struct _ExamplesBasic ExamplesBasic;
typedef struct _ExamplesBasicClass ExamplesBasicClass;
typedef struct _ExamplesBasicPrivate ExamplesBasicPrivate;
enum  {
	EXAMPLES_BASIC_0_PROPERTY,
	EXAMPLES_BASIC_NUM_PROPERTIES
};
static GParamSpec* examples_basic_properties[EXAMPLES_BASIC_NUM_PROPERTIES];
#define __vala_GeglRectangle_free0(var) ((var == NULL) ? NULL : (var = (_vala_GeglRectangle_free (var), NULL)))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

struct _ExamplesBasic {
	GObject parent_instance;
	ExamplesBasicPrivate * priv;
};

struct _ExamplesBasicClass {
	GObjectClass parent_class;
};


static gpointer examples_basic_parent_class = NULL;

GType examples_basic_get_type (void) G_GNUC_CONST;
gint examples_basic_main (gchar** args,
                          int args_length1);
static void _vala_GeglRectangle_free (GeglRectangle* self);
ExamplesBasic* examples_basic_new (void);
ExamplesBasic* examples_basic_construct (GType object_type);


static gpointer
_g_object_ref0 (gpointer self)
{
	return self ? g_object_ref (self) : NULL;
}


static void
_vala_GeglRectangle_free (GeglRectangle* self)
{
	g_boxed_free (gegl_rectangle_get_type (), self);
}


gint
examples_basic_main (gchar** args,
                     int args_length1)
{
	gint result = 0;
	gegl_init (&args_length1, &args);
	{
		GeglRectangle* r = NULL;
		GeglRectangle* _tmp0_;
		GeglColor* c = NULL;
		GeglColor* _tmp1_;
		GeglBuffer* b = NULL;
		GeglBuffer* _tmp2_;
		GeglNode* graph = NULL;
		GeglNode* _tmp3_;
		GValue _tmp4_ = {0};
		GeglNode* rect = NULL;
		GeglNode* _tmp5_;
		GeglNode* _tmp6_;
		GValue _tmp7_ = {0};
		GValue _tmp8_ = {0};
		GValue _tmp9_ = {0};
		GeglNode* src = NULL;
		GeglNode* _tmp10_;
		GeglNode* _tmp11_;
		GValue _tmp12_ = {0};
		GeglNode* over = NULL;
		GeglNode* _tmp13_;
		GeglNode* _tmp14_;
		GeglNode* rotate = NULL;
		GeglNode* _tmp15_;
		GeglNode* _tmp16_;
		GValue _tmp17_ = {0};
		GeglNode* dst = NULL;
		GeglNode* _tmp18_;
		GeglNode* _tmp19_;
		GValue _tmp20_ = {0};
		GeglRectangle* _tmp21_;
		GeglRectangle* _tmp22_;
		_tmp0_ = gegl_rectangle_new (0, 0, (guint) 838, (guint) 517);
		r = _tmp0_;
		_tmp1_ = gegl_color_new ("#FF00FF");
		c = _tmp1_;
		_tmp2_ = gegl_buffer_new (r, NULL);
		b = _tmp2_;
		_tmp3_ = gegl_node_new ();
		graph = _tmp3_;
		g_value_init (&_tmp4_, gegl_cache_policy_get_type ());
		g_value_set_enum (&_tmp4_, GEGL_CACHE_POLICY_NEVER);
		gegl_node_set_property (graph, "cache-policy", &_tmp4_);
		G_IS_VALUE (&_tmp4_) ? (g_value_unset (&_tmp4_), NULL) : NULL;
		_tmp5_ = gegl_node_create_child (graph, "gegl:rectangle");
		_tmp6_ = _g_object_ref0 (_tmp5_);
		rect = _tmp6_;
		g_value_init (&_tmp7_, gegl_color_get_type ());
		g_value_set_object (&_tmp7_, c);
		gegl_node_set_property (rect, "color", &_tmp7_);
		G_IS_VALUE (&_tmp7_) ? (g_value_unset (&_tmp7_), NULL) : NULL;
		g_value_init (&_tmp8_, G_TYPE_INT);
		g_value_set_int (&_tmp8_, 100);
		gegl_node_set_property (rect, "width", &_tmp8_);
		G_IS_VALUE (&_tmp8_) ? (g_value_unset (&_tmp8_), NULL) : NULL;
		g_value_init (&_tmp9_, G_TYPE_INT);
		g_value_set_int (&_tmp9_, 100);
		gegl_node_set_property (rect, "height", &_tmp9_);
		G_IS_VALUE (&_tmp9_) ? (g_value_unset (&_tmp9_), NULL) : NULL;
		_tmp10_ = gegl_node_create_child (graph, "gegl:load");
		_tmp11_ = _g_object_ref0 (_tmp10_);
		src = _tmp11_;
		g_value_init (&_tmp12_, G_TYPE_STRING);
		g_value_set_string (&_tmp12_, "/home/donadigo/testbg.png");
		gegl_node_set_property (src, "path", &_tmp12_);
		G_IS_VALUE (&_tmp12_) ? (g_value_unset (&_tmp12_), NULL) : NULL;
		_tmp13_ = gegl_node_create_child (graph, "gegl:over");
		_tmp14_ = _g_object_ref0 (_tmp13_);
		over = _tmp14_;
		gegl_node_connect_to (src, "output", over, "input");
		gegl_node_connect_to (rect, "output", over, "aux");
		_tmp15_ = gegl_node_create_child (graph, "gegl:rotate");
		_tmp16_ = _g_object_ref0 (_tmp15_);
		rotate = _tmp16_;
		g_value_init (&_tmp17_, G_TYPE_INT);
		g_value_set_int (&_tmp17_, 60);
		gegl_node_set_property (rotate, "degrees", &_tmp17_);
		G_IS_VALUE (&_tmp17_) ? (g_value_unset (&_tmp17_), NULL) : NULL;
		gegl_node_connect_to (over, "output", rotate, "input");
		_tmp18_ = gegl_node_create_child (graph, "gegl:save");
		_tmp19_ = _g_object_ref0 (_tmp18_);
		dst = _tmp19_;
		g_value_init (&_tmp20_, G_TYPE_STRING);
		g_value_set_string (&_tmp20_, "test.jpeg");
		gegl_node_set_property (dst, "path", &_tmp20_);
		G_IS_VALUE (&_tmp20_) ? (g_value_unset (&_tmp20_), NULL) : NULL;
		gegl_node_connect_to (rotate, "output", dst, "input");
		gegl_node_process (dst);
		_tmp21_ = gegl_node_get_bounding_box (rotate);
		_tmp22_ = _tmp21_;
		__vala_GeglRectangle_free0 (_tmp22_);
		_g_object_unref0 (dst);
		_g_object_unref0 (rotate);
		_g_object_unref0 (over);
		_g_object_unref0 (src);
		_g_object_unref0 (rect);
		_g_object_unref0 (graph);
		_g_object_unref0 (b);
		_g_object_unref0 (c);
		__vala_GeglRectangle_free0 (r);
	}
	gegl_exit ();
	result = 0;
	return result;
}


int
main (int argc,
      char ** argv)
{
	return examples_basic_main (argv, argc);
}


ExamplesBasic*
examples_basic_construct (GType object_type)
{
	ExamplesBasic * self = NULL;
	self = (ExamplesBasic*) g_object_new (object_type, NULL);
	return self;
}


ExamplesBasic*
examples_basic_new (void)
{
	return examples_basic_construct (EXAMPLES_TYPE_BASIC);
}


static void
examples_basic_class_init (ExamplesBasicClass * klass)
{
	examples_basic_parent_class = g_type_class_peek_parent (klass);
}


static void
examples_basic_instance_init (ExamplesBasic * self)
{
}


GType
examples_basic_get_type (void)
{
	static volatile gsize examples_basic_type_id__volatile = 0;
	if (g_once_init_enter (&examples_basic_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ExamplesBasicClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) examples_basic_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ExamplesBasic), 0, (GInstanceInitFunc) examples_basic_instance_init, NULL };
		GType examples_basic_type_id;
		examples_basic_type_id = g_type_register_static (G_TYPE_OBJECT, "ExamplesBasic", &g_define_type_info, 0);
		g_once_init_leave (&examples_basic_type_id__volatile, examples_basic_type_id);
	}
	return examples_basic_type_id__volatile;
}


