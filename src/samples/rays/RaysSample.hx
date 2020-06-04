package samples.rays;

import starling.display.Quad;
import starling.utils.Align;
import starling.text.TextFormat;
import starling.text.TextField;
import starling.display.Image;
import starling.display.Sprite;
import starling.display.DisplayObjectContainer;
import openfl.geom.Point;
import starling.events.TouchPhase;
import starling.events.Touch;
import openfl.ui.Keyboard;
import starling.events.KeyboardEvent;
import starling.core.Starling;
import starling.events.TouchEvent;
import starling.extensions.GodRayPlane;

class RaysSample extends AbstractSample
{
	private var subContainer:DisplayObjectContainer;

	private var infoTf:TextField;
	private var statusTf:TextField;

	private var infoText:String = "";

	private var godRays:GodRayPlane;

	private var testProperty:String = "skew";

	override public function dispose():Void
	{
		container.removeChild(subContainer, true);

		super.dispose();
	}

	override private function init():Void
	{
		super.init();

		subContainer = new Sprite();
		container.addChild(subContainer);

		var background:Image = new Image(res.getTexture("assets/misc/forest.jpg"));
		subContainer.addChild(background);

		godRays = new GodRayPlane(background.width, background.height);
		godRays.speed = 0.1;
		godRays.size = 0.1;
		godRays.skew = 0;
		godRays.shear = 0;
		godRays.fade = 1;
		godRays.size = 0.065;
		godRays.shear = 0.5;
		godRays.skew = -0.26;
		godRays.contrast = 3.5;

		subContainer.addChild(godRays);

		subContainer.addEventListener(TouchEvent.TOUCH, onTouch);
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKey);

		Starling.current.juggler.add(godRays);

		createInfo();
	}

	private function createInfo():Void
	{
		var quad:Quad = new Quad(200, 130);
		quad.alpha = 0.5;
		subContainer.addChild(quad);

		infoText += "Press 'P' to change speed\n";
		infoText += "Press 'I' to change size\n";
		infoText += "Press 'K' to change skew\n";
		infoText += "Press 'H' to change shear\n";
		infoText += "Press 'F' to change fade\n";
		infoText += "Press 'C' to change contrast";

		var tf:TextFormat = new TextFormat();
		tf.size = 12;
		tf.color = 0;
		tf.horizontalAlign = Align.LEFT;
		tf.verticalAlign = Align.TOP;

		infoTf = new TextField(Math.ceil(quad.width), Math.ceil(quad.height), "", tf);
		infoTf.touchable = false;
		infoTf.wordWrap = true;

		subContainer.addChild(infoTf);

		updateInfo();
	}

	private function updateInfo():Void
	{
		var testValue:String = Reflect.getProperty(godRays, testProperty);

		#if (flash || html5)
		testValue = untyped testValue.toFixed(2);
		#end

		infoTf.text = "Now modifying: " + testProperty + " " + testValue + "\n\n" + infoText;
	}

	private function onKey(event:KeyboardEvent):Void
	{
		var keyCode:UInt = event.keyCode;

		trace(keyCode);

		switch keyCode
		{
			case Keyboard.P: testProperty = "speed";
			case Keyboard.I: testProperty = "size";
			case Keyboard.K: testProperty = "skew";
			case Keyboard.H: testProperty = "shear";
			case Keyboard.F: testProperty = "fade";
			case Keyboard.C: testProperty = "contrast";
		}

		updateInfo();
	}

	private function onTouch(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(subContainer, TouchPhase.MOVED);

		if (touch != null)
		{
			var movement:Point = touch.getMovement(subContainer);
			var delta:Float = movement.x / 200;

			Reflect.setProperty(godRays, testProperty, Reflect.getProperty(godRays, testProperty) + delta);

			godRays.advanceTime(0);

			updateInfo();
		}
	}
}
