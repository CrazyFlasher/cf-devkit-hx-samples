package samples.spriteSheet;

import openfl.Lib;
import openfl.events.Event;
import spritesheet.AnimatedSprite;
import spritesheet.Spritesheet;

class AnimatedSpriteSheetOpenFL extends AbstractSample
{
    private var mcList:Array<AnimatedSprite> = [];

    private var lastTime:Int = 0;

    @PostConstruct
    override private function init():Void
    {
        super.init();

        var x:Float = 0;

        for (path in assetPathList)
        {
            var sheet:Spritesheet = res.getSpriteSheet(path, "jpg");
            var mc:AnimatedSprite = new AnimatedSprite(sheet, true);
            sheet.behaviors.get("default").loop = true;
            mc.showBehavior("default");

            container.addChild(mc);
            mcList.push(mc);

            mc.x = x;

            x += mc.width;
        }

        container.addEventListener(Event.ENTER_FRAME, enterFrame);
    }

    private function enterFrame(e:Event):Void
    {
        var time:Int = Lib.getTimer();
        var delta:Int = time - lastTime;

        for (mc in mcList)
        {
            mc.update(delta);
        }

        lastTime = time;
    }

    override public function dispose():Void
    {
        container.removeEventListener(Event.ENTER_FRAME, enterFrame);

        for (mc in mcList)
        {
            mc.parent.removeChild(mc);
        }

        super.dispose();
    }
}
