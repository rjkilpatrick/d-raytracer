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
        Ray scattered;
        Color attenuation;
        if (hitRecord.material.scatter(ray, hitRecord, attenuation, scattered))
            return attenuation * rayColor(scattered, world, bouncesRemaining - 1);
        return Color.black;
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

    // Materials
    auto materialGround = new Lambertian(new Color(0.8, 0.8, 0.0));
    auto materialCentre = new Lambertian(new Color(0.7, 0.3, 0.3));
    auto materialLeft = new Metal(new Color(0.8), 0.3);
    auto materialRight = new Metal(new Color(0.8, 0.6, 0.2), 1.0);

    // World
    HittableList world = new HittableList();
    world ~= new Sphere(new Point3(0.0, -100.5, -1.0), 100.0, materialGround);
    world ~= new Sphere(new Point3(0.0, 0.0, -1.0), 0.5, materialCentre);
    world ~= new Sphere(new Point3(-1.0, 0.0, -1.0), 0.5, materialLeft);
    world ~= new Sphere(new Point3(1.0, 0.0, -1.0), 0.5, materialRight);

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
