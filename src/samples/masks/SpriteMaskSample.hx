package samples.masks;

#if useStarling
import starling.display.DisplayObject;
import starling.geom.Polygon;
import starling.display.Canvas;
#else
import openfl.display.DisplayObject;
import openfl.display.Sprite;
#end

import motion.actuators.IGenericActuator;
import motion.easing.Linear;
import motion.Actuate;
import com.domwires.core.mvc.message.IMessage;
import openfl.geom.Point;
import com.cf.devkit.bundle.DisplayObjectMessageType;
import com.cf.devkit.bundle.IStage;

class SpriteMaskSample extends AbstractMaskSample
{
    private var pointHelper_1:Point = new Point();
    private var pointHelper_2:Point = new Point();

    private var stage:IStage;

    private var tween:IGenericActuator;

    override private function init():Void
    {
        super.init();

        bg.mask = getMask();

        stage = factory.getInstance(IStage);

        stage.addMessageListener(DisplayObjectMessageType.TouchMove, mouseMove);

        rotate();
    }

    private function rotate():Void
    {
        bg.mask.rotation = 0;

        #if useStarling
        tween = Actuate.tween(bg.mask, 0.5, {rotation: Math.PI * 2}).ease(Linear.easeNone)
            .onComplete(rotate);
        #else
        tween = Actuate.tween(bg.mask, 0.5, {rotation: 359}).ease(Linear.easeNone)
            .onComplete(rotate)
            .onUpdate(() -> bg.assets.invalidate());
        #end
    }

    override public function dispose():Void
    {
        stage.removeMessageListener(DisplayObjectMessageType.TouchMove, mouseMove);

        if (tween != null)
        {
            Actuate.stop(tween, null, false, false);
        }

        super.dispose();
    }

    private function mouseMove(m:IMessage):Void
    {
        pointHelper_1.x = m.data.x;
        pointHelper_1.y = m.data.y;

        bg.globalToLocal(pointHelper_1, pointHelper_2);

        bg.mask.x = pointHelper_2.x;
        bg.mask.y = pointHelper_2.y;
    }

    private function getMask():DisplayObject
    {
        #if !useStarling
        var s:Sprite = new Sprite();
        s.graphics.beginFill(0xff0000);
        s.graphics.moveTo(0, -250);
        s.graphics.lineTo(250, 250);
        s.graphics.lineTo(-250, 250);
        s.graphics.lineTo(0, -250);
        s.graphics.endFill();
        return s;

        #else

        var s:Canvas = new Canvas();
        s.beginFill(0xff0000);
        s.drawPolygon(new Polygon(
            [
                new Point(0, -250),
                new Point(250, 250),
                new Point(-250, 250),
                new Point(0, -250)
            ]
        ));
        s.endFill();
        return s;

        #end
    }
}
