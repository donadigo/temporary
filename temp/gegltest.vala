//  //  public static Polkit.Permission? get_permission () {
//  //      //  if (Posix.setuid (0) == 0) {
//  //      //      print ("YAY!\n");
//  //      //  }

//  //      Polkit.Permission? permission = null;
//  //      if (permission != null)
//  //          return permission;
//  //      try {
//  //          permission = new Polkit.Permission.sync ("io.elementary.initial-setup", new Polkit.UnixProcess (Posix.getpid ()));
//  //          return permission;
//  //      } catch (Error e) {
//  //          critical (e.message);
//  //          return null;
//  //      }
//  //  }

//  //  public static bool rc_blur_parser (string str, Value val) throws Error {
//  //      print ("PARSE\n");
//  //      return true;
//  //  }

//  //  public static int main(string[] args) {
//  //      Gtk.init (ref args);
//  //      var pspec = new ParamSpecBoolean ("blur", "Blur", "If blur behind should be enabled", false, ParamFlags.READWRITE);
//  //      Gtk.ThemingEngine.register_property ("granite",  null, pspec );


//  //      var w = new Gtk.Window ();
//  //      var sc = w.get_style_context ();
//  //      sc.changed.connect (() => {
//  //      //     print ("CHANGED".to_string () + "\n"); 
//  //      //     var prop = sc.get_property ("blur", Gtk.StateFlags.NORMAL);
//  //      //     print (prop.type_name () + "\n");
//  //      foreach (var n in sc.list_classes ()) {
//  //          print (n.to_string () + "\n");
//  //      }
//  //      });
    
//  //      //  w.install_style_property_parser (pspec, rc_blur_parser);
//  //      w.show_all ();

//  //      Gtk.main ();

//  //      return 0;
//  //  }

//  class Application : Gtk.Application {

//      construct {
//          application_id = "xd.xd";
//      }

//      public override void activate () {
//  var w = new Gtk.ApplicationWindow (this);

//          var embed = new GtkClutter.Embed ();
//          var stage = (Clutter.Stage)embed.get_stage ();
//          stage.set_size (10000, 10000);
//          var a = new Clutter.Texture.from_file ("10k.png");
//          //  a.set_size (10000, 10000);
//          //  a.set_position (-5000, -5000);
//          a.background_color = Clutter.Color.get_static (Clutter.StaticColor.RED);
//          stage.add_child (a);
//          print (a.tile_waste.to_string () + "\n");
//          //  var a = new Clutter.Actor ();
//          //  a.button_press_event.connect (() => {
//          //  print ("PRESS EVENT\n");
//          //  return false; 
//          //  });
//          //  a.reactive = true;
//          //  a.width = 600;
//          //  a.height = 400;
//          //  a.background_color = Clutter.Color.get_static (Clutter.StaticColor.BLACK);

//          //  stage.add_child (a);

//          var g = new Gtk.Grid ();
//          g.add(embed);


//          w.add (g);

//          w.show_all ();
//          add_window (w);

//          //  Gtk.main ();
//      }

//      static int main (string[] args) {
//          GtkClutter.init (ref args);
        
//          var t = new Cogl.Texture.from_file ("10k.png", Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY);
//          var off = new Cogl.Offscreen.to_texture (t);
//          Cogl.push_framebuffer ((Cogl.Framebuffer)off);
//          //  Cogl.set_source_color4ub(255, 0, 0, 255);
//          //  Cogl.pop_framebuffer ();

//          return 0;
//          //  var app = new Application ();
//          //  return app.run (args);
//          //  Gtk.main ();
//      }
//  }

class Examples.Basic : GLib.Object {

    public static int main(string[] args) {
        Gegl.init(ref args);

        {
            var r = new Gegl.Rectangle (0, 0, 838, 517);
            var c = new Gegl.Color ("#FF00FF");
            var b = new Gegl.Buffer (r, null);
            //  var b = new Gegl.Buffer.introspectable_new ("RGBA float", 0, 0, 838, 517);
            //  var b = Gegl.Buffer.load ("/home/donadigo/sample.jpeg");
            //  b.set_color (r, c);

            //  void* data = new float[838 * 517 * 4];
            //  b.get (b.get_extent (), 1.0, "RGBA float", data, 838 * 4 * 4, 0);

            //  for (int i = 0; i < 838 * 517 * 4; i++) {
            //      print ("%u", ((uint8[])data)[i]);

            //  }
            //  print (((float)data[200]).to_string () + "\n");
            //  print (data.length.to_string () + "\n");
            //  b.flush ();
            //  print (b.get_extent ().width.to_string () + "\n");
            //  b.save ("/home/donadigo/build/test.jpeg", r);
            //  return 0;
            
            var graph = new Gegl.Node ();
            graph.set_property("cache-policy", Gegl.CachePolicy.NEVER);
            //  var src = node.create_child ("gegl:buffer-source");
            //  src.set_property ("buffer", b);
            var rect = graph.create_child ("gegl:rectangle");
            rect.set_property ("color", c);
            rect.set_property ("width", 100);
            rect.set_property ("height", 100);
            //  var over = node.create_child ("gegl:over");
            //  src.connect_to ("output", over, "aux");

            var src = graph.create_child ("gegl:load");
            src.set_property ("path", "/home/donadigo/testbg.png");


            var over = graph.create_child ("gegl:over");
            src.connect_to ("output", over, "input");
            rect.connect_to ("output", over, "aux");
            //  img.connect_to ("output", over, "input");

            var rotate = graph.create_child ("gegl:rotate");
            rotate.set_property ("degrees", 60);
            over.connect_to ("output", rotate, "input");

            var dst = graph.create_child ("gegl:save");
            dst.set_property ("path", "test.jpeg");
            rotate.connect_to ("output", dst, "input");

            dst.process ();

            rotate.get_bounding_box (null);

            //  Value val;
            //  rotate.get_property ("bounding-box", out val);
            //  void* bb = rotate.get_bounding_box ();


            //  int stride = Cairo.Format.ARGB32.stride_for_width (200);
            //  uchar[] data = new uint8[stride * 200];
            //  rotate.blit (1.0, new Gegl.Rectangle (200, 400, 200, 200), "cairo-ARGB32", data, stride, Gegl.BlitFlags.DEFAULT);

            //  var image = new Cairo.ImageSurface.for_data (data, Cairo.Format.ARGB32, 200, 200, stride);
            //  var cr = new Cairo.Context (image);
            //  cr.set_source_surface (image, 0, 0);
            //  cr.paint();
            //  image.write_to_png ("test-surface.png");

            
            //  var graph = new Gegl.Node();
            //  var node = graph.create_child("gegl:load");
            //  node.set_property("path", "Apps.png");

            //  //  var node2 = node.create_child("gegl:gaussian-blur");
            //  //  node2.set_property("std-dev-x", 20);
            //  //  node2.set_property("std-dev-y", 20);
            //  //  var node2 = node.create_child("gegl:rotate");
            //  //  node2.set_property("degrees", 60);

            //  Gegl.Buffer buffer;
            //  var node3 = node.create_child("gegl:buffer-source");
            //  //  node3.set_property("path", "/home/donadigo/build/test.png");
            //  //  buffer = (Gegl.Buffer)node3.introspectable_get_property ("buffer");
            //  node3.link (node);
            //  //  var r = node3.introspectable_get_bounding_box ();
            //  //  node3.connect_from ("input", node, "aux");
            //  node3.process ();

            //  var window = new Gtk.Window();
            //  window.title = "GEGL GTK Basic Vala example";
            //  window.set_default_size(300, 300);
            //  window.destroy.connect(Gtk.main_quit);

            //  var node_view = new GeglGtk.View();
            //  node_view.set_node(node);

            //  window.add(node_view);
            //  window.show_all();

            //  Gtk.main();
        }

        Gegl.exit();
        return 0;
    }
}
