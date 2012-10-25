include "app://object.ms"

class Sphere : Thing {

    function this(center, radius, surface)
    {
        this.center = center;
        this.radius2 = radius * radius;
        this.surface = surface;
    }

    function normal(pos)
    {
        return Vector.norm(Vector.minus(pos, this.center));
    }

    function intersect(ray)
    {
        var eo = Vector.minus(this.center, ray.start);
        var v = Vector.dot(eo, ray.dir);
        var dist = 0;
        if (v >= 0) {
            var disc = this.radius2 - (Vector.dot(eo, eo) - v * v);
            if (disc >= 0)
                dist = v - Math.sqrt(disc);
        }
        return dist === 0 ? null : { thing: this, ray: ray, dist: dist };
    }

}
