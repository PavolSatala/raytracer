include "app://vector.ms";
include "app://camera.ms";
include "app://object.ms";
include "app://sphere.ms";
include "app://plane.ms";
include "app://surfaces.ms";
include "app://color.ms";

// original: http://typescript.codeplex.com/SourceControl/changeset/view/fe3bc0bfce1f#samples%2fraytracer%2fraytracer.ts

class RayTracer
{
    const maxDepth = 5;

    /*function intersections(ray, scene)
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
    }*/

    /*function getReflectionColor(thing, pos, normal, rd, scene, depth)
    {
        return Color.scale(thing.surface.reflect(pos), this.traceRay({ start: pos, dir: rd }, scene, depth + 1));
    }
*/
   /* function getNaturalColor(thing, pos, norm, rd, scene)
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
    }*/

    function render(scene, bmp)
    {
        var width = bmp.width;
        var height = bmp.height;

       this.traceThread(width, height, bmp);/*{ start: scene.camera.pos, dir: getPoint(0, 0, scene.camera) }, scene, 0*///);
      /*  for (var y = 0; y < height; y++) {
            console << y << "/" << height << "\n";
            for (var x = 0; x < width; x++) {

            }
        }*/
    }

    function traceThread(width, height, bmp, x = 0, y = 0) {
        console<<"starting "<<x<<" "<<y<<"\n";

        System.exec({
            command:"thread",
            file:"app://traceThread.txt",
            input:String.printf("%V", {x : x, y : y, width : width, height : height}),
            callback: function(output) {
                console<<"output "<<output<<"\n";
                console<<"rendering "<<x<<" "<<y<<"\n";
                var canvas = Canvas.fromBitmap(bmp);
                var args = parseData(output);
                var color = args.color;
                console<<color<<"\n";
                var c = Color.toDrawingColor(color);
                var paint = new Paint();
                paint.color = 0xff000000 | (c.r << 16) | (c.g << 8) | c.b;
                canvas.drawRect(args.x, args.y, args.x + 1, args.y + 1, paint);
                args.y += 1;
                if (args.y > height) {
                    args.x += 1;
                    args.y = 0;
                    if (args.x > System.width)
                        return;
                }
                traceThread(width, height, bmp, args.x, args.y )

            }
        })
    }
}

