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
	
	
	public class lvl4 extends Sprite implements LevelInterface
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
		
		public function lvl4()
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
			this.addChildAt(bg,0);
			
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
			
			
			//SNE FLOOR R
			for( var i:int = 0; i < 10; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1050 + (70 * i), screenHeight - 250 - (70 * i)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
				addChild(stoneBlock);
				if(stoneBlock.getBody())
					stoneBlock.setBodyRotation(-Math.PI/4);
			}
			
			//Midpillar
			for( var i:int = 0; i < 9; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1700, screenHeight - 900 - 100 * i),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//WATER(BOOST UP)
			water = new Objects("WaterGravity",mySpace,
				Vec2.weak(1550, screenHeight - 1525),
				Vec2.weak(200,650));	
			addChildAt(water, 1);
			
			//SNE FLOOR OVER WATER
			for( var i:int = 0; i < 6; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1425 + (70 * i), screenHeight - 1800 - (70 * i)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
				addChildAt(stoneBlock,2);
				if(stoneBlock.getBody())
					stoneBlock.setBodyRotation(-Math.PI/4);
			}
			
			//Floor
			for( var i:int = 0; i < 20; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(450 + 100 * i, screenHeight - 200),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			

			
			//SNE FLOOR L
			for( var i:int = 0; i < 6; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(750 - (70 * i), screenHeight - 600 - (70 * i)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
				addChildAt(stoneBlock,1);
				if(stoneBlock.getBody())
					stoneBlock.setBodyRotation(Math.PI/4);
			}
			
			//SNE FLOOR L
			for( var i:int = 0; i < 9; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(850 - (70 * i), screenHeight - 1100 - (70 * i)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
				addChildAt(stoneBlock,1);
				if(stoneBlock.getBody())
					stoneBlock.setBodyRotation(Math.PI/4);
			}
			
			//Mid roof
			for( var i:int = 0; i < 5; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1800 + 100 * i, screenHeight - 1700),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));	
				addChild(stoneBlock);
			}
			
			//Add boxes
			for( var i:int = 0; i < 8; i++ )
			{
				for( var j:int = -1; j < 2; j++ )
				{
					box = new Objects("Box",mySpace,
						Vec2.weak((2000) - (j * 32), (screenHeight - 1800) - (i * 32)),
						Vec2.weak(32,32));	
					addChild(box);
				}
			}
			
			//RIGHT SIDE OF MAP
			//SNE FLOOR
			for( var i:int = 0; i < 2; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(2400 - (70 * i), screenHeight - 1600 + (70 * i)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
				addChildAt(stoneBlock,2);
				if(stoneBlock.getBody())
					stoneBlock.setBodyRotation(-Math.PI/4);
			}
			
			//ENEMY RIGHT TOP
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(2275,  screenHeight - 1375),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			//ENEMY RIGHT TOP
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(2175,  screenHeight - 1275),
				Vec2.weak(100,100));	
			addChild(enemy);

			//ENEMY RIGHT TOP
			enemy = new Objects("Enemy",mySpace,
				Vec2.weak(2050,  screenHeight - 1175),
				Vec2.weak(100,100));	
			addChild(enemy);
			
			//Stopping boxes
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(1950, screenHeight - 1200),
				Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
			addChildAt(stoneBlock,2);
			if(stoneBlock.getBody())
				stoneBlock.setBodyRotation(Math.PI/4);
			
			//SNE FLOOR L
			for( var i:int = 0; i < 6; i++ )
			{
				stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(1700 + (70 * i), screenHeight - 900 + (70 * i)),
					Vec2.weak(100,100), "Dirt" + (Math.ceil(Math.random()*5)-1));
				addChildAt(stoneBlock,1);
				if(stoneBlock.getBody())
					stoneBlock.setBodyRotation(Math.PI/4);
			}
			
			
			
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