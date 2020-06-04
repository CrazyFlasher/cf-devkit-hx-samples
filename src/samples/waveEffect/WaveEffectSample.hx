package samples.waveEffect;

import starling.core.Starling;
import openfl.geom.Point;
import starling.extensions.wave.WaveSource;
import starling.extensions.wave.WaveFilter;
import com.cf.devkit.bundle.IImage;

class WaveEffectSample extends AbstractSample
{
	private var image:IImage;
	private var waveFilter:WaveFilter;

	override public function dispose():Void
	{
		image.dispose();
		waveFilter.dispose();

		Starling.current.juggler.remove(waveFilter);

		super.dispose();
	}

	override private function init():Void
	{
		super.init();

		var linearSource:WaveSource = new WaveSource(WaveSource.LINEAR, .01, .5, 50, 30);
		var radialSource:WaveSource = new WaveSource(WaveSource.RADIAL, .02, 5, 60, 5, new Point(.3, .3), 1);

		waveFilter = new WaveFilter();
		waveFilter.addWaveSource(linearSource);
		waveFilter.addWaveSource(radialSource);

		//creating an Image and applying the filter
		image = factory.getInstance(IImage);
		image.setAssetId("assets/misc/ocean.jpg");
		image.assets.filter = waveFilter;

		container.addChild(image.assets);

		Starling.current.juggler.add(waveFilter);
	}
}
