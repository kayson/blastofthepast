package screens
{
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.space.Space;
	
	import objects.GameBackground;
	import objects.Objects;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	
	public class lvl3 extends Sprite implements LevelInterface
	{			
		public var mySpace:Space;
		public var screenWidth:Number;
		public var screenHeight:Number;
		public var player:Objects;
		public var water:Objects;
		public var stoneBlock:Objects;
		public var enemy:Objects;
		public var box:Objects;
		public var toMenu:Button;
		public var goal:Objects;
		
		public var bg:GameBackground;
		
		private var timerTxt:TextField;
		private var seconds:int = 0;
		private var timer:Timer = new Timer(1000);
		
		public function lvl3()
		{
			
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}

		private function InitSpace():void
		{
			var worldGravity:Vec2 = Vec2.weak(0,800);
			mySpace = new Space( worldGravity );			
			
			screenWidth = 960;//Starling.current.nativeStage.fullScreenWidth;
			screenHeight = 640;//Starling.current.nativeStage.fullScreenHeight;
		}
		
		protected  function  onAddedToStage(event:Event):void
		{
			trace("In onAddedToStage in superlevel ----------------------");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			InitSpace();
			InitBodies();
			
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

		private function InitBodies():void
		{	
			var tempValue:Number = 300;
			
			//Parallax background baby!
			bg = new GameBackground();
			addChild(bg);		
			
			
			//The player
			player = new Objects("Player",mySpace,
				Vec2.weak(screenWidth / 2, screenHeight / 2),
				Vec2.weak(16,32)); //16 = radie, 32 = scalevalue. (Behövs fixas)
			addChild(player);
			
			//The goal
			goal = new Objects("Goal", mySpace,
				Vec2.weak(screenWidth - 150 + tempValue, screenHeight - 150),
				Vec2.weak(32,32));
			addChild(goal);
			
			//Add boxes
			for( var i:int = 0; i < 20; i++ )
			{
				for( var j:int = -1; j < 1; j++ )
				{
					box = new Objects("Box",mySpace,
						Vec2.weak(600 - (j * 16), (screenHeight - 200) - (i * 16)),
						Vec2.weak(16,16));	
					addChild(box);
				}
			}
				
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(20 + tempValue, screenHeight / 2 + 310),
				Vec2.weak(256,256));	
			addChild(stoneBlock);
			
			/*
			water = new Objects("Water",mySpace,
				Vec2.weak(300, screenHeight / 2 + 420),
				Vec2.weak(500,500));	
			addChild(water);
			*/
			
			//The level building blocks. (STATIC objects)  -----------------------------------
			
			
			
			//Middle pillar
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(600 + tempValue, screenHeight - 100),
				Vec2.weak(128,150));	
			addChild(stoneBlock);
			
			//Right wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth + 128 + tempValue, screenHeight / 2),
				Vec2.weak(256 + 128,1300));	
			addChild(stoneBlock);
			
			//Left wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(-128 + tempValue, screenHeight / 2),
				Vec2.weak(256 + 128,1300));	
			addChild(stoneBlock);
			
			//FLOOR
			stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(screenWidth / 2 + tempValue, screenHeight + 128),
					Vec2.weak(960,256 + 128));	
			addChild(stoneBlock);
			
			//Roof
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth / 2 + tempValue, -128),
				Vec2.weak(960,256 + 128));	
			addChild(stoneBlock);
				
			//The menubuttonlan
			toMenu = new Button(Assets.getTexture("buttonPlay"));
			toMenu.scaleX = 0.2;
			toMenu.scaleY = 0.2;
			toMenu.x = 100;
			toMenu.y = 100;
			this.addChild(toMenu);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);			
			
		}
		
		private function updateGraphics( body:Body ):void
		{
			globalFunctions.updateGraphicsGlobal(body, player, new Vec2(screenWidth,screenHeight));
			
		}
		
		private function UpdateWorld( evt:Event ):void
		{
			globalFunctions.UpdateWorldGlobal(evt, mySpace,player, bg,updateGraphics);
			
		}
		
		public function onMainMenuClick():void
		{
			trace("button to mainmenu");
			this.disposeTemporarily();
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,
				{id: "Menu"}, true));	
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