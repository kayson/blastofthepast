package
{

	import events.NavigationEvent;
	
	import screens.InGame;
	import screens.lvl2;
	import screens.Welcome;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class GameWorld extends Sprite
	{

		private var screenWelcome:Welcome;
		private var screenInGame:lvl2;

	

		public function GameWorld()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			super();
		}
		
		private function onAddedToStage(evt:Event):void
		{
			trace("starling framework initialized!");
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			

			screenInGame = new lvl2();
			screenInGame.disposeTemporarily();
			this.addChild(screenInGame);

			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialize();

		}		
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{

				case "play":
					screenWelcome.disposeTemporarily();
					screenInGame.initialize();
					break;

			}
		}
	}
}