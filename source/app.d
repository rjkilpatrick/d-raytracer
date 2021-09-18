import std.stdio : writeln, stderr;
import std.conv : to;
import std.range : retro;

void main() {

    // Image Dimensions

    const int imageWidth = 256;
    const int imageHeight = 256;

    // Render

    writeln("P3\n", imageWidth, " ", imageHeight, "\n255");

    foreach_reverse (j; 0 .. imageHeight) {
        stderr.writeln("Scanlines remaining: ", j);
        foreach (i; 0 .. imageWidth) {
            auto r = double(i) / (imageWidth - 1);
            auto g = double(j) / (imageHeight - 1);
            auto b = 0.25;

            int ir = (255.999 * r).to!int;
            int ig = (255.999 * g).to!int;
            int ib = (255.999 * b).to!int;

            writeln(ir, " ", ig, " ", ib);
        }
    }

    stderr.writeln("\nDone");

}
