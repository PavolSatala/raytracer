include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://raytracer.ms"

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

class RayGame : Game
{

    function start()
    {
        super.start();
        this._raytrace();
    }

    function draw(canvas)
    {
        canvas.drawBitmap(this._bitmap, (System.width - this._bitmap.width) / 2, (System.height - this._bitmap.height) / 2);
        super.draw(canvas);
    }

    function _raytrace()
    {
        var size = Integer.min(System.width, System.height) / 5;
        this._bitmap = Bitmap.fromRect(size, size);
        var rayTracer = new RayTracer();
        return rayTracer.render(defaultScene(), this._bitmap); //System.width, System.height);
    }

}

new RayGame().run();
