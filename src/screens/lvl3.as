package screens
{
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
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	
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
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.player, globalFunctions.enemyCb, enemyHit));
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
			//Parallax background baby!
			bg = new GameBackground();
			//bg.scaleX = 2;
			//bg.scaleY = 2;	
			this.addChild(bg);
			
			//The player
			player = new Objects("Player",mySpace,
				Vec2.weak(screenWidth / 2, screenHeight / 2),
				Vec2.weak(25,50)); //25 = radie, 50 = scalevalue. (Behövs fixas)	
			addChild(player);
			
			//Goal
			goal = new Objects("Goal",mySpace,
				Vec2.weak(2350, screenHeight - 300),
				Vec2.weak(100,100));
			addChild(goal);
			
			//Roof
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth + 350, screenHeight-2200),
				Vec2.weak(960 * 3 ,128));	
			addChild(stoneBlock);
			
			//Right wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(2450, screenHeight / 2 - 1010),
				Vec2.weak(100,2460));	
			addChild(stoneBlock);
			
			//Left wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(350, screenHeight / 2 - 1010),
				Vec2.weak(100,2460));	
			addChild(stoneBlock);			
			
			//Floor
			for( var i:int = 0; i < 20; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(450 + 100 * i, screenHeight - 200),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//BOXESFLOOR
			for( var i:int = 0; i < 2; i++ )
			{
				for( var j:int = -1; j < 3; j++ )
				{
					stoneBlock = new Objects("Stone",mySpace,
						Vec2.weak((1050) - (j * 100), (screenHeight - 300) - (i * 100)),
						Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
					addChild(stoneBlock);
				}
			}
			
			//Midpillar
			for( var i:int = 0; i < 10; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1250, screenHeight - 300 - 100 * i),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//BOXESFLOOR
			for( var i:int = 0; i < 3; i++ )
			{
				for( var j:int = -1; j < 3; j++ )
				{
					stoneBlock = new Objects("Stone",mySpace,
						Vec2.weak((650) - (j * 100), (screenHeight - 700) - (i * 100)),
						Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
					addChild(stoneBlock);
				}
			}
	
			
			//Mid roof
			for( var i:int = 0; i < 11; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(950 + 100 * i, screenHeight - 1300),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//ENEMY LEFT TOP
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(850,  screenHeight - 1300),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			//ENEMY RIGHT TOP
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(2050,  screenHeight - 1300),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			
			//RIGHT SIDE
			//Left floor
			for( var i:int = 0; i < 7; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(2350 - 100 * i, screenHeight - 700),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//ENEMY RIGHT 1
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(1750,  screenHeight - 1200),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			//ENEMY RIGHT 2
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(1750,  screenHeight - 1080),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			//ENEMY RIGHT 3
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(1750,  screenHeight - 800),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			
			
			
			//Extra for map
			/*
			//ENEMY
			for( var i:int = 0; i < 2; i++ )
			{
				enemy = new Objects("Enemy",mySpace,
					Vec2.weak(2000 + i * 100 ,  screenHeight - 300),
					Vec2.weak(100,100));	
				addChild(enemy);
			}
			
			//WATER
			water = new Objects("Water",mySpace,
				Vec2.weak(1400, screenHeight - 275),
				Vec2.weak(450,50));	
			addChild(water);
			
			//BOXES
			//Add boxes
			for( var i:int = 0; i < 8; i++ )
			{
				for( var j:int = -2; j < 3; j++ )
				{
					box = new Objects("Box",mySpace,
						Vec2.weak((650) - (j * 16), (screenHeight - 300) - (i * 16)),
						Vec2.weak(16,16));	
					addChild(box);
				}
			}
			
			//Add boxes
			for( var i:int = 0; i < 8; i++ )
			{
				for( var j:int = -1; j < 2; j++ )
				{
					box = new Objects("Box",mySpace,
						Vec2.weak((750) - (j * 32), (screenHeight - 300) - (i * 32)),
						Vec2.weak(32,32));	
					addChild(box);
				}
			}
			
			*/
			
			
			
			
			//First steps
			/*for( var i:int = 0; i < 2; i++ )
			{
			stoneBlock = new Objects("Stone",mySpace,
			Vec2.weak(450 + 100 * i, screenHeight - 400),
			Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
			addChild(stoneBlock);
			}		
			*/
			
			
			
			//The menubutton
			toMenu = new Button(Assets.getTexture("buttonPlay"));
			toMenu.scaleX = 0.5;
			toMenu.scaleY = 0.5;
			toMenu.x = 880;
			toMenu.y = 570;
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
		
		public function getPlayer():Objects
		{
			return player;
		}
				
	}
}