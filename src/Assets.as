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
		
		[Embed(source="../images/blackstone.jpg")] 
		private static const stoneBlock:Class;
		
		[Embed(source="../images/water.png")] 
		private static const waterRaw:Class;
		
		[Embed(source="../images/arrow.png")] 
		private static const arrowRaw:Class;
		
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
		
		[Embed(source="../images/andersillu/background_forest2.png")]
		public static const BgLayer1:Class;
		
		[Embed(source="../images/andersillu/background_diamonds_l2.png")]
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
		private static var gameTextureAtlasIdle:TextureAtlas;
		private static var gameTextureAtlasShoot:TextureAtlas;
		private static var gameTextureAtlasTiles:TextureAtlas;
		
		//IDLE
		[Embed(source="../images/andersillu/flash/player_diamond_idle.png")]
		public static const AtlasTextureGameIdle:Class;
		
		[Embed(source="../images/andersillu/flash/player_diamond_idle.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameIdle:Class;
		
		//SHOOT
		[Embed(source="../images/andersillu/flash/player_diamond_shoot.png")]
		public static const AtlasTextureGameShoot:Class;
		
		[Embed(source="../images/andersillu/flash/player_diamond_shoot.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameShoot:Class;
		
		//TILES
		[Embed(source="../images/andersillu/flash/tile_sprite.png")]
		public static const AtlasTextureGameTiles:Class;
		
		[Embed(source="../images/andersillu/flash/tile_sprite.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameTiles:Class;
		
		public static function getAtlasIdle():TextureAtlas
		{
			if (gameTextureAtlasIdle == null)
			{
				var texture:Texture = getTexture("AtlasTextureGameIdle");
				var xml:XML = XML(new AtlasXmlGameIdle());
				gameTextureAtlasIdle = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlasIdle;
		}
		
		public static function getAtlasShoot():TextureAtlas
		{
			if (gameTextureAtlasShoot == null)
			{
				var texture:Texture = getTexture("AtlasTextureGameShoot");
				var xml:XML = XML(new AtlasXmlGameShoot());
				gameTextureAtlasShoot = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlasShoot;
		}
		
		public static function getAtlasTiles():TextureAtlas
		{
			if (gameTextureAtlasTiles == null)
			{
				var texture:Texture = getTexture("AtlasTextureGameTiles");
				var xml:XML = XML(new AtlasXmlGameTiles());
				gameTextureAtlasTiles = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlasTiles;
		}

	}
}