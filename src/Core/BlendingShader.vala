public enum Core.BlendingMode {
    NORMAL = 0,
    MULTIPLY = 1,
    SCREEN = 2,
    OVERLAY = 3,
    SOFT_LIGHT = 4,
    HARD_LIGHT = 5,
    COLOR_BURN = 6,
    LINEAR_BURN = 7,
    ADD = 8,
    SUBTRACT = 9,
    EXCLUSION = 10,
    LAST = 11;

    public static string get_name (BlendingMode mode) {
        switch (mode) {
            case NORMAL:
                return _("Normal");
            case MULTIPLY:
                return _("Multiply");
            case SCREEN:
                return _("Screen");
            case OVERLAY:
                return _("Overlay");
            case SOFT_LIGHT:
                return _("Soft light");
            case HARD_LIGHT:
                return _("Hard light");
            case COLOR_BURN:
                return _("Color burn");
            case LINEAR_BURN:
                return _("Linear burn");
            case ADD:
                return _("Add");
            case SUBTRACT:
                return _("Subtract");
            case EXCLUSION:
                return _("Exclusion");
            default:
                assert_not_reached ();
        }
    }

    public static string to_gegl_op (BlendingMode mode) {
        switch (mode) {
            case MULTIPLY:
                return "gegl:multiply";
            case SCREEN:
                return "gegl:screen";
            case LINEAR_BURN:
                return "gegl:color-burn";
            case OVERLAY:
                return "gegl:overlay";
            case SOFT_LIGHT:
                return "gegl:soft-light";
            default:
                return "gegl:over";
        }
    }
}

public class Core.BlendingShader : Object {
    // https://github.com/jamieowen/glsl-blend
    const string FRAGMENT_SOURCE = """
        uniform sampler2D tex0;
        uniform sampler2D tex1;
        uniform int type;

        float soft_light_channel (float base, float blend) {
            return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
        }

        vec3 soft_light (vec3 base, vec3 blend) {
            return vec3 (
                soft_light_channel (base.r, blend.r),
                soft_light_channel (base.g, blend.g),
                soft_light_channel (base.b, blend.b)
            );
        }

        float color_burn_channel (float base, float blend) {
            return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
        }

        vec3 color_burn (vec3 base, vec3 blend) {
            return vec3 (
                color_burn_channel (base.r,blend.r),
                color_burn_channel (base.g,blend.g),
                color_burn_channel (base.b,blend.b)
            );
        }

        float color_burn_gegl (float cA, float cB, float aA, float aB) {
            float aD = aA + aB - aA * aB;

            if (cA * aB + cB * aA <= aA * aB) {
                return clamp (cA * (1 - aB) + cB * (1 - aA), 0, aD);
            } else {
                return clamp ((cA == 0 ? 1 : (aA * (cA * aB + cB * aA - aA * aB) / cA) + cA * (1 - aB) + cB * (1 - aA)), 0, aD);
            }
        }

        float soft_light_gegl (float cA, float cB, float aA, float aB) {
            float aD = aA + aB - aA * aB;

            if (2 * cA < aA) {
                return (cB * (aA - (aB == 0 ? 1 : 1 - cB / aB) * (2 * cA - aA)) + cA * (1 - aB) + cB * (1 - aA), 0, aD);
            } else if (8 * cB <= aB) {
                return clamp (cB * (aA - (aB == 0 ? 1 : 1 - cB / aB) * (2 * cA - aA) * (aB == 0 ? 3 : 3 - 8 * cB / aB)) + cA * (1 - aB) + cB * (1 - aA), 0, aD);
            } else {
                return clamp ((aA * cB + (aB == 0 ? 0 : sqrt (cB / aB) * aB - cB) * (2 * cA - aA)) + cA * (1 - aB) + cB * (1 - aA), 0, aD);
            }
        }

        float screen_gegl (float cA, float cB, float aA, float aB) {
            float aD = aA + aB - aA * aB;
            return clamp (cA + cB - cA * cB, 0, aD);
        }

        void main () {
            vec4 t0 = texture2D(tex0, cogl_tex_coord0_in.xy);
            vec4 t1 = texture2D(tex1, cogl_tex_coord1_in.xy);

            vec4 c = t1;
            if (type == 1) {
                c = t0 * t1;
            } else if (type == 2) {
                float aD = t1.a + t0.a - t1.a * t0.a;
                float r = screen_gegl(t1.r, t0.r, t1.a, t0.a);
                float g = screen_gegl(t1.g, t0.g, t1.a, t0.a);
                float b = screen_gegl(t1.b, t0.b, t1.a, t0.a);
                c = vec4(r, g, b, aD);
                //  c = vec4(r, g, b, aD);
                //  c = 1 - (1 - t0) * (1 - t1);
            } else if (type == 3) {
                c = (1 - 2 * t1) * t0 * t0 + 2 * t1 * t0;
            } else if (type == 4) {
                //  c = vec4 (soft_light (t0.rgb, t1.rgb), 1.0);
                float aD = t1.a + t0.a - t1.a * t0.a;

                float r = soft_light_gegl(t1.r, t0.r, t1.a, t0.a);
                float g = soft_light_gegl(t1.g, t0.g, t1.a, t0.a);
                float b = soft_light_gegl(t1.b, t0.b, t1.a, t0.a);
                c = vec4(r, g, b, aD);
            } else if (type == 5) {
                c = (1 - 2 * t1) * t0 * t0 + 2 * t1 * t0;
            } else if (type == 6) {
                c = vec4 (color_burn (t0.rgb, t1.rgb), 1.0);
            } else if (type == 7) {
                //  c = max (t0 + t1 - 1, 0);

                float aD = t1.a + t0.a - t1.a * t0.a;
                float r = color_burn_gegl(t1.r, t0.r, t1.a, t0.a);
                float g = color_burn_gegl(t1.g, t0.g, t1.a, t0.a);
                float b = color_burn_gegl(t1.b, t0.b, t1.a, t0.a);

                c = vec4(r, g, b, aD);
                //  if ()
            } else if (type == 8) {
                c = min(t0 + t1, vec4 (1.0));
            } else if (type == 9) {
                c = t0 + t1 - 1;
            } else if (type == 10) {
                c = t0 + t1 - 2.0 * t0 * t1;
            }

            cogl_color_out = mix(t0, c, t1.a);
        }
    """;

    public Cogl.Program program { get; construct; }
    Cogl.Shader shader;
    int type_location = -1;

    private static BlendingShader? instance;
    public static unowned BlendingShader get_default () {
        if (instance == null) {
            instance = new BlendingShader ();
        }

        return instance;
    }

    construct {
        shader = new Cogl.Shader (Cogl.ShaderType.FRAGMENT);
        shader.source (FRAGMENT_SOURCE);
        shader.compile ();

        program = new Cogl.Program ();
        program.attach_shader (shader);

        int location = program.get_uniform_location ("tex0");
        CoglFixes.set_uniform_1i (program, location, 0);

        location = program.get_uniform_location ("tex1");
        CoglFixes.set_uniform_1i (program, location, 1);
        
        type_location = program.get_uniform_location ("type");
        set_mode (BlendingMode.NORMAL);
    }

    public void set_mode (BlendingMode mode) {
        if (type_location != -1) {
            CoglFixes.set_uniform_1i (program, type_location, (int)mode);
        }
    }
}