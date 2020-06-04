package samples.draw;

import openfl.geom.Point;
import starling.display.Sprite;
import starling.display.DisplayObjectContainer;
import com.cf.devkit.bundle.IContainer;

class Draw extends AbstractSample
{
	private var subContainer:IContainer;

	override public function dispose():Void
	{
		subContainer.dispose();

		super.dispose();
	}

	override private function init():Void
	{
		super.init();

		factory.mapToValue(DisplayObjectContainer, new Sprite(), "canvas");
		subContainer = factory.getInstance(IContainer);
		container.addChild(subContainer.canvas);

		subContainer.beginFill(0xFF0000, 0.5);
		subContainer.drawCircle(75, 50, 25);
		subContainer.endFill();

		subContainer.beginFill(0x00CC00, 0.5);
		subContainer.drawRectangle(80, 50, 50, 50);
		subContainer.endFill();


		var pointList:Array<Point> = [
			new Point(0, 0),
			new Point(50, 25),
			new Point(60, 40),
			new Point(80, 75),
			new Point(60, 125),
			new Point(50, 100),
			new Point(40, 80),
			new Point(20, 75)
		];

		subContainer.beginFill(0xFFCC00, 0.75);
		subContainer.drawPolygon(pointList);
		subContainer.endFill();

		pointList.push(new Point(0, 0));

		subContainer.drawLines(pointList, 0x0066CC);
	}
}
