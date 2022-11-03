import std.stdio : writeln, stderr;
import std.conv : to;
import std.range : retro;
import std.random : uniform01;

import raytracer;

/// Determines the ray colour by its intersections with the scene
Colour rayColour(Ray ray, HittableList world, int bouncesRemaining) {
    // If we've exceeded ray bounces, return our Ambient colour
    if (bouncesRemaining <= 0)
        return Colour.black;

    HitRecord hitRecord;
    if (world.hit(ray, 1.0e-3, double.infinity, hitRecord)) {
        Ray scattered;
        Colour attenuation;
        if (hitRecord.material.scatter(ray, hitRecord, attenuation, scattered))
            return attenuation * rayColour(scattered, world, bouncesRemaining - 1);
        return Colour.black;
    }

    Vec3 unitDirection = ray.direction.unitVector;
    auto t = 0.5 * (unitDirection.y + 1.0);
    return (1.0 - t) * new Colour(1.) + t * new Colour(0.5, 0.7, 1.0);
}

void main() {
    // Image Dimensions
    const auto aspectRatio = 16. / 9.;
    const int imageWidth = 400;
    const int imageHeight = to!int(imageWidth / aspectRatio);

    const samples_per_pixel = 100;
    const max_bounces = 50;

    // Materials
    auto materialGround = new Lambertian(new Colour(0.8, 0.8, 0.0));
    auto materialCentre = new Lambertian(new Colour(0.1, 0.2, 0.5));
    auto materialLeft = new Dielectric(1.5);
    auto materialRight = new Metal(new Colour(0.8, 0.6, 0.2), 1.0);

    // World
    HittableList world = new HittableList();
    world ~= new Sphere(new Point3(0.0, -100.5, -1.0), 100.0, materialGround);
    world ~= new Sphere(new Point3(0.0, 0.0, -1.0), 0.5, materialCentre);
    world ~= new Sphere(new Point3(1.0, 0.0, -1.0), 0.5, materialRight);

    // Sphere of negative radius inside is a trick for a hollow glass 'sphere'
    world ~= new Sphere(new Point3(-1.0, 0.0, -1.0), 0.5, materialLeft);
    world ~= new Sphere(new Point3(-1.0, 0.0, -1.0), -0.4, materialLeft);

    // Camera
    Camera camera = new Camera();

    // Render

    writeln("P3\n", imageWidth, " ", imageHeight, "\n255");

    foreach_reverse (j; 0 .. imageHeight) {
        stderr.writeln("Scanlines remaining: ", j);
        foreach (i; 0 .. imageWidth) {
            Colour pixelColour = new Colour(0.);
            foreach (s; 0 .. samples_per_pixel) {
                const auto u = (double(i) + uniform01()) / (imageWidth - 1);
                const auto v = (double(j) + uniform01()) / (imageHeight - 1);
                Ray ray = camera.getRay(u, v);
                pixelColour = pixelColour + rayColour(ray, world, max_bounces);
            }
            writeln(pixelColour / samples_per_pixel.to!float);
        }
    }

    stderr.writeln("\nDone.");

}
