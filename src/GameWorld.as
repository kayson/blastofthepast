package
{
	
	import events.NavigationEvent;
	
	import objects.UI;
	
	import screens.Welcome;
	import screens.lvl1;
	import screens.lvl2;
	import screens.lvl3;
	import screens.lvl4;
	import screens.lvl5;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class GameWorld extends Sprite
	{

		private var screenWelcome:Welcome;
		private var screenLvl1:lvl1;
		private var screenLvl2:lvl2;
		private var screenLvl3:lvl3;
		private var screenLvl4:lvl4;
		private var screenLvl5:lvl5;
		private var ui:UI;

	

		public function GameWorld()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			super();
		}
		
		private function onAddedToStage(evt:Event):void
		{
			trace("starling framework initialized!");
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
		
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialize();
			
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );

		}		
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "Menu":
					
					screenWelcome = new Welcome();
					this.addChild(screenWelcome);
					
					screenWelcome.disposeTemporarily();
					screenWelcome.initialize();
					
					this.removeChild(ui);
					
					break;
				case "lvl1":
					
					screenLvl1 = new lvl1();
					
					screenLvl1.disposeTemporarily();
					this.addChild(screenLvl1);
					
					screenWelcome.disposeTemporarily();
					screenLvl1.initialize();
					
					ui = new UI();
					this.addChild(ui);
										
					break;
				case "lvl2":
					screenLvl2 = new lvl2();
					screenLvl2.disposeTemporarily();
					this.addChild(screenLvl2);
					
					screenWelcome.disposeTemporarily();
					screenLvl2.initialize();
					
					ui = new UI();
					this.addChild(ui);
					
					break;
				
				case "lvl3":
					screenLvl3 = new lvl3();
					screenLvl3.disposeTemporarily();
					this.addChild(screenLvl3);
					
					screenWelcome.disposeTemporarily();
					screenLvl3.initialize();
					
					ui = new UI();
					this.addChild(ui);
					
					break;
				
				case "lvl4":
					screenLvl4 = new lvl4();
					screenLvl4.disposeTemporarily();
					this.addChild(screenLvl4);
					
					screenWelcome.disposeTemporarily();
					screenLvl4.initialize();
					
					ui = new UI();
					this.addChild(ui);
					
					break;
				
				case "lvl5":
					screenLvl5 = new lvl5();
					screenLvl5.disposeTemporarily();
					this.addChild(screenLvl5);
					
					screenWelcome.disposeTemporarily();
					screenLvl5.initialize();
					
					ui = new UI();
					this.addChild(ui);
					
					break;

			}
		}
	}
}