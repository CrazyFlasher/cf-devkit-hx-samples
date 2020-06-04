package samples;

import com.domwires.core.factory.IAppFactory;
import com.cf.devkit.services.resources.IResourceServiceImmutable;
import com.domwires.core.common.AbstractDisposable;

#if useStarling
import starling.display.Sprite;
#else
import openfl.display.Sprite;
#end

class AbstractSample extends AbstractDisposable
{
    @Inject("assetPathList")
    @Optional
    private var assetPathList:Array<String>;

    @Inject
    private var factory:IAppFactory;

    @Inject("sampleContainer")
    private var container:Sprite;

    @Inject
    private var res:IResourceServiceImmutable;

    @PostConstruct
    private function init():Void
    {

    }

    public function getWidth():Float
    {
        return container.width;
    }

    public function getHeight():Float
    {
        return container.height;
    }
}
