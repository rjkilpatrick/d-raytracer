module raytracer.material;

import raytracer;

interface Material {
    bool scatter(const Ray ray_in, const HitRecord hitRecord, ref Color attenuation, ref Ray scattered);

    Material dup() const;
}

class Lambertian : Material {
    this(Color albedo) {
        _albedo = albedo;
    }

    override bool scatter(const Ray ray_in, const HitRecord hitRecord, ref Color attenuation, ref Ray scattered) {
        Vec3 scatterDirection = hitRecord.normal.dup + random_unit_vector();

        // Catch degenerate scatter direction
        if (scatterDirection.nearZero)
            scatterDirection = hitRecord.normal.dup;

        scattered = new Ray(hitRecord.point, scatterDirection);
        attenuation = _albedo;
        return true;
    }

    /// Duplicate copy of class instance with same properties
    Lambertian dup() const {
        return new Lambertian(cast(Color) this._albedo);
    }

private:
    Color _albedo;
}

class Metal : Material {
    this(Color albedo) {
        _albedo = albedo;
    }

    override bool scatter(const Ray ray_in, const HitRecord hitRecord, ref Color attenuation, ref Ray scattered) {
        Vec3 reflected = ray_in.direction.unitVector.reflect(hitRecord.normal.dup);
        scattered = new Ray(hitRecord.point, reflected);
        attenuation = _albedo;
        return scattered.direction.dot(hitRecord.normal) > 0;
    }

    /// Duplicate copy of class instance with same properties
    Metal dup() const {
        return new Metal(cast(Color) this._albedo);
    }

private:
    Color _albedo;
}
