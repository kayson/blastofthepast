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
		private var playLvl3:Button;
		private var playLvl4:Button;
		private var playLvl5:Button;

		public static var levelActive:int = 5;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("welcome screen initialized");
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getTexture("BgWelcome"));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			playLvl1 = new Button(Assets.getTexture("buttonLvl1"));
			playLvl1.scaleX = 0.2;
			playLvl1.scaleY = 0.2;
			playLvl1.x = 100;
			playLvl1.y = 100;
			this.addChild(playLvl1);
			
			playLvl2 = new Button(Assets.getTexture("buttonLvl2"));
			playLvl2.scaleX = 0.2;
			playLvl2.scaleY = 0.2;
			playLvl2.x = 200;
			playLvl2.y = 100;
			if(levelActive < 2)
				playLvl2.enabled = false;
			this.addChild(playLvl2);
			
			playLvl3 = new Button(Assets.getTexture("buttonLvl3"));
			playLvl3.scaleX = 0.2;
			playLvl3.scaleY = 0.2;
			playLvl3.x = 300;
			playLvl3.y = 100;
			if(levelActive < 3)
				playLvl3.enabled = false;
			this.addChild(playLvl3);
			
			playLvl4 = new Button(Assets.getTexture("buttonLvl4"));
			playLvl4.scaleX = 0.2;
			playLvl4.scaleY = 0.2;
			playLvl4.x = 400;
			playLvl4.y = 100;
			if(levelActive < 4)
				playLvl4.enabled = false;
			this.addChild(playLvl4);
			
			playLvl5 = new Button(Assets.getTexture("buttonLvl5"));
			playLvl5.scaleX = 0.2;
			playLvl5.scaleY = 0.2;
			playLvl5.x = 500;
			playLvl5.y = 100;
			if(levelActive < 5)
				playLvl5.enabled = false;
			this.addChild(playLvl5);
			
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
				case playLvl3:
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "lvl3"}, true));
					trace(buttonClicked == playLvl3);
					trace("lvl3 initialized");
					break;
				
				case playLvl4:
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "lvl4"}, true));
					trace(buttonClicked == playLvl4);
					trace("lvl4 initialized");
					break;
				
				case playLvl5:
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "lvl5"}, true));
					trace(buttonClicked == playLvl5);
					trace("lvl5 initialized");
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