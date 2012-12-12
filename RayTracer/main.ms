include "lib://core/log.ms"
include "lib://game2d/game.ms"
include "app://raytracer.ms"


class RayGame : Game
{

    function start()
    {
        super.start();
        this._raytrace();
    }

    function draw(canvas)
    {
        canvas.clear(0xffffffff);
        canvas.drawBitmap(this._bitmap, (System.width - this._bitmap.width) / 2, (System.height - this._bitmap.height) / 2);
        super.draw(canvas);
    }

    function _raytrace()
    {
        var size = Integer.min(System.width, System.height) / 5;
        this._bitmap = Bitmap.fromRect(size, size);
        var rayTracer = new RayTracer();
        return rayTracer.render(0, this._bitmap); //System.width, System.height);
    }

    function process()
    {
        console<<System.tick<<"\n";
    }

}

new RayGame().run();
