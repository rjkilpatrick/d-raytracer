module raytracer.vec3;

/++
    Simple 3-vector implementation using D's niceties

    For a more production ready ray-tracer than a naive array based implementation,
    use the [mir ndslice](https://github.com/libmir/mir-algorithm)
+/
class Vec3 {
public:
    // dfmt off 
    /// Gets x component of the vector
    pragma(inline): @property x() const { return e[0]; } // TODO: Remove pure

    /// Gets y component of the vector
    pragma(inline): @property y() const { return e[1]; } // TODO: Remove pure

    /// Gets z component of the vector
    pragma(inline): @property z() const { return e[2]; } // TODO: Remove pure

    /// Sets x component of the vector
    pragma(inline): @property void x(const double x) { e[0] = x; }

    /// Sets y component of the vector
    pragma(inline): @property void y(const double y) { e[1] = y; }

    /// Sets z component of the vector
    pragma(inline): @property void z(const double z) { e[2] = z; }
    // dfmt on 

    /// Returns Vec3 populated as all zeros
    this() pure {
        e[] = 0;
    }

    /// Returns Vec3 filled with x 
    this(double x) pure {
        e[] = x;
    }

    /// Returns Vec3 filled with x, y, z 
    this(double x, double y, double z) pure {
        e = [x, y, z];
    }

    /// Negate Vec3
    auto opUnary(string op)() if (op == "-") {
        return new Vec3(-this.x, -this.y, -this.z);
    }

    /// Overloads a[] = v
    void opIndexAssign(double value) {
        e[] = value;
    }

    /// Determine element-wise equality
    override bool opEquals(const Object o) const {
        import std.math.operations : isClose;
        import std.conv : to;

        auto rhs = o.to!(const Vec3);

        return isClose(this.x, rhs.x) && isClose(this.y, rhs.y) && isClose(this.z, rhs.z);
    }
    // bool opEquals()(auto ref const Vec3 rhs) const {
    //     import std.math.operations : isClose;

    //     return isClose(this.x, rhs.x) && isClose(this.y, rhs.y) && isClose(this.z, rhs.z);
    // }

    /// Left binary scalar ops. [+, -, *, /]
    auto opBinary(string op, this T)(double rhs) const 
            if ((op == "+") || (op == "-") || (op == "*") || (op == "/")) {
        return mixin("new T(this.x " ~ op ~ " rhs, this.y " ~ op ~ " rhs, this.z " ~ op ~ " rhs)");
    }

    /// Right binary scalar ops. [+, -, *, /]
    auto opBinaryRight(string op, this T)(double lhs) const 
            if ((op == "+") || (op == "-") || (op == "*") || (op == "/")) {
        return mixin("new T(lhs " ~ op ~ " this.x, lhs " ~ op ~ " this.y, lhs " ~ op ~ " this.z)");
    }

    /// Binary Vec3 ops
    auto opBinary(string op, this T)(T rhs) const if ((op == "+") || (op == "-")) {
        return mixin("new T(this.x " ~ op ~ " rhs.x, this.y " ~ op
                ~ " rhs.y, this.z " ~ op ~ " rhs.z)");
    }

    /// Returns the euclidean length
    double length() const {
        import std.math : sqrt;

        return sqrt(this.lengthSquared);
    }

    /// Returns the square of the euclidean length
    double lengthSquared() const {
        // return this.dot(this);
        return (e[0] * e[0]) + (e[1] * e[1]) + (e[2] * e[2]);
    }

    import std.format : FormatSpec, FormatException;

    ///   
    void toString(scope void delegate(const(char)[]) sink, FormatSpec!char fmt) const {

        switch (fmt.spec) {
        case 's':
            import std.conv : to;

            sink(this.x.to!string);
            sink(" ");
            sink(this.y.to!string);
            sink(" ");
            sink(this.z.to!string);
            break;
        default:
            throw new FormatException("Unknown format specifier: %" ~ fmt.spec);
        }
    }

    /// Duplicate copy of class instance with same properties
    auto dup() const {
        return new Vec3(this.x, this.y, this.z);
    }

    /// Duplicate copy of class instance with same properties
    auto idup() const {
        return new const Vec3(this.x, this.y, this.z);
    }

    /// $
    @property int opDollar(size_t dim : 0)() const {
        return e.length;
    }

private:
    double[3] e;
}

///
unittest {
    // Default constructor
    const zeros = new Vec3();
    assert((zeros.x == 0) && (zeros.y == 0) && (zeros.z == 0));

    // Single element constructor
    const ones = new Vec3(1);
    assert((ones.x == 1) && (ones.y == 1) && (ones.z == 1));

    // Three elemnt constructor
    auto vec = new Vec3(1, 2, -1);

    // Length & Length square
    import std.math : sqrt;

    assert(ones.lengthSquared == double(3));
    assert(ones.length == sqrt(3.0));

    // Getters and setters
    vec.x = 0;
    assert(vec.x == 0);

    // Equality
    assert((new Vec3(0, 0, 0)) == (new Vec3(0, 0, 0)));

    // Negation
    assert(new Vec3(-1) == -(new Vec3(1)));

    // Scalar Addition, Subtraction, Multiplication, Division
    // TODO: Convert to slicing only
    assert((new Vec3(2)) + double(2) == new Vec3(4));
    assert((new Vec3(4)) - double(2) == new Vec3(2));
    assert((new Vec3(2)) * double(2) == new Vec3(4));
    assert((new Vec3(4)) / double(2) == new Vec3(2));

    // Vector Addition, Subtraction
    assert((new Vec3(2) + new Vec3(2)) == new Vec3(4));
    assert((new Vec3(4) - new Vec3(2)) == new Vec3(2));

    // Slicing
    auto x = new Vec3(0);
    x[] = 1;
    assert(x == new Vec3(1));
}

/// Dot product
double dot(const Vec3 u, const Vec3 v) {
    return (u.x * v.x) + (u.y * v.y) + (u.z * v.z);
}

///
unittest {
    const Vec3 ones = new Vec3(1); // [1, 1, 1]
    assert(ones.dot(ones) == 3);
}

/// Cross product in cartesian co-ordinates
auto cross(const Vec3 u, const Vec3 v) {
    // dfmt off
    return new Vec3((u.y * v.z) - (u.z * v.y),
                (u.z * v.x) - (u.x * v.z),
                (u.x * v.y) - (u.y * v.x));
    // dfmt on
}

/// Duplicate a vector
auto dup(const Vec3 u) {
    return new Vec3(u.x, u.y, u.z);
}

/// Cross product
unittest {
    auto x = new Vec3(1, 0, 0);
    auto y = new Vec3(0, 1, 0);
    auto z = new Vec3(0, 0, 1);

    assert(x.cross(y) == z);
}

/// Creates a unitvector from a vector
auto unitVector(const Vec3 v) {
    import std.conv : to;

    const double lengthReciprocal = 1.0 / v.length.to!double;
    return v.dup * lengthReciprocal; //new Vec3(v.x * lengthReciprocal, v.y * lengthReciprocal, v.z * lengthReciprocal);
}

///
unittest {
    // Unit vector
    auto ones = new Vec3(1); // [1, 1, 1]
    import std.math : sqrt;

    assert(ones.length == sqrt(double(3)));

    assert(ones.unitVector.length == 1);
}

/++
    3D point
+/
alias Point3 = Vec3;
