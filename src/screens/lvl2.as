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
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	
	
	public class lvl2 extends Sprite implements LevelInterface
	{
		
		private static var mySpace:Space;
		private static var screenWidth:Number;
		private static var screenHeight:Number;
		private static var fireBallImage:Image;
		private static var xDir:Number = 0;
		private static var yDir:Number = 0;
		
		private static var bg:GameBackground;
		private static var stoneBlock:Objects;
		private static var fireball:Objects;
		private static var player:Objects;
		private static var goal:Objects;
		private static var enemy:Objects;
		private static var box:Objects;
		private static var toMenu:Button;
		
		
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
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.player, globalFunctions.enemyCb, enemyHit));
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, globalFunctions.player, globalFunctions.goal, playerInGoal));
		}
	
		
		public function InitSpace():void
		{
			var worldGravity:Vec2 = Vec2.weak(0,800);
			mySpace = new Space( worldGravity );			
			
			screenWidth = 960;//Starling.current.nativeStage.fullScreenWidth;
			screenHeight = 640;//Starling.current.nativeStage.fullScreenHeight;
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
			
			
			
			goal = new Objects("Goal",mySpace,
				Vec2.weak(1150, screenHeight - 1700),
				Vec2.weak(100,100));
			addChild(goal)
			
			//Add boxes
//			for( var i:int = 0; i < 6; i++ )
//			{
//				for( var j:int = -3; j < 4; j++ )
//				{
//					box = new Objects("Box",mySpace,
//						Vec2.weak((screenWidth / 2) - (j * 8), (screenHeight - 100) - (i * 8)),
//						Vec2.weak(8,8));	
//					addChild(box);
//				}
//			}
			
			//The enemy
//			enemy = new Objects("Enemy",mySpace,
//				Vec2.weak((2.5 * screenWidth)/ 3, screenHeight - 30),
//				Vec2.weak(144,120));
//			addChild(enemy);
			
			//The level building blocks. (STATIC objects)  -----------------------------------
			
			//Floor
			/*
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth, screenHeight - 20),
				Vec2.weak(960 * 3,128));	
			addChild(stoneBlock);
			*/
			
			//Roof
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth + 350, screenHeight-2200),
				Vec2.weak(960 * 3 ,128));	
			addChild(stoneBlock);
			
			//Right wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(2350, screenHeight / 2 - 1010),
				Vec2.weak(100,2460));	
			addChild(stoneBlock);
			
			//Left wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(350, screenHeight / 2 - 1010),
				Vec2.weak(100,2460));	
			addChild(stoneBlock);			
			
			//Floor
			for( var i:int = 0; i < 15; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(450 + 100 * i, screenHeight - 200),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//First steps
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(450 + 100 * i, screenHeight - 400),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}		
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(550 + 100 * i, screenHeight - 700),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}			
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(450 + 100 * i, screenHeight - 1000),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(550 + 100 * i, screenHeight - 1300),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(450 + 100 * i, screenHeight - 1600),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(550 + 100 * i, screenHeight - 1900),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//Pillar
			for( var i:int = 0; i < 18; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(750, screenHeight - 200 - 100 * i),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				//addChild(stoneBlock);
			}
			
			//Pillar 2
			for( var i:int = 0; i < 5; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1050, screenHeight - 200 - 100 * i),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 6; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1150, screenHeight - 200 - 100 * i),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 12; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1050, screenHeight - 200 - 100 * (i+8)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			for( var i:int = 0; i < 2; i++ )
			{
				enemy = new Objects("Enemy",mySpace,
					Vec2.weak(850 + i * 100 ,  screenHeight - 300),
					Vec2.weak(100,100));	
				addChild(enemy);
			}
			
			//Part2 of level
			for( var i:int = 0; i < 12; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1150 + i*100, screenHeight - 800),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 1; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(950 + i*100, screenHeight - 600),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			for( var i:int = 0; i < 10; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1150 + i*100, screenHeight - 1100),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
				for( var i:int = 0; i < 1; i++ )
				{
					stoneBlock = new Objects("Stone",mySpace,
						Vec2.weak(2050, screenHeight - 1200),
						Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
					addChild(stoneBlock);
				}
			for( var i:int = 0; i < 10; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1350 + i*100, screenHeight - 1400),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
				for( var i:int = 0; i < 1; i++ )
				{
					stoneBlock = new Objects("Stone",mySpace,
						Vec2.weak(1350, screenHeight - 1500),
						Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
					addChild(stoneBlock);
				}
			for( var i:int = 0; i < 10; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1150 + i*100, screenHeight - 1700),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
				for( var i:int = 0; i < 1; i++ )
				{
					stoneBlock = new Objects("Stone",mySpace,
						Vec2.weak(2050, screenHeight - 1800),
						Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
					addChild(stoneBlock);
				}

				
					
						
			
			//The menubutton
			toMenu = new Button(Assets.getTexture("buttonPlay"));
			toMenu.scaleX = 0.2;
			toMenu.scaleY = 0.2;
			toMenu.x = 100;
			toMenu.y = 100;
			this.addChild(toMenu);
						
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
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
		
		private function touch(e:TouchEvent):void
		{
			globalFunctions.touchGlobal(e, stage,player,mySpace, this);
		}
		
		private function hasCollided(cb:InteractionCallback):void 
		{
			
			globalFunctions.hasCollidedGlobal(cb, mySpace, stage,  this);
		}
		
		private function enemyHit(cb:InteractionCallback):void
		{
			
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