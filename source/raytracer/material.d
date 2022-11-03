module raytracer.material;

import raytracer;

interface Material {
    bool scatter(const Ray rayIn, const HitRecord hitRecord, ref Colour attenuation,
            ref Ray scattered);

    Material dup() const;
}

/// Simple lambertian material
class Lambertian : Material {
    this(Colour albedo) {
        _albedo = albedo;
    }

    override bool scatter(const Ray rayIn, const HitRecord hitRecord,
            ref Colour attenuation, ref Ray scattered) {
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
        return new Lambertian(cast(Colour) this._albedo);
    }

private:
    Colour _albedo;
}

/// Simple metal material
class Metal : Material {
    this(Colour albedo, double fuzziness = 0.0) {
        _albedo = albedo;
        _fuzziness = fuzziness; // < 1 ? fuzziness : 1.0;
    }

    override bool scatter(const Ray rayIn, const HitRecord hitRecord,
            ref Colour attenuation, ref Ray scattered) {
        Vec3 reflected = rayIn.direction.unitVector.reflect(hitRecord.normal.dup);
        scattered = new Ray(hitRecord.point, reflected + _fuzziness * random_in_unit_sphere());
        attenuation = _albedo;
        return scattered.direction.dot(hitRecord.normal) > 0;
    }

    /// Duplicate copy of class instance with same properties
    Metal dup() const {
        return new Metal(cast(Colour) this._albedo, this._fuzziness);
    }

private:
    Colour _albedo;
    double _fuzziness;
}

class Dielectric : Material {
    this(double refractiveIndex) {
        _refractiveIndex = refractiveIndex;
    }

    override bool scatter(const Ray rayIn, const HitRecord hitRecord,
            ref Colour attenuation, ref Ray scattered) {
        import std.math : fmin, sqrt;
        import std.random : uniform01;

        attenuation = Colour.white;
        double refractionRatio = hitRecord.isFrontFace ? (1.0 / _refractiveIndex) : _refractiveIndex;

        Vec3 unitDirection = rayIn.direction.unitVector;
        double cosTheta = (-unitDirection).dot(hitRecord.normal).fmin(1.0);
        double sinTheta = sqrt(1.0 - cosTheta ^^ 2);

        bool canRefract = refractionRatio * sinTheta <= 1.0;
        Vec3 direction;
        if (canRefract && reflectance(cosTheta, refractionRatio) <= uniform01())
            direction = refract(unitDirection, hitRecord.normal.dup, refractionRatio);
        else
            direction = reflect(unitDirection, hitRecord.normal.dup);

        scattered = new Ray(hitRecord.point, direction);
        return true;
    }

    /// Duplicate copy of class instance with same properties
    Dielectric dup() const {
        return new Dielectric(_refractiveIndex);
    }

private:
    double _refractiveIndex;

    static double reflectance(double cosTheta, double refractionRatio) {
        import std.math : pow;

        // Use Schlick's approximation for reflectance
        auto r0 = (1.0 - refractionRatio) / (1.0 + refractionRatio);
        r0 = r0 ^^ 2;
        return r0 + (1.0 - r0) * pow((1.0 - cosTheta), 5);
    }
}
