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
		
		[Embed(source="../images/CircleBadGuy.png")] 
		public static const circleBadGuyRaw:Class;
		
		[Embed(source="../images/ScaredBox.png")] 
		public static const scaredBoxRaw:Class;
		
		[Embed(source="../images/Fireball.png")] 
		private static const fireBallRaw:Class;
		
		[Embed(source="../images/enemy.png")]
		private static const enemyRaw:Class;
		
		[Embed(source="../images/stone.jpg")] 
		private static const stoneBlock:Class;
		
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
		
		//Sound
		
		[Embed(source="../sound/shoot.mp3")]
		private static const shootSound:Class;
		public static const shoot:Sound = new shootSound();;
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		public function Assets():void
		{
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

	}
}