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
		private var timerTxt:TextField;
		private var seconds:int = 0;
		private var timer:Timer = new Timer(1000);
		
		public static var shootTimer:ProgressBar;
		public static var hpBar:ProgressBar;
		
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
			timerTxt.x = 110;
			timerTxt.y = 10;
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
			shootTimer.x = 380;
			shootTimer.y = 15;
			addChild( shootTimer );
			
			hpBar = new ProgressBar();
			hpBar.minimum = 0;
			hpBar.maximum = 1;
			hpBar.value = 1;
			hpBar.x = 380;
			hpBar.y = 50;
			//hpBar.direction = ProgressBar.DIRECTION_VERTICAL;
			addChild( hpBar );
		}
		
		
		private function updateClock(e:TimerEvent):void
		{
			seconds++;
			timerTxt.text = "Time: "+seconds.toString()+" seconds";
		}
		
	}
}