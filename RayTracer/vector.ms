class Vector
{
    function this(x, y, z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    function times(k, v)
    {
        return new Vector(k * v.x, k * v.y, k * v.z);
    }

    function minus(v1, v2)
    {
        return new Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
    }

    function plus(v1, v2)
    {
        return new Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
    }

    function dot(v1, v2)
    {
        return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
    }

    function mag(v)
    {
        return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    }

    function norm(v)
    {
        var mag = Vector.mag(v);
        var div = (mag === 0) ? Float.MAX : 1.0 / mag;
        return Vector.times(div, v);
    }

    function cross(v1, v2)
    {
        return new Vector(v1.y * v2.z - v1.z * v2.y,
                          v1.z * v2.x - v1.x * v2.z,
                          v1.x * v2.y - v1.y * v2.x);
    }
}
