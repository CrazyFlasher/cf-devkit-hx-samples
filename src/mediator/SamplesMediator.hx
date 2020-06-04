package mediator;

import openfl.geom.Rectangle;
import com.cf.devkit.display.Stage;
import com.cf.devkit.mediators.BaseMediator;
import com.cf.devkit.config.IConfig;
import samples.AbstractSample;
import ui.UI;
import ui.UI.UIevent;
import com.cf.devkit.services.stats.IStatsServiceImmutable;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.services.resources.ResourceServiceMessageType;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;

import samples.masks.SpriteMaskSample;
import samples.particles.JellyFishParticleSample;
import samples.spine.TigerMeshSpineSample;
import samples.db.BossDBSample;
import samples.db.IntroSample;
import samples.fla.SceneSample;
import samples.scale9slice.Scale9SliceSample;

#if useStarling
import samples.videoTexture.VideoTextureSample;
import samples.waveEffect.WaveEffectSample;
import samples.pixelMask.PixelMaskSample;
import samples.textureMask.TextureMaskSample;
import samples.light.LightSample;
import samples.rays.RaysSample;
import samples.spriteSheet.AnimatedSpriteSheetStarling;
import samples.particles.MovieClipParticleSample;
import samples.draw.Draw;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
#else
import samples.spriteSheet.AnimatedSpriteSheetOpenFL;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
#end

class SamplesMediator extends BaseMediator
{
    @Inject("safeArea")
    private var padding:Rectangle;

    @Inject
    private var config:IConfig;

    @Inject("window")
    private var window:openfl.display.DisplayObjectContainer;

    @Inject
    private var statsService:IStatsServiceImmutable;

    private var loadingTf:TextField;

    private var ui:UI;
    private var sample:AbstractSample;

    override private function init():Void
    {
        super.init();

        var sampleContainer:Sprite = new Sprite();
        viewFactory.mapToValue(Sprite, sampleContainer, "sampleContainer");
        container.addChild(sampleContainer);

        createLoadingText();

        addMessageListener(ResourceServiceMessageType.LoadComplete, loaded);
        addMessageListener(ResourceServiceMessageType.LoadProgress, progress);

        Stage.addResizeListener(updatePaddingArea);
    }

    private function updatePaddingArea(data:Dynamic = null):Void
    {
        if (ui != null)
        {
            padding.top = ui.menuHeight / Stage.stageHeight;
        }
    }

    private function progress(m:IMessage):Void
    {
        loadingTf.text = "LOADING..." + Math.round(res.progress * 100) + "%";
    }

    private function loaded(m:IMessage):Void
    {
        window.removeChild(loadingTf);

        buildUI();

        #if (debug || showFPSAlways)
        com.cf.devkit.app.AbstractApp.showStats(true);
        #end
    }

    public function getSampleWidth():Float
    {
        return sample.getWidth();
    }

    public function getSampleHeight():Float
    {
        return sample.getHeight();
    }

    public function hasSampleInitialized():Bool
    {
        return sample != null;
    }

    private function buildUI():Void
    {
        ui = new UI(res.getJson("assets/config.json"), statsService, config.basePath);
        ui.addEventListener(UIevent.EXAMPLE_CHANGED, exampleChanged);
        window.addChild(ui);

        updatePaddingArea();
    }

    private function exampleChanged(e:UIevent):Void
    {
        var sampleData:Dynamic = ui.sampleData;

        if (sample != null)
        {
            sample.dispose();
        }

        viewFactory.unmapClassName("Array<String>", "assetPathList");

        if (sampleData.assetPathList != null)
        {
            viewFactory.mapClassNameToValue("Array<String>", sampleData.assetPathList, "assetPathList");
        }

        viewFactory.mapClassNameToValue("Int", sampleData.count != null ? sampleData.count : 1, "count");
        sample = viewFactory.instantiateUnmapped(Type.resolveClass(sampleData.clazz));

        updatePaddingArea();

        dispatchMessage(SampleMediatorMessageType.SampleChanged, ui.sampleData);
    }

    private function createLoadingText():Void
    {
        loadingTf = new TextField();
        loadingTf.selectable = false;
        loadingTf.autoSize = TextFieldAutoSize.LEFT;
        loadingTf.textColor = 0xffffff;
        loadingTf.x = loadingTf.y = 5;
        loadingTf.setTextFormat(new TextFormat("Arial", 24, 0xffffff));

        window.addChild(loadingTf);
    }

    override private function getContainer():DisplayObjectContainer
    {
        return gameContainer;
    }
}

enum SampleMediatorMessageType
{
    SampleChanged;
}