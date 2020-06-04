package samples.videoTexture;

import com.cf.devkit.tween.TweenTransition;
import openfl.events.NetStatusEvent;
import com.cf.devkit.tween.ITween;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import starling.display.Image;
import starling.display.Sprite3D;
import starling.textures.Texture;

class VideoTextureSample extends AbstractSample
{
	private var sprite3D:Sprite3D;
	private var image:Image;
	private var texture:Texture;

	private var netSteam:NetStream;
	private var netConnection:NetConnection;

	private var tween:ITween;

	override public function dispose():Void
	{
		tween.dispose();

		netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

		if (netSteam != null)
		{
			netSteam.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netSteam.close();
		}

		if (image != null)
		{
			if (image.parent != null)
			{
				image.removeFromParent(true);
			} else
			{
				image.dispose();
			}
		}

		if (texture != null)
		{
			texture.dispose();
		}

		sprite3D.removeFromParent(true);

		super.dispose();
	}

	override private function init():Void
	{
		super.init();

		tween = factory.getInstance(ITween);

		sprite3D = new Sprite3D();
		container.addChild(sprite3D);

		netConnection = new NetConnection();
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		netConnection.connect(null);

		netSteam = new NetStream(netConnection);
		netSteam.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

		Texture.fromNetStream(netSteam, 1, (texture:Texture) ->
		{
			image = new Image(texture);

			sprite3D.addChild(image);

			sprite3D.alignPivot();
			sprite3D.x = sprite3D.width / 2;
			sprite3D.y = sprite3D.height / 2;

			rotate();
		});

		playVideo();
	}

	private function playVideo():Void
	{
		netSteam.play("assets/misc/video.mp4");
	}

	private function netStatusHandler(evt:NetStatusEvent):Void
	{
		trace("evt.info.code " + evt.info.code);

		if (evt.info.code == "NetStream.Play.Stop")
		{
			playVideo();
		}
	}

	private function rotate():Void
	{
		tween.setOnComplete(rotate);
		tween.tween(sprite3D, 10.0, {
			rotationX: Math.random() * 10,
			rotationY: Math.random() * 10,
			rotationZ: Math.random() * 10,
		}, TweenTransition.EASE_IN_OUT);
	}

	override public function getWidth():Float
	{
		return 320;
	}

	override public function getHeight():Float
	{
		return 240;
	}
}
