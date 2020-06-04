package config;

import com.cf.devkit.config.Config;

class SamplesConfig extends Config
{
    override private function init():Void
    {
        super.init();

        #if useStarling
        _swfAssetLibList = [_basePath + "bundle_1.zip", _basePath + "bundle_2.zip"];
        #else
        _swfAssetLibList = ["swf"];
        #end
    }
}
