package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		
		[Embed(source="../media/graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source="../images/play.png")]
		public static const buttonPlay:Class;
		
		[Embed(source="../images/CircleBadGuy.png")] 
		public static const circleBadGuyRaw:Class;
		
		[Embed(source="../images/ScaredBox.png")] 
		public static const scaredBoxRaw:Class;
		
		[Embed(source="../images/Fireball.png")] 
		private static const fireBallRaw:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
			
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getBitmap(name:String):Bitmap
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = bitmap;
			}
			return gameTextures[name];
		}
	}
}