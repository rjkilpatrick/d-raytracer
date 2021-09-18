# Ray Tracing in One Weekend

This project borrows from the excellent [Ray Tracing in One weekend book series](https://raytracing.github.io/).

The eventual aim is that the books themselves are ported to tutorials in D.

## Output an image

We output our image to stdout as a [PPM image](https://en.wikipedia.org/wiki/Netpbm#PPM_example) to avoid any file manipulations or useage of an external library.

```sh
dub run -q > ./image.ppm
```

Then open your ppm image in your favourite image viewer.
