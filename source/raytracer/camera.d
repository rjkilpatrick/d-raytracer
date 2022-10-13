module raytracer.camera;

import raytracer.vec3;
import raytracer.ray;

class Camera {
public:
    this() {
        auto aspectRatio = 16. / 9.;
        const auto viewportHeight = 2.0;
        const auto viewportWidth = aspectRatio * viewportHeight;
        const auto focalLength = 1.0;

        origin = new Point3(0., 0., 0.);
        horizontal = new Vec3(viewportWidth, 0., 0.);
        vertical = new Vec3(0, viewportHeight, 0.);
        lowerLeftCorner = origin - (horizontal / 2) - (vertical / 2) - (new Vec3(0.,
                0., focalLength));
    }

    Ray getRay(double u, double v) const {
        return new Ray(origin, lowerLeftCorner + u * horizontal + v * vertical - origin);
    }

private:
    Point3 origin;
    Point3 lowerLeftCorner;
    Vec3 horizontal;
    Vec3 vertical;
}
