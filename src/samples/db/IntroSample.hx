package samples.db;

import com.cf.devkit.bundle.IDragonBonesClip;
import motion.Actuate;
import motion.actuators.IGenericActuator;

class IntroSample extends AbstractSample
{
    private var clip:IDragonBonesClip;

    private var timer:IGenericActuator;

    override private function init():Void
    {
        super.init();

        pauseAndPlay();
    }

    private function pauseAndPlay():Void
    {
        if (clip != null)
        {
            container.removeChild(clip.assets);
            clip.dispose();
            clip = null;
        }

        timer = Actuate.timer(0.5).onComplete(play);
    }

    private function play():Void
    {
        clip = factory.getInstance(IDragonBonesClip);
        clip.setAssetId(assetPathList[0]);
        clip.play(false, null, pauseAndPlay);

        clip.x = getWidth() / 2;
        clip.y = getWidth() / 2;

        container.addChild(clip.assets);
    }

    override public function dispose():Void
    {
        Actuate.stop(timer, null, false, false);
        if (clip != null)
        {
            clip.dispose();
        }

        super.dispose();
    }

    override public function getWidth():Float
    {
        return 400;
    }

    override public function getHeight():Float
    {
        return getWidth();
    }
}
