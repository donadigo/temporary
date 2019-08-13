

public enum MIndex {
    XX = 0,
    YX,
    ZX,
    WX, 

    XY,
    YY,
    ZY,
    WY,

    XZ,
    YZ,
    ZZ,
    WZ,

    XW,
    YW,
    ZW,
    WW
}

namespace Utils { 
    static void print_matrix (Cogl.Matrix matrix) {
        print ("[ %.2f %.2f %.2f %.2f ]\n", matrix.ww, matrix.wx, matrix.wy, matrix.wz);
        print ("[ %.2f %.2f %.2f %.2f ]\n", matrix.xw, matrix.xx, matrix.xy, matrix.xz);
        print ("[ %.2f %.2f %.2f %.2f ]\n", matrix.yw, matrix.yx, matrix.yy, matrix.yz);
        print ("[ %.2f %.2f %.2f %.2f ]\n", matrix.zw, matrix.zx, matrix.zy, matrix.zz);
    }

    static void print_node (Gegl.Node node, int level = 0) {
        string pad = "";
        for (int i = 0; i < level; i++) {
            pad += "\t";
        }

        print ("%s\n", pad + node.get_operation ());
        foreach (unowned Gegl.Node child in node.get_children ()) {
            print_node (child, level + 1);
        }
    }
}
