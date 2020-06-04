package context;

import config.SamplesConfig;
import com.cf.devkit.config.IConfig;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.services.resources.ResourceServiceMessageType;
import mediator.SamplesMediator;
import com.cf.devkit.context.BaseContext;

#if !useStarling
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;
#else
import starling.display.Sprite;
import starling.display.DisplayObjectContainer;
#end

class SamplesContext extends BaseContext
{
    private var mediator:SamplesMediator;

    override private function init():Void
    {
        super.init();

        mediator = mediatorFactory.instantiateUnmapped(SamplesMediator);
        addMediator(mediator);

        addMessageListener(ResourceServiceMessageType.LoadComplete, loaded);
        addMessageListener(SampleMediatorMessageType.SampleChanged, sampleChanged);

        resourceService.loadFromManifest();
    }

    override private function mapValues():Void
    {
        super.mapValues();

        viewFactory.mapToValue(DisplayObjectContainer, root, "root");
    }

    override private function createScreenResizer():Void
    {
        if (mediator != null && mediator.hasSampleInitialized())
        {
            gameWidth = Math.ceil(mediator.getSampleWidth());
            gameHeight = Math.ceil(mediator.getSampleHeight());
        }

        super.createScreenResizer();
    }

    private function sampleChanged(m:IMessage):Void
    {
        createScreenResizer();
    }

    override private function mapTypes():Void
    {
        super.mapTypes();

        modelFactory.mapToType(IConfig, SamplesConfig);
    }

    override private function createGameContainer():Void
    {
        gameContainer = new Sprite();
        root.addChild(gameContainer);
    }

    private function loaded(m:IMessage):Void
    {

    }
}
