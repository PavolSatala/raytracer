include "app://vector.ms";

class Camera {

    function this(pos, lookAt)
    {
        var down = new Vector(0.0, -1.0, 0.0);
        this.pos = pos;
        this.forward = Vector.norm(Vector.minus(lookAt, this.pos));
        this.right = Vector.times(1.5, Vector.norm(Vector.cross(this.forward, down)));
        this.up = Vector.times(1.5, Vector.norm(Vector.cross(this.forward, this.right)));
    }

}
