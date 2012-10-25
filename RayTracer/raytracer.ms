include "app://vector.ms";
include "app://camera.ms";
include "app://object.ms";
include "app://sphere.ms";
include "app://plane.ms";
include "app://surfaces.ms";

// original: http://typescript.codeplex.com/SourceControl/changeset/view/fe3bc0bfce1f#samples%2fraytracer%2fraytracer.ts

class RayTracer
{
    const maxDepth = 5;

    function intersections(ray, scene)
    {
        var closest = Float.MAX;
        var closestInter = undefined;
        for (var thing in scene.things) {
            var inter = thing.intersect(ray);
            if (inter != null && inter.dist < closest) {
                closestInter = inter;
                closest = inter.dist;
            }
        }
        return closestInter;
    }

    function testRay(ray, scene)
    {
        var isect = this.intersections(ray, scene);
        return isect ? isect.dist : undefined;
    }

    function traceRay(ray, scene, depth)
    {
        var isect = this.intersections(ray, scene);
        return !isect ? Color.background : this.shade(isect, scene, depth);
    }

    function shade(isect, scene, depth)
    {
        var d = isect.ray.dir;
        var pos = Vector.plus(Vector.times(isect.dist, d), isect.ray.start);
        var normal = isect.thing.normal(pos);
        var reflectDir = Vector.minus(d, Vector.times(2, Vector.times(Vector.dot(normal, d), normal)));
        var naturalColor = Color.plus(Color.background,
                                      this.getNaturalColor(isect.thing, pos, normal, reflectDir, scene));
        var reflectedColor = (depth >= this.maxDepth) ? Color.grey : this.getReflectionColor(isect.thing, pos, normal, reflectDir, scene, depth);
        return Color.plus(naturalColor, reflectedColor);
    }

    function getReflectionColor(thing, pos, normal, rd, scene, depth)
    {
        return Color.scale(thing.surface.reflect(pos), this.traceRay({ start: pos, dir: rd }, scene, depth + 1));
    }

    function getNaturalColor(thing, pos, norm, rd, scene)
    {
        var addLight = :col, light {
            var ldis = Vector.minus(light.pos, pos);
            var livec = Vector.norm(ldis);
            var neatIsect = this super.testRay({ start: pos, dir: livec }, scene);
            var isInShadow = !neatIsect ? false : (neatIsect <= Vector.mag(ldis));
            if (isInShadow) {
                return col;
            } else {
                var illum = Vector.dot(livec, norm);
                var lcolor = (illum > 0) ? Color.scale(illum, light.color) : Color.defaultColor;
                var specular = Vector.dot(livec, Vector.norm(rd));
                var scolor = (specular > 0) ? Color.scale(Math.pow(specular, thing.surface.roughness), light.color) : Color.defaultColor;
                return Color.plus(col, Color.plus(Color.times(thing.surface.diffuse(pos), lcolor),
                                                  Color.times(thing.surface.specular(pos), scolor)));
            }
        }
        return scene.lights.reduce(addLight, Color.defaultColor);
    }

    function render(scene, bmp)
    {
        var width = bmp.width;
        var height = bmp.height;
        var canvas = Canvas.fromBitmap(bmp);
        var getPoint = :x, y, camera {
            var recenterX = :x { return (x - (width / 2.0)) / 2.0 / width };
            var recenterY = :y { return - (y - (height / 2.0)) / 2.0 / height };
            return Vector.norm(Vector.plus(camera.forward, Vector.plus(Vector.times(recenterX(x), camera.right), Vector.times(recenterY(y), camera.up))));
        }
        for (var y = 0; y < height; y++) {
            console << y << "/" << height << "\n";
            for (var x = 0; x < width; x++) {
                var color = this.traceRay({ start: scene.camera.pos, dir: getPoint(x, y, scene.camera) }, scene, 0);
                var c = Color.toDrawingColor(color);
                var paint = new Paint();
                paint.color = 0xff000000 | (c.r << 16) | (c.g << 8) | c.b;
                canvas.drawRect(x, y, x + 1, y + 1, paint);
            }
        }
    }
}

