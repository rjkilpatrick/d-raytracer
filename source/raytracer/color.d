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

            sink((255.999 * this.x).to!int
                    .to!string);
            sink(" ");
            sink((255.999 * this.y).to!int
                    .to!string);
            sink(" ");
            sink((255.999 * this.z).to!int
                    .to!string);
            break;
        default:
            throw new FormatException("Unknown format specifier: %" ~ fmt.spec);
        }
    }
}
