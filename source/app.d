import std.stdio : writeln, stderr;
import std.conv : to;
import std.range : retro;

import raytracer;

/// Determines the ray color by its intersections with the scene
Color rayColor(Ray ray, HittableList world) {
    HitRecord hitRecord;
    if (world.hit(ray, 0, double.infinity, hitRecord)) {
        return 0.5 * (1.0 + new Color(hitRecord.normal.x, hitRecord.normal.y, hitRecord.normal.z));
    }
    Vec3 unitDirection = ray.direction.unitVector;
    auto t = 0.5 * (unitDirection.y + 1.0);
    return (1.0 - t) * new Color(1.) + t * new Color(0.5, 0.7, 1.0);
}

void main() {

    // Image Dimensions
    const auto aspectRatio = 16. / 9.;
    const int imageWidth = 400;
    const int imageHeight = to!int(imageWidth / aspectRatio);

    // World
    HittableList world = new HittableList();
    world ~= new Sphere(new Point3(0., 0., -1.), 0.5);
    world ~= new Sphere(new Point3(0., -100.5, -1.), 100.);

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
            Color pixelColor = rayColor(ray, world);
            writeln(pixelColor);
        }
    }

    stderr.writeln("\nDone.");

}
