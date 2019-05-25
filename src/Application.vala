
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
        //  Gegl.init (ref args);
        
        Gegl.config ().threads = 4;
        Gegl.config ().use_opencl = true;
        Gegl.config ().tile_cache_size = 2000000000;
        Gegl.cl_init ();

var graph = new Gegl.Node ();
            graph.cache_policy = Gegl.CachePolicy.ALWAYS;
            //  var src = node.create_child ("gegl:buffer-source");
            //  src.set_property ("buffer", b);
            var rect = graph.create_child ("gegl:rectangle");
            rect.set_property ("color", new Gegl.Color ("#0000FF"));
            rect.set_property ("width", 700);
            rect.set_property ("height", 1000);
            rect.set_property ("x", 0);
            rect.set_property ("y", 0);


            var src = graph.create_child ("gegl:load");
            src.set_property ("path", "/home/donadigo/testbg.png");

            var over = graph.create_child ("gegl:xor");
            src.connect_to ("output", over, "input");
            rect.connect_to ("output", over, "aux");

            var rotate = graph.create_child ("gegl:rotate");
            rotate.set_property ("degrees", 60);
            over.connect_to ("output", rotate, "input");

            var blur = graph.create_child ("gegl:gaussian-blur");
            blur.set_property ("std-dev-x", 10);
            blur.set_property ("std-dev-y", 10);
            rotate.connect_to ("output", blur, "input");
            //  var over = graph.create_child ("gegl:over");
            //  src.connect_to ("output", over, "input");
            //  rect.connect_to ("output", over, "aux");
            //  img.connect_to ("output", over, "input");

            //  var rotate = graph.create_child ("gegl:rotate");
            //  rotate.set_property ("degrees", 60);
            //  over.connect_to ("output", rotate, "input");

            //  var dst = graph.create_child ("gegl:save");
            //  dst.set_property ("path", "test.jpeg");
            //  rotate.connect_to ("output", dst, "input");

            //  var pix = graph.create_child ("gegl:save");
            //  pix.set_property ("path", "/home/donadigo/xd.png");
            //  blur.connect_to ("output", pix, "input");
            //  new Thread<void*> ("blur", () => {
            //  blur.process ();
            //      return null; 
            //  });


            //  var box = GeglFixes.get_bounding_box (blur);

            //  box.dump ();
            //  box.x = box.y = 0;

            //  int stride = Cairo.Format.ARGB32.stride_for_width (box.width);

            //  var timer = new Timer ();
            //  timer.start ();
            //  uint8* data = GeglFixes.blit<uint8*> (blur, 1, box, "cairo-ARGB32", stride, Gegl.BlitFlags.DEFAULT);
            //  print ((timer.elapsed () * 1000).to_string () + "\n");

            //  var image = new Cairo.ImageSurface.for_data ((uchar[])data, Cairo.Format.ARGB32, box.width, box.height, stride);
            //  image.write_to_png ("/home/donadigo/xd.png");

            var t = new Clutter.Texture();
            t.set_size (1920, 1080);

            var w = new Gtk.Window ();
            var view = new GtkClutter.Embed ();
            view.get_stage ().add_child (t);
            view.get_stage ().set_size (1920, 1080);
            view.hexpand = view.vexpand = true;
            
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            box.add (view);

            //  Gegl.Node? blur2 = null;

            bool working = false;
            var slider = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 50, 1);
            slider.value_changed.connect (() => {
                if (working) {
                    return;
                }
                //  if (blur2 != null) {
                //      view.set_node (null);
                //      //  graph.remove_child (blur2);
                //  }

                //  var blur2 = graph.create_child ("gegl:gaussian-blur");
                rotate.set_property ("degrees", slider.get_value ());
                //                  blur.set_property ("std-dev-x", slider.get_value ());
                //  blur.set_property ("std-dev-y", slider.get_value ());    
            //  over.connect_to ("output", blur, "input");
                
                var roi = new Gegl.Rectangle (0, 0, 1920, 1080);
                int stride = roi.width * 4;
                new Thread<void*> ("a", () => {
                    working = true;
                                var timer = new Timer ();
            timer.start ();
                    blur.process ();
            print ((timer.elapsed () * 1000).to_string () + "\n");
                    uint8* data = GeglFixes.blit<uint8*> (blur, 1, roi, "RGBA u8", stride, Gegl.BlitFlags.CACHE);

                    Idle.add (() => {
                        t.set_from_rgb_data ((uint8[])data, true, roi.width, roi.height, stride, 4, Clutter.TextureFlags.NONE);
                        return false;
                    });

                    working = false;
                    return null;
                });



            //      new Thread<void*> ("a",() => {
            //      blur2.process ();
            //          view.set_node (blur2);
            //          view.queue_draw ();
            //          return null; 
            //      });
                //  view.block = true;
                //  blur.

            });

            box.add (slider);
            w.add (box);
            w.show_all ();

            //  Gtk.main_quit ();
            //  return false;
        //  });

        //  var b = new Gdk.Pixbuf.with_unowned_data (pixels, Gdk.Colorspace.RGB, true, 8, 1920, 1080, 1920 * 4);

        //  b.savev ("/home/donadigo/xd.png", "png", {}, {});
        //  print (box.width.to_string () + "\n");
        Gtk.main ();
        return 0;
        
        Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
        unowned CApp app = get_instance ();
        return app.run (args);
    }
}