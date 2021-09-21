module raytracer.ray;

import raytracer.vec3;

/++
    The one thing that all ray tracers have is a ray class and a computation of what
    color is seen along a ray. Let’s think of a ray as a function P(t)=A+tb. Here P
    is a 3D position along a line in 3D. A is the ray origin and b is the ray
    direction. The ray parameter t is a real number (double in the code). Plug in a
    different t and P(t) moves the point along the ray. Add in negative t values and
    you can go anywhere on the 3D line. For positive t, you get only the parts in
    front of A, and this is what is often called a half-line or ray.
+/
class Ray {

    /// Creates a new ray
    this(const Point3 origin, const Vec3 direction) {
        _origin = origin;
        _direction = direction;
    }

    /// Gets origin of the ray
    @property origin() pure const {
        return _origin;
    }
    /// Gets origin of the ray
    @property direction() pure const {
        return _direction;
    }

    /// Gets ray at parameter t
    Point3 at(double t) const {
        import std.conv : to;
        return _origin.dup + (t * _direction).dup.to!Point3;
    }

private:
    const Vec3 _direction;
    const Point3 _origin;
}
