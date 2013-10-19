package screens
{
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
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
	import nape.space.Space;
	
	import objects.GameBackground;
	import objects.Objects;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.display.DisplayObject;
	
	
	
	public class lvl2 extends Sprite implements LevelInterface
	{
		
		private var mySpace:Space;
		private var screenWidth:Number;
		private var screenHeight:Number;
		private var fireBallImage:Image;
		private var xDir:Number = 0;
		private var yDir:Number = 0;
		
		private var bg:GameBackground;
		private var stoneBlock:Objects;
		private var fireball:Objects;
		private var player:Objects;
		private var goal:Objects;
		private var enemy:Objects;
		private var box:Objects;
		
		
		private var r:Number = 0;
		
		
		public function lvl2()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			InitSpace();
			InitBodies();
			
			addEventListener( TouchEvent.TOUCH, touch);
			
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.projectile, globalFunctions.other, hasCollided));
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.projectile, globalFunctions.enemyCb, enemyHit));
		}
		
		public function InitSpace():void
		{
			var worldGravity:Vec2 = Vec2.weak(0,600);
			mySpace = new Space( worldGravity );			
			
			screenWidth = 960;//Starling.current.nativeStage.fullScreenWidth;
			screenHeight = 640;//Starling.current.nativeStage.fullScreenHeight;
		}
		
		
		private function InitBodies():void
		{	
			//Parallax background baby!
			bg = new GameBackground();
			this.addChild(bg);
			
			//The player
			player = new Objects("Player",mySpace,
				Vec2.weak(screenWidth / 2, screenHeight / 2),
				Vec2.weak(16,32)); //16 = radie, 32 = scalevalue. (Behövs fixas)	
			addChild(player);
			
			//The goal
			goal = new Objects("Goal", mySpace,
				Vec2.weak(screenWidth * 2 - 256 , screenHeight - 256),
				Vec2.weak(32,32));
			addChild(goal);
			
			//Add boxes
			for( var i:int = 0; i < 6; i++ )
			{
				for( var j:int = -3; j < 4; j++ )
				{
					box = new Objects("Box",mySpace,
						Vec2.weak((screenWidth / 2) - (j * 8), (screenHeight - 100) - (i * 8)),
						Vec2.weak(8,8));	
					addChild(box);
				}
			}
			
			//The enemy
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak((2.5 * screenWidth)/ 3, screenHeight - 30),
				Vec2.weak(144,120));
			//stage.addChild(enemy);
			
			//The level building blocks. (STATIC objects)  -----------------------------------
			
			//Floor
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth, screenHeight - 20),
				Vec2.weak(960 * 2,128));	
			addChild(stoneBlock);
			
			//Right wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth * 2, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(stoneBlock);
			
			//Left wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(0, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(stoneBlock);
			
			//Roof
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(0, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(stoneBlock);
			
			//Level-buildingblocks
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth * 2 / 3, screenHeight - 128),
				Vec2.weak(128,256));	
			addChild(stoneBlock);
			
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth * 2 / 2, screenHeight / 2),
				Vec2.weak(128,256));	
			addChild(stoneBlock);
			
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth * 2 / 1, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(stoneBlock);
			
		}
		
		
		private function UpdateWorld( evt:Event ):void
		{
			globalFunctions.UpdateWorldGlobal(evt, mySpace,player, bg,updateGraphics);
			
		}
		
		private function touch(e:TouchEvent):void
		{
			globalFunctions.touchGlobal(e, stage,player,mySpace, this);
		}
		
		private function hasCollided(cb:InteractionCallback):void {
			
			globalFunctions.hasCollidedGlobal(cb, mySpace, stage,  this);
		}
		
		private function enemyHit(cb:InteractionCallback):void {
			
			globalFunctions.enemyHitGlobal(cb, mySpace, stage, this);
		}
		
		private function updateGraphics( body:Body ):void
		{
			globalFunctions.updateGraphicsGlobal(body, player, new Vec2(screenWidth,screenHeight));
			
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			removeEventListener(Event.ENTER_FRAME, UpdateWorld );
		}
		
		public function initialize():void
		{
			this.visible = true;
			addEventListener( Event.ENTER_FRAME, UpdateWorld );
		}
		
		public function addObjectToInstance(obj:DisplayObject):void
		{
			this.addChild(obj);
		}
		
		public function removeObjectFromInstance(obj:DisplayObject):void
		{
			this.removeChild(obj);
		}
	}
}