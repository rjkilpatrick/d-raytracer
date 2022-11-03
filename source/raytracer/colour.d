module raytracer.colour;

import raytracer.vec3;

/// 3-vector of RGB colour
class Colour : Vec3 {

    /// Returns black Colour
    this() pure {
        super();
    }

    /// Returns Gray-scale Colour
    this(double gray) pure {
        super(gray);
    }

    /// Returns Colour filled with r, g, b
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

    static Colour black() {
        return new Colour(0.);
    }

    static Colour white() {
        return new Colour(1.0);
    }
}
