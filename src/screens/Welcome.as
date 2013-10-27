package screens
{
	import events.NavigationEvent;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Welcome extends Sprite
	{
		private var bg:Image;
		
		private var playLvl1:Button;
		private var playLvl2:Button;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("welcome screen initialized");
			
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getTexture("BgWelcome"));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			playLvl1 = new Button(Assets.getTexture("buttonPlay"));
			playLvl1.scaleX = 0.2;
			playLvl1.scaleY = 0.2;
			playLvl1.x = 100;
			playLvl1.y = 100;
			this.addChild(playLvl1);
			
			playLvl2 = new Button(Assets.getTexture("buttonPlay"));
			playLvl2.scaleX = 0.2;
			playLvl2.scaleY = 0.2;
			playLvl2.x = 200;
			playLvl2.y = 100;
			this.addChild(playLvl2);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			switch(buttonClicked)	
			{
				case playLvl1:
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "lvl1"}, true));
					trace(buttonClicked == playLvl1);
					trace("lvl1 initialized");
					break;

				case playLvl2:
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "lvl2"}, true));
					trace(buttonClicked == playLvl2);
					trace("lvl2 initialized");
					break;
			}
			
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
	}
}