package samples.pixelMask;

import motion.Actuate;
import motion.actuators.IGenericActuator;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.bundle.DisplayObjectMessageType;
import com.cf.devkit.bundle.IContainer;
import com.cf.devkit.bundle.IImage;
import com.cf.devkit.bundle.IParticleClip;
import com.cf.devkit.bundle.ISheetClip;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

class PixelMaskSample extends AbstractSample
{
	private var subContainer:IContainer;
	private var background:IImage;

	private var timer:IGenericActuator;

	override public function dispose():Void
	{
		subContainer.dispose();
		Actuate.stop(timer, null, false, false);

		super.dispose();
	}

	override public function getWidth():Float
	{
		return background.width;
	}

	override public function getHeight():Float
	{
		return background.height;
	}

	override private function init():Void
	{
		super.init();

		factory.mapToValue(DisplayObjectContainer, new Sprite(), "canvas");
		subContainer = factory.getInstance(IContainer);
		container.addChild(subContainer.canvas);

		background = factory.getInstance(IImage);
		background.setAssetId("assets/misc/pixelmask_bg.png");

		var particleClip:IParticleClip = factory.getInstance(IParticleClip);
		particleClip.setAssetId("assets/particles/crazy");
		particleClip.x = getWidth() / 2;
		particleClip.y = getHeight();
		particleClip.scaleY *= -1;

		var mask:ISheetClip = factory.getInstance(ISheetClip);
		mask.setAssetId("assets/misc/pixelmask.png");
		mask.frameRate = 18;
		mask.x = (getWidth() - mask.width) / 2;
		mask.y = (getHeight() - mask.height) / 2;

		subContainer.addMessageListener(DisplayObjectMessageType.Click, handleClick);

		subContainer.addChild(background);
		subContainer.addChild(particleClip);

		subContainer.pixelMask = mask.assets;

		particleClip.emit();
		mask.play();

		startTimer();
	}

	private function startTimer():Void
	{
		timer = Actuate.timer(2.0).onComplete(changeMask);
	}

	private function handleClick(m:IMessage):Void
	{
		Actuate.stop(timer, null, false, false);

		changeMask();
	}

	private function changeMask():Void
	{
		startTimer();

		subContainer.pixelMaskInverted = !subContainer.pixelMaskInverted;
	}
}
