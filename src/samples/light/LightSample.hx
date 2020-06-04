package samples.light;

import com.cf.devkit.starling.display.MovieClip;
import openfl.geom.Rectangle;
import openfl.Vector;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.Event;
import starling.extensions.lighting.LightSource;
import starling.extensions.lighting.LightStyle;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

class LightSample extends AbstractSample
{
	private var subContainer:DisplayObjectContainer;

	private var _characters:Sprite;
	private var _stageWidth:Float;
	private var _stageHeight:Float;

	override public function dispose():Void
	{
		subContainer.removeFromParent(true);

		super.dispose();
	}

	override public function getWidth():Float
	{
		return 800;
	}

	override public function getHeight():Float
	{
		return 400;
	}

	override private function init():Void
	{
		super.init();

		_stageWidth = getWidth();
		_stageHeight = getHeight();

		subContainer = new Sprite();
		container.addChild(subContainer);

		_characters = new Sprite();
		_characters.y = _stageHeight / 2;
		subContainer.addChild(_characters);

		var assetsBasePath:String = "assets/misc/";

		var characterNormalTexture:Texture = res.getTexture(assetsBasePath + "character_n.png");
		var characterXml:Xml = cast res.getText(assetsBasePath + "character.xml");

		var normalTextureAtlas:TextureAtlas = new TextureAtlas(characterNormalTexture, characterXml);
		var textures:Vector<Texture> = res.getTextureAtlas(assetsBasePath + "character.png").getTextures();
		var normalTextures:Vector<Texture> = normalTextureAtlas.getTextures();

		var bulbTextureAltas:Texture = res.getTexture(assetsBasePath + "lightbulbs.png");
		var textureWidth:Float = bulbTextureAltas.width / 3;
		var textureHeight:Float = bulbTextureAltas.height;

		var pointLightTexture:Texture = Texture.fromTexture(bulbTextureAltas, new Rectangle(0, 0, textureWidth, textureHeight));
		var ambientLightTexture:Texture = Texture.fromTexture(bulbTextureAltas, new Rectangle(textureWidth, 0, textureWidth, textureHeight));
		var directionalLightTexture:Texture = Texture.fromTexture(bulbTextureAltas, new Rectangle(textureWidth * 2, 0, textureWidth,
		textureHeight));

		var ambientLight:LightSource = LightSource.createAmbientLight();
		ambientLight.x = _stageWidth * 0.5;
		ambientLight.y = _stageHeight * 0.2;
		ambientLight.z = -150;

		var pointLightA:LightSource = LightSource.createPointLight(0x00ff00);
		pointLightA.x = _stageWidth * 0.25;
		pointLightA.y = _stageHeight * 0.2;
		pointLightA.z = -150;
		pointLightA.showLightBulb = pointLightTexture;

		var pointLightB:LightSource = LightSource.createPointLight(0xff00ff);
		pointLightB.x = _stageWidth * 0.75;
		pointLightB.y = _stageHeight * 0.2;
		pointLightB.z = -150;
		pointLightB.showLightBulb = pointLightTexture;

		/*var directionalLight:LightSource = LightSource.createDirectionalLight();
		directionalLight.x = _stageWidth * 0.6;
		directionalLight.y = _stageHeight * 0.3;
		directionalLight.z = -150;
		directionalLight.rotationY = -1.0;
		directionalLight.showLightBulb = directionalLightTexture;*/

		addMarchingCharacters(8, textures, normalTextures);

		subContainer.addChild(ambientLight);
		subContainer.addChild(pointLightA);
		subContainer.addChild(pointLightB);
//		subContainer.addChild(directionalLight);
	}

	private function addMarchingCharacters(count:Int,
										   textures:Vector<Texture>,
										   normalTextures:Vector<Texture>):Void
	{
		var characterWidth:Float = textures[0].frameWidth;
		var offset:Float = (_stageWidth + characterWidth) / count;

		for (i in 0...count)
		{
			var movie:MovieClip = createCharacter(textures, normalTextures);
			movie.currentTime = movie.totalTime * Math.random();
			movie.x = -characterWidth + i * offset;
			movie.y = movie.height / -2;
			movie.addEventListener(Event.ENTER_FRAME, (event:Event, passedTime:Float) -> {
				var character:MovieClip = cast event.target;
				character.advanceTime(passedTime);
				character.x += 100 * passedTime;

				if (character.x > _stageWidth)
					character.x = -character.width + (character.x - _stageWidth);
			});
			_characters.addChild(movie);
		}
	}

	private function createCharacter(textures:Vector<Texture>,
									 normalTextures:Vector<Texture>,
									 fps:Int = 12):MovieClip
	{
		var movie:MovieClip = new MovieClip(textures, fps);
		var lightStyle:LightStyle = new LightStyle(normalTextures[0]);
		lightStyle.ambientRatio = 0.3;
		lightStyle.diffuseRatio = 0.7;
		lightStyle.specularRatio = 0.5;
		lightStyle.shininess = 16;

		movie.style = lightStyle;

		for (i in 0...movie.numFrames)
		{
			movie.setFrameAction(i, (movieClip:MovieClip, frameID:Int) ->
			{
				lightStyle.normalTexture = normalTextures[frameID];
			});
		}

		return movie;
	}
}
