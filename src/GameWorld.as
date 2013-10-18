package
{

	import events.NavigationEvent;
	
	import screens.lvl1;
	import screens.Welcome;
	import screens.lvl2;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class GameWorld extends Sprite
	{

		private var screenWelcome:Welcome;
		private var screenLvl1:lvl1;
		private var screenLvl2:lvl2;

	

		public function GameWorld()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			super();
		}
		
		private function onAddedToStage(evt:Event):void
		{
			trace("starling framework initialized!");
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			

			screenLvl1 = new lvl1();
			screenLvl1.disposeTemporarily();
			this.addChild(screenLvl1);
			
			screenLvl2 = new lvl2();
			screenLvl2.disposeTemporarily();
			this.addChild(screenLvl2);

			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialize();

		}		
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{

				case "lvl1":
					screenWelcome.disposeTemporarily();
					screenLvl1.initialize();
					break;
				case "lvl2":
					screenWelcome.disposeTemporarily();
					screenLvl2.initialize();
					break;

			}
		}
	}
}