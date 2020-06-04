package samples.masks;

import com.cf.devkit.bundle.IImage;

class AbstractMaskSample extends AbstractSample
{
    private var bg:IImage;
    private var grayBg:IImage;

    override private function init():Void
    {
        super.init();

        grayBg = factory.getInstance(IImage);
        bg = factory.getInstance(IImage);

        #if useStarling

        bg.setAssetId(assetPathList[0]);
        grayBg.setAssetId(assetPathList[0]);

        var grayscaleFilter:starling.filters.ColorMatrixFilter = new starling.filters.ColorMatrixFilter();
        grayscaleFilter.adjustSaturation(-1);
        grayscaleFilter.adjustBrightness(-0.2);
        grayBg.assets.filter = grayscaleFilter;

        #else

        bg.bitmapData = res.getBitmapData(assetPathList[0]);
        grayBg.bitmapData = res.getBitmapData(assetPathList[0]);

        var cmf:openfl.filters.ColorMatrixFilter = new openfl.filters.ColorMatrixFilter();

        var red:Float = 0.2225;
        var green:Float = 0.7169;
        var blue:Float = 0.0606;

        cmf.matrix = [
            red, green, blue, 0, 0,
            red, green, blue, 0, 0,
            red, green, blue, 0, 0,
            0, 0, 0, 1, 0
        ];

        grayBg.assets.filters = [cmf];

        #end

        container.addChild(grayBg.assets);
        container.addChild(bg.assets);
    }

    override public function dispose():Void
    {
        bg.dispose();
        grayBg.dispose();

        super.dispose();
    }
}
