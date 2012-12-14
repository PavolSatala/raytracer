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
    var finished = false;

    function render(scene, bmp)
    {
        var width = bmp.width;
        var height = bmp.height;

        this.traceThread(width, height, bmp);
    }

    function traceThread(width, height, bmp, x = 0, y = 0) {
        System.exec({
            command:"thread",
            file:"app://traceThread.ms",
            input:String.printf("%V", {x : x, y : y, width : width, height : height}),
            callback: function(output) {
                var canvas = Canvas.fromBitmap(bmp);
                var args = parseData(output);
                var color = args.color;
                var c = Color.toDrawingColor(color);
                var paint = new Paint();
                paint.color = 0xff000000 | (c.r << 16) | (c.g << 8) | c.b;
                canvas.drawRect(args.x, args.y, args.x + 1, args.y + 1, paint);
                args.y += 1;
                if (args.y > height) {
                    args.x += 1;
                    args.y = 0;
                    if (args.x > width) {
                        RayTracer.finished = true;
                        return;
                    }
                }
                traceThread(width, height, bmp, args.x, args.y );
            }
        })
    }
}

