package samples.fla;

#if useStarling
import com.cf.devkit.mediators.audio.AudioNode.AudioType;
import com.cf.devkit.mediators.audio.AudioVo;
import motion.actuators.IGenericActuator;
import motion.easing.Linear;
import starling.core.Starling;
import starling.extensions.GodRayPlane;
import starling.display.Sprite3D;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
#else
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
#end

import motion.easing.Quad;
import motion.easing.Back;
import motion.Actuate;
import com.cf.devkit.config.IConfig;
import com.cf.devkit.display.Stage;
import com.cf.devkit.bundle.IDisplayObject;
import com.cf.devkit.mediators.audio.IAudioMediator;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.bundle.DisplayObjectMessageType;
import com.cf.devkit.bundle.ISheetClip;
import com.cf.devkit.bundle.IMovieClip;

class SceneSample extends AbstractSample
{
    @Inject
    private var config:IConfig;

    @Inject("root")
    private var root:DisplayObjectContainer;

	@Inject
	private var audio:IAudioMediator;

    private var movieClip:IMovieClip;
    private var animationsContainer:IMovieClip;
    private var assets:IMovieClip;

    private var symbolsAlpha:Float;

	#if useStarling
	private var sprite3D:Sprite3D = new Sprite3D();
    private var rays:GodRayPlane;
    private var rotateTween:IGenericActuator;
	#end

    private var bg:IMovieClip;

    override private function init():Void
    {
        super.init();

        movieClip = res.getMovieClip("container", config.swfAssetLibList[0]);
        animationsContainer = movieClip.getMovieClip("animations_container");
        container.addChild(movieClip.canvas);

        assets = animationsContainer.getMovieClip("assets");

		addClickListener();
        playBonusAnimation();
        playTweenAnim();
        createBg();

        //Currently supported only for starling implementation
        #if useStarling
        updateLogoPivot();
        putToSprite3D();
        playWildAnimation();
        playGirlAnimation("symbol_8");
        playGirlAnimation("symbol_9");
        playDogAnimation_1();
        playDogAnimation_2();
        playDragonAnimation();
        playParticleAnimation();
        playParticleAnimation_2();
        playTigerAnimation();
        playDinoAnimation();
        updateTextFields();
        createGodRays();
        idleRotation();
        #end

        symbolsAlpha = 1.0;

        movieClip.play();

		audio.playAudio(new AudioVo("Music_MainGame_Loop", true, 1.0, AudioType.Music));

        Stage.addResizeListener(onStageResize);
        onStageResize();
    }

    #if useStarling
    private function idleRotation():Void
    {
        rotateYPositive();
    }

    private function rotateYPositive():Void
    {
        rotateY(Math.PI / 32, rotateYNegative);
    }

    private function rotateYNegative():Void
    {
        rotateY(-Math.PI / 32, rotateYPositive);
    }

    private function rotateY(angle:Float, onComplete:Void -> Void):Void
    {
        rotateTween = Actuate.tween(sprite3D, 1.0, {rotationY: angle})
            .ease(Quad.easeInOut)
            .onComplete(onComplete);
    }

    #end

    private function fadeInCoinParticle(particle:IDisplayObject):Void
    {
        Actuate.tween(particle, 0.5, {alpha: 1}).ease(Linear.easeNone);
    }

    private function createGodRays():Void
    {
        rays = new GodRayPlane(bg.getDisplayObject("image").width, bg.getDisplayObject("image").height);
        rays.speed = 0.2;
        rays.size = 0.1;
        rays.skew = 0;
        rays.shear = 0;
        rays.fade = 1;
        rays.size = 0.065;
        rays.shear = 0.5;
        rays.skew = -0.26;
        rays.contrast = 3.0;

        bg.canvas.addChild(rays);
        Starling.current.juggler.add(rays);
    }

    private function updateLogoPivot():Void
    {
        var logo:IDisplayObject = movieClip.getDisplayObject("logo");
        logo.assets.pivotX = logo.width / 2;
    }

    private function createBg():Void
    {
        bg = res.getMovieClip("bg", config.swfAssetLibList[1]);
        root.parent.addChildAt(bg.assets, 0);

        #if useStarling
        var filter:starling.filters.ColorMatrixFilter = new starling.filters.ColorMatrixFilter();
        filter.tint(0, 0.5);
        filter.cache();
        bg.getDisplayObject("image").assets.filter = filter;
        #end
    }

    private function onStageResize(e:Dynamic = null):Void
    {
        if (Stage.stageWidth > Stage.stageHeight)
        {
            bg.width = Stage.stageWidth;
            bg.scaleY = bg.scaleX;
        } else
        {
            bg.height = Stage.stageHeight;
            bg.scaleX = bg.scaleY;
        }

        bg.y = (Stage.stageHeight - bg.height) / 2;
    }

	private function putToSprite3D():Void
	{
		sprite3D.addChild(movieClip.canvas);
		container.addChild(sprite3D);

		sprite3D.pivotX = sprite3D.width / 2;
		sprite3D.pivotY = sprite3D.height / 2;
		sprite3D.x += sprite3D.pivotX;
		sprite3D.y += sprite3D.pivotY;
	}

	private function addClickListener():Void
	{
        movieClip.addMessageListener(DisplayObjectMessageType.TouchBegan, (m:IMessage) -> {
            #if useStarling
            Actuate.stop(rotateTween, null, false, false);
            Actuate.tween(sprite3D, 0.2, {scale: 0.5}).ease(Quad.easeIn);
            #end
            audio.play("Play");
        });

        movieClip.addMessageListener(DisplayObjectMessageType.TouchEnded, (m:IMessage) -> {
            #if useStarling
            Actuate.tween(sprite3D, 1, {scale: 1.0}).ease(Back.easeOut);
            #end
        });

		movieClip.addMessageListener(DisplayObjectMessageType.Click, (m:IMessage) -> {
			#if useStarling
			Actuate.tween(sprite3D, 2.0, {rotationY: Math.PI * 2}).ease(Back.easeOut)
                .onComplete(idleRotation);
			#end
            audio.play("Stop");
		});
	}

    private function updateTextFields():Void
    {
        animationsContainer.getTextField("tf_1").text = "TAP SYMBOLS";
        animationsContainer.getTextField("tf_2").text = "012345";
    }

    private function playTigerAnimation():Void
    {
        assets.getMovieClip("tiger").getSpineClip().play();
    }

    private function playDinoAnimation():Void
    {
        assets.getMovieClip("dino").getSpineClip().play();
    }

    private function playParticleAnimation():Void
    {
        assets.getMovieClip("emitter").getParticleClip().emit(0, 0);
    }

    private function playParticleAnimation_2():Void
    {
        animationsContainer.getMovieClip("emitter").getParticleClip().emit(0, 0);
    }

    private function playDragonAnimation():Void
    {
        animationsContainer.getMovieClip("dragon").getDragonBonesClip().play();
    }

    private function playDogAnimation_1():Void
    {
        assets.getMovieClip("dog_1").getSpineClip().play();
    }

    private function playDogAnimation_2():Void
    {
        assets.getMovieClip("dog_2").getSpineClip().play();
    }

    private function playTweenAnim():Void
    {
        assets.getMovieClip("tween_anim").play();
    }

    private function playBonusAnimation():Void
    {
        var bonus:IMovieClip = assets.getMovieClip("symbol_1");
        var anim:IMovieClip = bonus.getMovieClip("anim");

        bonus.getDisplayObject("idle").visible = false;
        anim.addFrameScript(bonus.totalFrames - 1, bonusComplete);

        #if useStarling
        anim.frameRate = 15;
        #end

        anim.play();
    }

    private function playWildAnimation():Void
    {
        for (i in 11...16)
        {
            var wild:IMovieClip = assets.getMovieClip("symbol_" + i);
            var anim:ISheetClip = wild.getMovieClip("anim").getSheetClip();

            wild.getDisplayObject("idle").visible = false;
            anim.play();

            #if useStarling
//            var filter:starling.filters.ColorMatrixFilter = new starling.filters.ColorMatrixFilter();
//            filter.adjustHue(-1 + Math.random() * 2);
//            wild.canvas.filter = filter;
            anim.frameRate = 15;
            #end

            anim.play();
        }
    }

    private function playGirlAnimation(id:String):Void
    {
        var girl:IMovieClip = assets.getMovieClip(id);
        var mask:DisplayObject = girl.getDisplayObject("_mask").assets;
        girl.mask = mask;

        girl.getDisplayObject("idle").visible = false;

        var frame_1:IMovieClip = girl.getMovieClip("frame_1");
        var frame_2:IMovieClip = girl.getMovieClip("frame_2");
        var frame_3:IMovieClip = girl.getMovieClip("frame_3");

        frame_2.visible = frame_3.visible = false;

        var anim:ISheetClip = girl.getMovieClip("anim").getSheetClip();

        #if useStarling
        anim.frameRate = 15;
        #end

        anim.play();

        anim.addFrameScript(anim.totalFrames - 1, () -> {
            if (frame_1.visible)
            {
                frame_1.visible = false;
                frame_2.visible = true;

                mask.height = frame_2.height;
            } else
            if (frame_2.visible)
            {
                frame_2.visible = false;
                frame_3.visible = true;

                mask.height = frame_3.height;
            } else
            {
                frame_3.visible = false;
                frame_1.visible = true;

                mask.height = frame_1.height;
            }
        });
    }

    private function bonusComplete():Void
    {
        if (symbolsAlpha > 0)
        {
            symbolsAlpha -= 0.1;
        } else
        {
            symbolsAlpha = 1.0;
        }

        for (i in 2...8)
        {
            assets.getMovieClip("symbol_" + i).getDisplayObject("idle").alpha = symbolsAlpha;
        }
    }

    override public function dispose():Void
    {
        Stage.removeResizeListener(onStageResize);

        #if useStarling
        rays.removeFromParent(true);
        Actuate.stop(rotateTween);
        #end

        bg.dispose();
        movieClip.dispose();
		audio.stopMusic();

        super.dispose();
    }

    override public function getWidth():Float
    {
        return container.width;
    }

    override public function getHeight():Float
    {
        return container.height;
    }
}
