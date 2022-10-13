module raytracer.color;

import raytracer.vec3;

/// 3-vector of RGB color
class Color : Vec3 {

    /// Returns black Color
    this() pure {
        super();
    }

    /// Returns Gray-scale Color
    this(double gray) pure {
        super(gray);
    }

    /// Returns Color filled with r, g, b
    this(double r, double g, double b) pure {
        super(r, g, b);
    }

    import std.format : FormatSpec, FormatException;

    override void toString(scope void delegate(const(char)[]) sink, FormatSpec!char fmt) const {
        switch (fmt.spec) {
        case 's':
            import std.conv : to;
            import std.math : sqrt;

            // Gamm correct for gamma = 2.0
            auto r = sqrt(this.x);
            auto g = sqrt(this.y);
            auto b = sqrt(this.z);

            sink((255.999 * r).to!int
                    .to!string);
            sink(" ");
            sink((255.999 * g).to!int
                    .to!string);
            sink(" ");
            sink((255.999 * b).to!int
                    .to!string);
            break;
        default:
            throw new FormatException("Unknown format specifier: %" ~ fmt.spec);
        }
    }

    static Color black() {
        return new Color(0.);
    }

    static Color white() {
        return new Color(1.0);
    }
}
