import std.stdio : writeln, stderr;
import std.conv : to;
import std.range : retro;

import raytracer.color;

void main() {

    // Image Dimensions

    const int imageWidth = 256;
    const int imageHeight = 256;

    // Render

    writeln("P3\n", imageWidth, " ", imageHeight, "\n255");

    foreach_reverse (j; 0 .. imageHeight) {
        stderr.writeln("Scanlines remaining: ", j);
        foreach (i; 0 .. imageWidth) {
            Color pixel_color = new Color(double(i) / (imageWidth - 1), double(j) / (imageHeight - 1), 0.25);
            writeln(pixel_color);
        }
    }

    stderr.writeln("\nDone");

}
