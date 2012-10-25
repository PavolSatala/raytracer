class Color
{

    function this(r, g, b)
    {
        this.r = r;
        this.g = g;
        this.b = b;
    }

    function scale(k, v)
    {
        return new Color(k * v.r, k * v.g, k * v.b);
    }

    function plus(v1, v2)
    {
        return new Color(v1.r + v2.r, v1.g + v2.g, v1.b + v2.b);
    }

    function times(v1, v2)
    {
        return new Color(v1.r * v2.r, v1.g * v2.g, v1.b * v2.b);
    }

    function toDrawingColor(c)
    {
        var legalize = :d { return d > 1 ? 1 : d };
        return {
            r: Math.floor(legalize(c.r) * 255),
            g: Math.floor(legalize(c.g) * 255),
            b: Math.floor(legalize(c.b) * 255)
        }
    }

}

Color.white = new Color(1.0, 1.0, 1.0);
Color.grey = new Color(0.5, 0.5, 0.5);
Color.black = new Color(0.0, 0.0, 0.0);
Color.background = new Color(0.0, 0.0, 0.0);
Color.defaultColor = new Color(0.0, 0.0, 0.0);
