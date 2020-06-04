package samples.db;

import com.cf.devkit.bundle.IDisplayObject;
import com.cf.devkit.bundle.IDragonBonesClip;

class BossDBSample extends AbstractSample
{
    @Inject("count")
    private var count:Int;

    private var animList:Array<String> = [];
    private var currentAnimIndex:Int = 0;

    private var x:Float = 600;
    private var y:Float = 1200;

    private var childrenList:Array<IDisplayObject> = [];

    override private function init():Void
    {
        super.init();

        for (i in 0...count)
        {
            var clip:IDragonBonesClip = factory.getInstance(IDragonBonesClip);
            clip.setAssetId(assetPathList[0]);

            add(clip);

            switchAnimation(clip);
        }
    }

    private function add(child:IDisplayObject):Void
    {
        child.x = x;
        child.y = y;

        if (child.assets != null)
        {
            container.addChild(child.assets);
        }

        x += 1200;

        childrenList.push(child);
    }

    override public function dispose():Void
    {
        if (childrenList != null)
        {
            for (child in childrenList)
            {
                child.dispose();
            }

            childrenList = null;
        }

        super.dispose();
    }

    private function switchAnimation(clip:IDragonBonesClip):Void
    {
        clip.play(true);
    }

    override public function getWidth():Float
    {
        return 1200 * count;
    }
}
