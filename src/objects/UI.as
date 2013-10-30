package objects
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import feathers.controls.ProgressBar;
	import feathers.themes.AeonDesktopTheme;
	import feathers.themes.MetalWorksMobileTheme;
	import feathers.themes.MinimalMobileTheme;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class UI extends Sprite
	{
		public var timerTxt:TextField;
		public var seconds:int = 0;
		public var timer:Timer = new Timer(1000);
		
		public static var shootTimer:ProgressBar;
		
		private var progressTween:Tween;
		
		public function UI()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event:Event):void
		{
			//Text
			var texture:Texture = Texture.fromBitmap(new Assets.FontTexture());
			var xml:XML = XML(new Assets.FontXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			timerTxt = new TextField(180, 30, "Time: 0 seconds", "Cronos Pro", 30, 0xFFFFFF);
			timerTxt.pivotX = timerTxt.width/2;
			timerTxt.x = 170;
			timerTxt.y = 0;
			timerTxt.hAlign = HAlign.LEFT;
			timerTxt.vAlign = VAlign.CENTER;
			addChild(timerTxt);
			
			timer.addEventListener(TimerEvent.TIMER, updateClock);
			timer.start();
			
			new MetalWorksMobileTheme();
			shootTimer = new ProgressBar();
			shootTimer.minimum = 0;
			shootTimer.maximum = 1;
			shootTimer.value = 1;
			shootTimer.x = 400;
			shootTimer.y = 10;
			addChild( shootTimer );
		}
		
		
		private function updateClock(e:TimerEvent):void
		{
			seconds++;
			timerTxt.text = "Time: "+seconds.toString()+" seconds";
		}
		
	}
}