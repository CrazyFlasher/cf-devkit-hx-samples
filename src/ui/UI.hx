package ui;

import com.cf.devkit.utils.AssetQualityUtils;
import feathers.controls.Button;
import com.cf.devkit.services.stats.IStatsServiceImmutable;
import feathers.controls.ComboBox;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.ListView;
import feathers.controls.Panel;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AutoSizeMode;
import openfl.events.Event;

class UI extends LayoutGroup
{
    private final BOX_WIDTH:Float = 270;
    private final BOX_HEIGHT:Float = 50;

    public var sampleData(get, never):Dynamic;
    public var menuHeight(get, never):Float;

    private var _sampleData:Dynamic;

    private var configJson:Dynamic;
    private var stats:IStatsServiceImmutable;

    private var menuGroup:Panel;
        private var sampleList:ComboBox;
            private var listView:ListView;

        private var renderingTypeLabel:Label;

    private var basePath:String;

    public function new(configJson:Dynamic, stats:IStatsServiceImmutable, basePath:String)
    {
        super();

        this.configJson = configJson;
        this.stats = stats;
        this.basePath = basePath;

        init();
    }

    private function init():Void
    {
        autoSizeMode = AutoSizeMode.STAGE;
        layout = new AnchorLayout();

        menuGroup = createMenuPanel();
        addChild(menuGroup);

        renderingTypeLabel.text = Std.string(AssetQualityUtils.getQuality());
//        renderingTypeLabel.text = #if useStarling "Starling 2.5.1" #else "OpenFL 8.9.6" #end;
    }

    override private function layoutGroup_stage_resizeHandler(event:Event):Void
    {
        super.layoutGroup_stage_resizeHandler(event);

        updateListViewHeight();
    }

    override private function layoutGroup_addedToStageHandler(event:Event):Void
    {
        super.layoutGroup_addedToStageHandler(event);

        boxChangeHandler();
    }

    private function updateListViewHeight():Void
    {
        if (listView != null && stage != null && menuGroup != null)
        {
            listView.height = stage.stageHeight - menuGroup.height;
        }
    }

    private function createMenuPanel():Panel
    {
        var group:Panel = new Panel();
        group.layout = new AnchorLayout();

        var layoutData:AnchorLayoutData = new AnchorLayoutData();
        layoutData.top = layoutData.left = layoutData.right = 0.0;

        group.layoutData = layoutData;

        renderingTypeLabel = createRenderingTypeLabel();
        group.addChild(renderingTypeLabel);

        sampleList = createSampleList();
        group.addChild(sampleList);

        return group;
    }

    private function filter(list:Array<Dynamic>):Array<Dynamic>
    {
        var newList:Array<Dynamic> = [];
        for (sample in list)
        {
            if (#if useStarling !sample.openflOnly #else !sample.starlingOnly #end)
            {
                sample.name = (list.indexOf(sample) + 1) + ". " + sample.name;

				if (sample.assetPathList != null)
				{
					for (i in 0...sample.assetPathList.length)
					{
                        if (sample.qualityDependant)
                        {
                            sample.assetPathList[i] = basePath + sample.assetPathList[i];
                        }
					}
				}

                newList.push(sample);
            }
        }
        return newList;
    }

    private function createRenderingTypeLabel():Label
    {
        var label:Label = new Label();

        var layoutData:AnchorLayoutData = new AnchorLayoutData();
        layoutData.verticalCenter = 0.0;
        layoutData.right = 10.0;
        label.layoutData = layoutData;

        return label;
    }

    private function createSampleList():ComboBox
    {
        var box:ComboBox = new ComboBox();
        box.width = BOX_WIDTH;

		box.buttonFactory = () -> {
			var button:Button = new Button();
			button.width = button.height = BOX_HEIGHT;
			return button;
		}

        box.listViewFactory = () -> {
            var list:ListView = new ListView();
            list.width = BOX_WIDTH;

            this.listView = list;
            this.updateListViewHeight();
            return list;
        }

        var layoutData:AnchorLayoutData = new AnchorLayoutData();
        layoutData.verticalCenter = 0.0;
        layoutData.left = 0.0;
        box.layoutData = layoutData;

        box.itemToText = (item:Dynamic) -> {
            return item.name;
        };

        box.dataProvider = new ArrayCollection(filter(configJson.sampleList));

        box.addEventListener(Event.CHANGE, boxChangeHandler);

        return box;
    }

    private function boxChangeHandler(e:Event = null):Void
    {
        _sampleData = sampleList.selectedItem;

        dispatchEvent(new UIevent(UIevent.EXAMPLE_CHANGED));
    }

    private function get_sampleData():Dynamic
    {
        return _sampleData;
    }

    private function get_menuHeight():Float
    {
        return BOX_HEIGHT;
    }
}

class UIevent extends Event
{
    public static inline var EXAMPLE_CHANGED:String = "UIevent.EXAMPLE_CHANGED";

    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
    }
}