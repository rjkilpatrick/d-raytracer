import std.stdio : writeln, stderr;
import std.conv : to;
import std.range : retro;
import std.random : uniform01;

import raytracer;

/// Determines the ray color by its intersections with the scene
Color rayColor(Ray ray, HittableList world, int bouncesRemaining) {
    // If we've exceeded ray bounces, return our Ambient colour
    if (bouncesRemaining <= 0)
        return Color.black;

    HitRecord hitRecord;
    if (world.hit(ray, 1.0e-3, double.infinity, hitRecord)) {
        Point3 target = hitRecord.point + random_in_hemisphere(hitRecord.normal);
        return 0.5 * rayColor(new Ray(hitRecord.point, target - hitRecord.point), world, bouncesRemaining - 1);
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

    const samples_per_pixel = 100;
    const max_bounces = 50;

    // World
    HittableList world = new HittableList();
    world ~= new Sphere(new Point3(0., 0., -1.), 0.5);
    world ~= new Sphere(new Point3(0., -100.5, -1.), 100.);

    // Camera
    Camera camera = new Camera();

    // Render

    writeln("P3\n", imageWidth, " ", imageHeight, "\n255");

    foreach_reverse (j; 0 .. imageHeight) {
        stderr.writeln("Scanlines remaining: ", j);
        foreach (i; 0 .. imageWidth) {
            Color pixelColor = new Color(0.);
            foreach (s; 0 .. samples_per_pixel) {
                const auto u = (double(i) + uniform01()) / (imageWidth - 1);
                const auto v = (double(j) + uniform01()) / (imageHeight - 1);
                Ray ray = camera.getRay(u, v);
                pixelColor = pixelColor + rayColor(ray, world, max_bounces);
            }
            writeln(pixelColor / samples_per_pixel.to!float);
        }
    }

    stderr.writeln("\nDone.");

}
