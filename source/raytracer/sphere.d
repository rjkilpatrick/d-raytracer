module raytracer.sphere;

import raytracer;

/// Basic sphere hittable object
class Sphere : Hittable {
    this() {
    }

    this(Point3 centre, double radius, Material material) {
        _center = centre;
        _radius = radius;
        _material = material;
    }

    ///
    override bool hit(const Ray ray, double tMin, double tMax, ref HitRecord hitRecord) const {
        import std.conv : to;
        Vec3 oc = (ray.origin.dup - _center).dup.to!Vec3;

        // Uses discriminant from quadratic equation solved
        const a = ray.direction.lengthSquared;
        const halfB = oc.dot(ray.direction);
        const c = oc.lengthSquared - (_radius ^^ 2);

        auto discriminantOverFour = (halfB ^^ 2) - a * c;
        if (discriminantOverFour < 0) {
            return false;
        }
        import std.math : sqrt;

        auto sqrtDiscriminantOverFour = sqrt(discriminantOverFour);

        // Find nearest root that lies in acceptable range.
        auto root = (-halfB - sqrtDiscriminantOverFour) / a;
        if (root < tMin || root > tMax) {
            root = (-halfB + sqrtDiscriminantOverFour) / a;
            if (root < tMin || root > tMax) {
                return false;
            }
        }

        hitRecord.t = root;
        hitRecord.point = ray.at(hitRecord.t);
        Vec3 outwardNormal = (hitRecord.point - _center).dup.to!Vec3 / _radius;
        hitRecord.setFaceNormal(ray, outwardNormal);
        hitRecord.material = _material.dup;

        return true;
    }

private:
    Point3 _center;
    double _radius;
    Material _material;
}
