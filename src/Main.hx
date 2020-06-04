package ;

import context.SamplesContext;
import com.cf.devkit.app.AbstractApp;

class Main extends AbstractApp
{
    override private function getContextImplementation():Class<Dynamic>
    {
        return SamplesContext;
    }

    override private function initialize():Void
    {
        createContext();
    }
}
