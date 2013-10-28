package
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		
		[Embed(source="../images/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source="../images/play.png")]
		public static const buttonPlay:Class;
		
		[Embed(source="../images/goal.png")] 
		public static const goalRaw:Class;
		
		[Embed(source="../images/CircleBadGuy.png")] 
		public static const circleBadGuyRaw:Class;
		
		[Embed(source="../images/ScaredBox.png")] 
		public static const scaredBoxRaw:Class;
		
		[Embed(source="../images/Fireball.png")] 
		private static const fireBallRaw:Class;
		
		[Embed(source="../images/enemy.png")]
		private static const enemyRaw:Class;
		
		[Embed(source="../images/stone2.jpg")] 
		private static const stoneBlock:Class;
		
		[Embed(source="../images/water.png")] 
		private static const waterRaw:Class;
		
		//Levelnumbers
		[Embed(source="../images/levelnumbers/1.png")]
		public static const buttonLvl1:Class;
		
		[Embed(source="../images/levelnumbers/2.png")]
		public static const buttonLvl2:Class;
		
		[Embed(source="../images/levelnumbers/3.png")]
		public static const buttonLvl3:Class;
		
		[Embed(source="../images/levelnumbers/4.png")]
		public static const buttonLvl4:Class;
		
		[Embed(source="../images/levelnumbers/5.png")]
		public static const buttonLvl5:Class;
		
		
		
		//Background layers
		
		[Embed(source="../images/bgLayer1.jpg")]
		public static const BgLayer1:Class;
		
		[Embed(source="../images/bgLayer2.png")]
		public static const BgLayer2:Class;
		
		[Embed(source="../images/bgLayer3.png")]
		public static const BgLayer3:Class;
		
		[Embed(source="../images/bgLayer4.png")]
		public static const BgLayer4:Class;
		
		//Particles
		
		[Embed(source="../particles/explosion/particle.pex", mimeType="application/octet-stream")]
		public static const FireConfig:Class;
		
		[Embed(source="../particles/explosion/texture.png")]
		public static const FireParticle:Class;
		
		[Embed(source="../particles/enemydeath/particle.pex", mimeType="application/octet-stream")]
		public static const EnemyDeathConfig:Class;
		
		[Embed(source="../particles/enemydeath/texture.png")]
		public static const EnemyDeathParticle:Class;
		
		//Fonts
		[Embed(source="../media/cronospro.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../media/cronospro_0.png")]
		public static const FontTexture:Class;
		
		//Sound	
		[Embed(source="../sound/shoot.mp3")]
		private static const shootSound:Class;
		public static const shoot:Sound = new shootSound();
		
		[Embed(source="../sound/saw.mp3")]
		private static const sawSound:Class;
		public static const saw:Sound = new sawSound();

		
		private static var gameTextures:Dictionary = new Dictionary();
		
		public function Assets():void
		{
			//Pga av bugg i flash måste ljudet spelas en gång.
			shoot.play(0,0, new SoundTransform(0));	
		}
			
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		//SPRITESHEETSGREJER
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="../images/andersillu/flash/player_test_spritesheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="../images/andersillu/flash/player_test_spritesheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}

	}
}