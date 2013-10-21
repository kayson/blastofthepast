package screens
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	
	import objects.GameBackground;
	import objects.Objects;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Level extends Sprite implements LevelInterface
	{
		public var mySpace:Space;
		public var screenWidth:Number;
		public var screenHeight:Number;
		public var player:Objects;
		public var stoneBlock:Objects;
		public var enemy:Objects;
		public var box:Objects;
		public var toMenu:Button;
		public var goal:Objects;
		
		public var bg:GameBackground;
		
		private var timerTxt:TextField;
		private var seconds:int = 0;
		private var timer:Timer = new Timer(1000);
		
		public function Level()
		{
			
		}
		
		private function InitSpace():void
		{
			var worldGravity:Vec2 = Vec2.weak(0,600);
			mySpace = new Space( worldGravity );			
			
			screenWidth = 960;//Starling.current.nativeStage.fullScreenWidth;
			screenHeight = 640;//Starling.current.nativeStage.fullScreenHeight;
		}
		
		public function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			InitSpace();
			
			
			addEventListener( TouchEvent.TOUCH, touch);
			
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.projectile, globalFunctions.other, hasCollided));
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.projectile, globalFunctions.enemyCb, enemyHit));
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.player, globalFunctions.goal, playerInGoal));
			
		}
		
		
		
		private function touch(e:TouchEvent):void
		{
			globalFunctions.touchGlobal(e, stage,player,mySpace, this);
		}
		
		private function hasCollided(cb:InteractionCallback):void {
			
			globalFunctions.hasCollidedGlobal(cb, mySpace, stage, this);
		}
		
		private function enemyHit(cb:InteractionCallback):void {
			
			globalFunctions.enemyHitGlobal(cb, mySpace, stage, this);
		}
		
		private function playerInGoal(cb:InteractionCallback):void
		{
			globalFunctions.playerInGoal(cb, mySpace, stage, this);
		}
		
		private function updateGraphics( body:Body ):void
		{
			globalFunctions.updateGraphicsGlobal(body, player, new Vec2(screenWidth,screenHeight));
			
		}
		
		public function onMainMenuClick():void
		{
			trace("button to mainmenu");
			this.disposeTemporarily();
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,
				{id: "Menu"}, true));	
		}		
		
		private function UpdateWorld( evt:Event ):void
		{
			globalFunctions.UpdateWorldGlobal(evt, mySpace,player, bg,updateGraphics);
			
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			removeEventListener(Event.ENTER_FRAME, UpdateWorld );
			
			if(this)
			{
				this.removeChildren();
			}
			if(mySpace)
			{
				mySpace.clear();
			}
			if(stage)
			{
				//stage.removeChildren();
			}
		}
		
		public function initialize():void
		{
			//Text
			timerTxt = new TextField(180, 30, "Time: 0 seconds", "Arial", 15, 0x000000, true);
			timerTxt.autoScale = true;
			timerTxt.pivotX = timerTxt.width/2;
			timerTxt.x = 170;
			timerTxt.y = 0;
			timerTxt.hAlign = HAlign.LEFT;
			timerTxt.vAlign = VAlign.CENTER;
			addChild(timerTxt);
			
			this.visible = true;
			addEventListener( Event.ENTER_FRAME, UpdateWorld );
			
			timer.addEventListener(TimerEvent.TIMER, updateClock);
			timer.start();
		}
		
		public function updateClock(e:TimerEvent):void
		{
			seconds++;
			timerTxt.text = "Time: "+seconds.toString()+" seconds";
		}
		
		public function addObjectToInstance(obj:DisplayObject):void
		{
			this.addChild(obj);
		}
		
		public function removeObjectFromInstance(obj:DisplayObject):void
		{
			this.removeChild(obj);
		}
		
		public function getPlayer():Objects
		{
			return player;
		}
	}
}