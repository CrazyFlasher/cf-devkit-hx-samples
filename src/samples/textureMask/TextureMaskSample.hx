package samples.textureMask;

import com.cf.devkit.tween.TweenTransition;
import com.cf.devkit.bundle.IContainer;
import com.cf.devkit.bundle.IImage;
import com.cf.devkit.tween.ITween;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Sprite;
import starling.extensions.TextureMaskStyle;

class TextureMaskSample extends AbstractSample
{
	private var subContainer:IContainer;
	private var tween:ITween;

	private var maskStyle:TextureMaskStyle;

	override private function init():Void
	{
		super.init();

		factory.mapToValue(DisplayObjectContainer, new Sprite(), "canvas");
		subContainer = factory.getInstance(IContainer);
		container.addChild(subContainer.canvas);

		tween = factory.getInstance(ITween);

		var image:IImage = factory.getInstance(IImage);
		image.setAssetId("assets/misc/unit2.png");
		subContainer.addChild(image);

		var mask:IImage = factory.getInstance(IImage);
		mask.setAssetId("assets/misc/texturemask.png");
		subContainer.addChild(mask);

		maskStyle = new TextureMaskStyle(1.0);
		cast (mask.assets, Image).style = maskStyle;

		image.mask = mask.assets;

		fadeIn();
	}

	override public function dispose():Void
	{
		subContainer.dispose();
		tween.dispose();

		super.dispose();
	}

	private function fadeIn():Void
	{
		tween.setOnComplete(fadeOut);
		tween.tween(maskStyle, 3.0, {threshold: 0.01}, TweenTransition.EASE_IN_OUT);
	}

	private function fadeOut():Void
	{
		tween.setOnComplete(fadeIn);
		tween.tween(maskStyle, 3.0, {threshold: 1.0}, TweenTransition.EASE_IN_OUT);
	}
}
