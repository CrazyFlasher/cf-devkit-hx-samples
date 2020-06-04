package samples.particles;

import haxe.Timer;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.config.IConfig;
import com.cf.devkit.bundle.IDisplayObject;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.devkit.bundle.IParticleClip;
import com.cf.devkit.bundle.ParticleClipMessageType;
import motion.Actuate;
import motion.easing.Linear;

class MovieClipParticleSample extends AbstractSample
{
    @Inject
    private var config:IConfig;

    private var clip:IParticleClip;

    private var timer:Timer;

    override public function getWidth():Float
    {
        return 2000;
    }

    override public function getHeight():Float
    {
        return getWidth();
    }

    override public function dispose():Void
    {
        clip.dispose();
        timer.stop();

        super.dispose();
    }

    override private function init():Void
    {
        super.init();

        clip = factory.getInstance(IParticleClip);
        clip.setDisplayObject("assets/particles/coin", "coins", config.swfAssetLibList[0]);
        clip.addMessageListener(ParticleClipMessageType.ParticleInit, particleInitialized);

        container.addChild(clip.assets);

        start();
    }

    private function start():Void
    {
        timer = Timer.delay(stop, 3000);

        clip.emit(getWidth() / 2, getHeight() / 2);
    }

    private function stop():Void
    {
        timer = Timer.delay(start, 1000);

        clip.stop(clip.lifeSpan);
    }

    private function particleInitialized(m:IMessage):Void
    {
        var particle:IDisplayObject = cast m.data;

        particle.alpha = 0.0;
        var mc:IMovieClip = cast particle;
        mc.frameRate = 10 + Math.floor(Math.random() * 20);
        mc.play();

        Actuate.timer(clip.lifeSpan / 4).onComplete(() -> fadeIn(particle));
    }

    private function fadeIn(particle:IDisplayObject):Void
    {
        Actuate.tween(particle, 0.2, {alpha: 1}).ease(Linear.easeNone);
    }
}
