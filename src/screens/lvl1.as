package screens
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
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
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	
	public class lvl1 extends Level
	{				
		public function lvl1()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			InitBodies();
		}
		
					
		private function InitBodies():void
		{	
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
				Vec2.weak(screenWidth - 150 , screenHeight - 150),
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
				
			//The level building blocks. (STATIC objects)  -----------------------------------
			
			//Middle pillar
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(600, screenHeight - 100),
				Vec2.weak(128,150));	
			addChild(stoneBlock);
			
			//Right wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth, screenHeight / 2),
				Vec2.weak(128,640));	
			addChild(stoneBlock);
			
			//Left wall
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(0, screenHeight / 2),
				Vec2.weak(128,640));	
			addChild(stoneBlock);
			
			//FLOOR
			stoneBlock = new Objects("Stone",mySpace,
					Vec2.weak(screenWidth / 2, screenHeight + 128),
					Vec2.weak(960,256 + 128));	
			addChild(stoneBlock);
			
			//Roof
			stoneBlock = new Objects("Stone",mySpace,
				Vec2.weak(screenWidth / 2, 0),
				Vec2.weak(960,128));	
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
				
	}
}