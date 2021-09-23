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

    // dfmt off 
    /// Gets red component of the color
    pragma(inline): @property r() const { return e[0]; }

    /// Gets blue component of the color
    pragma(inline): @property g() const { return e[1]; }

    /// Gets green component of the color
    pragma(inline): @property b() const { return e[2]; }

    /// Sets red component of the color
    pragma(inline): @property void r(const double r) { e[0] = r; }

    /// Sets green component of the color
    pragma(inline): @property void g(const double g) { e[1] = g; }

    /// Sets blue component of the color
    pragma(inline): @property void b(const double b) { e[2] = b; }
    // dfmt on 
    
    import std.format : FormatSpec, FormatException;

    override void toString(scope void delegate(const(char)[]) sink, FormatSpec!char fmt) const {

        switch (fmt.spec) {
        case 's':
            import std.conv : to;

            sink((255.999 * this.r).to!int
                    .to!string);
            sink(" ");
            sink((255.999 * this.g).to!int
                    .to!string);
            sink(" ");
            sink((255.999 * this.b).to!int
                    .to!string);
            break;
        default:
            throw new FormatException("Unknown format specifier: %" ~ fmt.spec);
        }
    }
}
