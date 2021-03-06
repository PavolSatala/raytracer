include "app://vector.ms";
include "app://camera.ms";
include "app://object.ms";
include "app://sphere.ms";
include "app://plane.ms";
include "app://color.ms";
include "app://surfaces.ms";


var args = parseData(INPUT);

function defaultScene() {
    return {
        things: [new Plane(new Vector(0.0, 1.0, 0.0), 0.0, Surfaces.checkerboard),
                 new Sphere(new Vector(0.0, 1.0, -0.25), 1.0, Surfaces.shiny),
                 new Sphere(new Vector(-1.0, 0.5, 1.5), 0.5, Surfaces.shiny)],
        lights: [{ pos: new Vector(-2.0, 2.5, 0.0), color: new Color(0.49, 0.07, 0.07) },
                 { pos: new Vector(1.5, 2.5, 1.5), color: new Color(0.07, 0.07, 0.49) },
                 { pos: new Vector(1.5, 2.5, -1.5), color: new Color(0.07, 0.49, 0.071) },
                 { pos: new Vector(0.0, 3.5, 0.0), color: new Color(0.21, 0.21, 0.35) }],
        camera: new Camera(new Vector(3.0, 2.0, 4.0), new Vector(-1.0, 0.5, 0.0))
    };
}

var getPoint = :x, y, camera {
    var recenterX = :x { return (x - (args.width / 2.0)) / 2.0 / args.width };
    var recenterY = :y { return - (y - (args.height / 2.0)) / 2.0 / args.height };
    return Vector.norm(Vector.plus(camera.forward, Vector.plus(Vector.times(recenterX(x), camera.right), Vector.times(recenterY(y), camera.up))));
}

var scene = defaultScene();
var r;
var depth = 0;
var ray = {start: scene.camera.pos, dir: getPoint(args.x, args.y, scene.camera)};

const maxDepth = 5;

function traceRay(ray, scene, depth)
{
    var isect = this.intersections(ray, scene);
    return !isect ? Color.background : this.shade(isect, scene, depth);
}

function testRay(ray, scene)
{
    var isect =  intersections(ray, scene);
    return isect ? isect.dist : undefined;
}

function intersections(ray, scene)
{
    var closest = Float.MAX;
    var closestInter = undefined;
    for (var thing in scene.things) {
        ray;
        var inter = thing.intersect(ray);

        if (inter != null && inter.dist < closest) {
            closestInter = inter;
            closest = inter.dist;
        }
    }
    return closestInter;
}



function shade(isect, scene, depth)
{
    var d = isect.ray.dir;
    var pos = Vector.plus(Vector.times(isect.dist, d), isect.ray.start);
    var normal = isect.thing.normal(pos);
    var reflectDir = Vector.minus(d, Vector.times(2, Vector.times(Vector.dot(normal, d), normal)));
    var naturalColor = Color.plus(Color.background,
                                   getNaturalColor(isect.thing, pos, normal, reflectDir, scene));
    var reflectedColor = (depth >=  maxDepth) ? Color.grey :  getReflectionColor(isect.thing, pos, normal, reflectDir, scene, depth);
    return Color.plus(naturalColor, reflectedColor);
}

function getReflectionColor(thing, pos, normal, rd, scene, depth)
{
    return Color.scale(thing.surface.reflect(pos),  traceRay({ start: pos, dir: rd }, scene, depth + 1));
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

var isect =  intersections(ray, scene);
var ret = !isect ? Color.background :  shade(isect, scene, depth)
return {color : ret, x : args.x, y : args.y};