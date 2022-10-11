module raytracer.hittable;

import raytracer.ray;
import raytracer.vec3;

///
struct HitRecord {
    Point3 point;
    Vec3 normal;
    double t;
    bool isFrontFace;

pragma(inline):
    void setFaceNormal(const Ray ray, const Vec3 outwardNormal) {
        isFrontFace = ray.direction.dot(outwardNormal) < 0;
        normal = isFrontFace ? outwardNormal.dup : -outwardNormal.dup;
    }
}

///
interface Hittable {
    bool hit(const Ray ray, double tMin, double tMax, ref HitRecord hitRecord) const;
}
