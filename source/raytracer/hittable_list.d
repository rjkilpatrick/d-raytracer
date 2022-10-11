module raytracer.hittable_list;

import raytracer.hittable;
import raytracer.ray;

import std.variant : Variant;

///
class HittableList : Hittable {
    ///
    this() {}

    ///
    void clear() {
        hittables = [];
    }

    ///
    void add(Hittable hittable) {
        hittables ~= hittable;
    }

    alias opOpAssign(string op : "~") = add;

    override bool hit(const Ray ray, double tMin, double tMax, ref HitRecord hitRecord) const {
        HitRecord tempHitRecord;
        bool hitAnything = false;
        auto closestSoFar = tMax;

        foreach (hittable; hittables) {
            if (hittable.hit(ray, tMin, closestSoFar, tempHitRecord)) {
                hitAnything = true;
                closestSoFar = tempHitRecord.t;
                hitRecord = tempHitRecord;
            }
        }

        return hitAnything;
    }

    private Hittable[] hittables = [];
}
