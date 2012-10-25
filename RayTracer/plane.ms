include "app://object.ms"

class Plane : Thing
{
    function this(norm, offset, surface)
    {
        this.norm = norm;
        this.offset = offset;
        this.surface = surface;
    }

    function normal(pos)
    {
        return this.norm;
    }

    function intersect(ray)
    {
        var norm = this.norm;
        var denom = Vector.dot(norm, ray.dir);
        if (denom > 0) {
            return null;
        } else {
            var dist = (Vector.dot(norm, ray.start) + this.offset) / (-denom);
            return { thing: this, ray: ray, dist: dist };
        }
    }

}
