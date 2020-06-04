package samples.scale9slice;

import com.cf.devkit.tween.TweenTransition;
import com.cf.devkit.tween.ITween;
import openfl.geom.Rectangle;
import com.cf.devkit.bundle.IImage;

class Scale9SliceSample extends AbstractSample
{
	private var image_1:IImage;
	private var image_2:IImage;

	private var tween_1:ITween;
	private var tween_2:ITween;

	override private function init():Void
	{
		super.init();

		tween_1 = factory.getInstance(ITween);
		tween_2 = factory.getInstance(ITween);

		image_1 = factory.getInstance(IImage);
		image_1.scale9Grid = new Rectangle(74, 0, 2, 78);
		image_1.setAssetId("assets/misc/green-coin-btn-74-0-2x78.png");

		image_2 = factory.getInstance(IImage);
		image_2.scale9Grid = new Rectangle(64, 16, 2, 2);
		image_2.setAssetId("assets/misc/chat-cloud-64-16-2x2.png");

		container.addChild(image_1.assets);
		container.addChild(image_2.assets);

		image_2.y = image_1.y + image_1.height + 20;

		animate();
	}

	override public function dispose():Void
	{
		tween_1.dispose();
		tween_2.dispose();

		image_1.dispose();
		image_2.dispose();

		super.dispose();
	}

	override public function getWidth():Float
	{
		return image_1.width * 4;
	}

	override public function getHeight():Float
	{
		return image_1.height + image_2.y + image_2.height * 5;
	}

	private function animate():Void
	{
		scaleIn();
	}

	private function scaleIn():Void
	{
		tween_1.setOnComplete(scaleOut);

		tween_1.tween(image_1, 2.0, {scaleX: 4}, TweenTransition.EASE_OUT_BACK);
		tween_2.tween(image_2, 2.0, {scale: 5}, TweenTransition.EASE_OUT_BACK);
	}

	private function scaleOut():Void
	{
		tween_1.setOnComplete(scaleIn);

		tween_1.tween(image_1, 2.0, {scaleX: 1}, TweenTransition.EASE_OUT);
		tween_2.tween(image_2, 2.0, {scale: 1}, TweenTransition.EASE_OUT);
	}
}
