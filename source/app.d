import std.stdio : writeln, stderr;
import std.conv : to;
import std.range : retro;

import raytracer.color;
import raytracer.ray;
import raytracer.vec3;

/// 
bool hitSphere(const Point3 center, double radius, const Ray ray) {
    Vec3 oc = (ray.origin - center).dup.to!Vec3;

    // Uses discriminant from quadratic equation solved
    const a = ray.direction.dot(ray.direction);
    const b = 2.0 * oc.dot(ray.direction);
    const c = oc.dot(oc) - radius ^^ 2;

    auto discriminant = b ^^ 2 - 4 * a * c;
    return (discriminant > 0);
}

/// Determines the ray color by its intersections with the scene
Color rayColor(Ray ray) {
    if (hitSphere(new Point3(0, 0, -1), 0.5, ray))
        return new Color(1, 0, 0);
    auto t = 0.5 * (ray.direction.unitVector.y + 1.0);
    return (1. - t) * new Color(1.0) + t * new Color(0.5, 0.7, 1.0);
}

void main() {

    // Image Dimensions
    const auto aspectRatio = 16. / 9.;
    const int imageWidth = 400;
    const int imageHeight = to!int(imageWidth / aspectRatio);

    // Camera

    const auto viewportHeight = 2.0;
    const auto viewportWidth = aspectRatio * viewportHeight;
    const auto focalLength = 1.0;

    const auto origin = new Point3(0., 0., 0.);
    const auto horizontal = new Vec3(viewportWidth, 0., 0.);
    const auto vertical = new Vec3(0, viewportHeight, 0.);
    const auto lowerLeftCorner = origin - (horizontal / 2) - (vertical / 2) - (new Vec3(0.,
            0., focalLength));

    // Render

    writeln("P3\n", imageWidth, " ", imageHeight, "\n255");

    foreach_reverse (j; 0 .. imageHeight) {
        stderr.writeln("Scanlines remaining: ", j);
        foreach (i; 0 .. imageWidth) {
            const auto u = double(i) / (imageWidth - 1);
            const auto v = double(j) / (imageHeight - 1);

            Ray ray = new Ray(origin, lowerLeftCorner + (u * horizontal) + (v * vertical) - origin);
            Color pixelColor = rayColor(ray);
            writeln(pixelColor);
        }
    }

    stderr.writeln("\nDone.");

}
