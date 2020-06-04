package samples.particles;

import com.cf.devkit.config.IConfig;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.bundle.DisplayObjectMessageType;
import com.cf.devkit.bundle.IParticleClip;
import com.cf.devkit.bundle.IStage;
import motion.Actuate;
import motion.actuators.IGenericActuator;
import motion.easing.Linear;
import motion.MotionPath;
import openfl.geom.Point;

class JellyFishParticleSample extends AbstractSample
{
    @Inject
    private var config:IConfig;

    private var tween:IGenericActuator;

    private var stage:IStage;

    private var view:IParticleClip;

    private var pointHelper_1:Point = new Point();
    private var pointHelper_2:Point = new Point();

    override private function init():Void
    {
        super.init();

        var cX:Float = 10;
        var cY:Float = 0;
        var s:Float = 1;

        /*var path:MotionPath = new MotionPath();
        path.bezier(getWidth(), getHeight() * 0.25, cX, cY, s);
        path.bezier(0, getHeight() * 0.5, cX, cY, s);
        path.bezier(getWidth(), getHeight() * 0.75, cX, cY, s);
        path.bezier(0, getHeight(), cX, cY, s);
        path.bezier(getWidth(), getHeight() * 0.75, cX, cY, s);
        path.bezier(0, getHeight() * 0.5, cX, cY, s);
        path.bezier(getWidth(), getHeight() * 0.25, cX, cY, s);
        path.bezier(0, 0, cX, cY, s);*/

        view = factory.getInstance(IParticleClip);
        view.setAssetId(assetPathList[0], config.basePath + "jelly_particle.png");
        container.addChild(view.assets);

        view.emit(view.x, view.y);

        stage = factory.getInstance(IStage);

        stage.addMessageListener(DisplayObjectMessageType.TouchMove, mouseMove);
    }

    private function mouseMove(m:IMessage):Void
    {
        pointHelper_1.x = m.data.x;
        pointHelper_1.y = m.data.y;

        view.globalToLocal(pointHelper_1, pointHelper_2);

        view.emitterX = pointHelper_2.x;
        view.emitterY = pointHelper_2.y;
    }

    override public function dispose():Void
    {
        stage.removeMessageListener(DisplayObjectMessageType.TouchMove, mouseMove);

        view.dispose();

        if (tween != null)
        {
            Actuate.stop(tween);
            tween = null;
        }

        super.dispose();
    }

    /*private function animate(view:IParticleClip, path:MotionPath):Void
    {
        tween = Actuate.motionPath(view, 10.0, {emitterX: path.x, emitterY: path.y})
            .onComplete(() -> animate(view, path))
            .ease(Linear.easeNone);
    }*/

    override public function getWidth():Float
    {
        return 200;
    }

    override public function getHeight():Float
    {
        return 200;
    }
}
