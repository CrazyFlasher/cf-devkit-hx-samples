package samples.spriteSheet;

import com.cf.devkit.bundle.ISheetClip;

class AnimatedSpriteSheetStarling extends AbstractSample
{
    private var mcList:Array<ISheetClip> = [];

    @PostConstruct
    override private function init():Void
    {
        super.init();

        var x:Float = 0;

        for (path in assetPathList)
        {
            var mc:ISheetClip = factory.getInstance(ISheetClip);
            mc.frameRate = 30;
            mc.setAssetId(path);

            container.addChild(mc.assets);

            mcList.push(mc);

            mc.x = x;

            x += mc.width;

            mc.play();
        }
    }

    override public function dispose():Void
    {
        for (mc in mcList)
        {
            mc.dispose();
        }

        super.dispose();
    }
}
