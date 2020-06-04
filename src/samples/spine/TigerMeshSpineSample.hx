package samples.spine;

import com.cf.devkit.bundle.IDisplayObject;
import com.cf.devkit.bundle.ISpineClip;

class TigerMeshSpineSample extends AbstractSample
{
    @Inject("count")
    private var count:Int;

    private var animList:Array<String> = [];
    private var currentAnimIndex:Int = 0;

    private var x:Float = 0;
    private var y:Float = 1300;

    private var childrenList:Array<IDisplayObject> = [];

    override private function init():Void
    {
        super.init();

        for (i in 0...count)
        {
            factory.mapClassNameToValue("Bool", true, "renderAsSprite");

            var spineClip:ISpineClip = factory.getInstance(ISpineClip);
            spineClip.setBlendTime(0.3);
            spineClip.setAssetId(assetPathList[0]);

            animList = spineClip.getAnimIdList();

            add(spineClip);

            switchAnimation(spineClip);
        }
    }

    private function switchAnimation(spineClip:ISpineClip):Void
    {
        spineClip.play(true, animList[currentAnimIndex]);

        currentAnimIndex++;

        if (currentAnimIndex == animList.length)
        {
            currentAnimIndex = 0;
        }

        haxe.Timer.delay(() -> switchAnimation(spineClip), 2000 + Math.floor(Math.random() * 1000));
    }

    private function add(child:IDisplayObject):Void
    {
        child.x = x;
        child.y = y;

        if (child.assets != null)
        {
            container.addChild(child.assets);
        }

        x += child.width;

        childrenList.push(child);
    }

    override public function getHeight():Float
    {
        //TODO: find out, why container.height returs 0
        return childrenList[0].height;
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

}
