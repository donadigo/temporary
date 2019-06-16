
public class CApp : Gtk.Application {
    static CApp? instance;
    public static unowned CApp get_instance () {
        if (instance == null) instance = new CApp ();
        return instance;
    }

    construct {
        application_id = "com.github.donadigo.crazy-project";
    }

    public override void activate () {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("com/github/donadigo/crazy-project/application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        unowned List<Gtk.Window> windows = get_windows ();
        if (windows.length () > 0) {
            windows.nth (0).data.present ();
            return;
        }

        var window = new CMainWindow (this);
        window.show_all ();
    }

    public static int main (string[] args) {
        GtkClutter.init (ref args);
        Gegl.init (ref args);
        Formats.init ();
        GlobalKeyState.init ();
        
        //  Gegl.config ().threads = 4;
        //  Gegl.config ().use_opencl = true;
        //  Gegl.config ().tile_cache_size = 2000000000;
        //  Gegl.cl_init ();

        //  var graph = new Gegl.Node ();
        //  //  graph.cache_policy = Gegl.CachePolicy.ALWAYS;
        //  //  var src = node.create_child ("gegl:buffer-source");
        //  //  src.set_property ("buffer", b);
        //  //  var rect = graph.create_child ("gegl:rectangle");
        //  //  rect.set_property ("color", new Gegl.Color ("#FF0000"));
        //  //  rect.set_property ("width", 700);
        //  //  rect.set_property ("height", 1000);

        //  //  var layer = graph.create_child ("gegl:layer");
        //  //  layer.set_property ("composite-op", "gegl:over");
        //  //  layer.set_property ("x", 0);
        //  //  layer.set_property ("y", 0);
        //  //  rect.connect_to ("output", layer, "aux");

        //  var src = graph.create_child ("gegl:load");
        //  src.set_property ("path", "/home/donadigo/sample.jpeg");

        //  //  var over = graph.create_child ("gegl:xor");
        //  //  src.connect_to ("output", over, "input");
        //  //  rect.connect_to ("output", over, "aux");

        //  //  src.connect_to ("output", layer, "input");

        //  //  var rotate = graph.create_child ("gegl:rotate");
        //  //  rotate.set_property ("degrees", 0);
        //  //  layer.connect_to ("output", rotate, "input");

        //  //  var blur = graph.create_child ("gegl:gaussian-blur");
        //  //  blur.set_property ("std-dev-x", 0);
        //  //  blur.set_property ("std-dev-y", 0);
        //  //  rotate.connect_to ("output", blur, "input");
        //  //  var over = graph.create_child ("gegl:over");
        //  //  src.connect_to ("output", over, "input");
        //  //  rect.connect_to ("output", over, "aux");
        //  //  img.connect_to ("output", over, "input");

        //  //  var rotate = graph.create_child ("gegl:rotate");
        //  //  rotate.set_property ("degrees", 60);
        //  //  over.connect_to ("output", rotate, "input");

        //  //  var dst = graph.create_child ("gegl:save");
        //  //  dst.set_property ("path", "test.jpeg");
        //  //  rotate.connect_to ("output", dst, "input");

        //  //  var pix = graph.create_child ("gegl:save");
        //  //  pix.set_property ("path", "/home/donadigo/xd.png");
        //  //  blur.connect_to ("output", pix, "input");
        //  //  new Thread<void*> ("blur", () => {
        //  //  blur.process ();
        //  //      return null; 
        //  //  });


        //  var output_node = src;

        //  var bbox = GeglFixes.get_bounding_box (output_node);

        //  bbox.dump ();

        //  var t = new Clutter.Texture();
        //  t.set_size (1920, 1080);

        //  var w = new Gtk.Window ();
        //  var view = new GtkClutter.Embed ();
        //  view.get_stage ().add_child (t);
        //  view.get_stage ().set_size (1920, 1080);
        //  view.hexpand = view.vexpand = true;
        
        //  var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        //  box.add (view);

        //  //  Gegl.Node? blur2 = null;

        //  bool working = false;
        //  var slider = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 50, 1);
        //  slider.value_changed.connect (() => {
        //      if (working) {
        //          return;
        //      }

        //      var roi = new Gegl.Rectangle (0, 0, 1920, 1080);
        //      int stride = roi.width * 3;
        //      new Thread<void*> ("a", () => {
        //          working = true;
        //          var timer = new Timer ();
        //          timer.start ();
        //          output_node.process ();
        //          print ((timer.elapsed () * 1000).to_string () + "\n");
        //          uint8* data = GeglFixes.blit<uint8*> (output_node, 1, roi, "RGB u8", stride, Gegl.BlitFlags.DEFAULT);

        //          Idle.add (() => {
        //              t.set_from_rgb_data ((uint8[])data, false, roi.width, roi.height, stride, 3, Clutter.TextureFlags.NONE);
        //              return false;
        //          });

        //          working = false;
        //          return null;
        //      });

        //  });

        //  box.add (slider);
        //  w.add (box);
        //  w.show_all ();

        //  //      Gtk.main_quit ();
        //  //      return false;
        //  //  });
        //  Gtk.main();

        //  var b = new Gdk.Pixbuf.with_unowned_data (pixels, Gdk.Colorspace.RGB, true, 8, 1920, 1080, 1920 * 4);

        //  b.savev ("/home/donadigo/xd.png", "png", {}, {});
        //  print (box.width.to_string () + "\n");
        //  Gtk.main ();
        //  return 0;
        
        //  Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
        unowned CApp app = get_instance ();
        return app.run (args);
    }
}