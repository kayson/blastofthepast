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


	
	public class InGame extends Sprite
	{
		
		private var mySpace:Space;
		private var screenWidth:Number;
		private var screenHeight:Number;
		private var fireBallImage:Image;
		private var projectile:CbType = new CbType();
		private var other:CbType = new CbType();
		private var xDir:Number = 0;
		private var yDir:Number = 0;
		
		private var bg:GameBackground;
		private var floor:Objects;
		private var fireball:Objects;
		private var player:Objects;
		private var box:Objects;
		

		private var r:Number = 0;

				
		public function InGame()
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
			
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, projectile, other, hasCollided));	
		}
		
		private function InitSpace():void
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
			player = new Objects("Player",mySpace,other,
				Vec2.weak(screenWidth / 2, screenHeight / 2),
				Vec2.weak(16,32)); //16 = radie, 32 = scalevalue. (Behövs fixas)	
			addChild(player);

			//Add boxes
			for( var i:int = 0; i < 6; i++ )
			{
				for( var j:int = -3; j < 4; j++ )
				{
					box = new Objects("Box",mySpace,other,
						Vec2.weak((screenWidth / 2) - (j * 8), (screenHeight - 100) - (i * 8)),
						Vec2.weak(8,8));	
					addChild(box);
				}
			}
							
			//The level building blocks. (STATIC objects)  -----------------------------------
			
			floor = new Objects("Stone",mySpace,other,
					Vec2.weak(screenWidth / 2, screenHeight - 20),
					Vec2.weak(960,128));	
			addChild(floor);
			
			floor = new Objects("Stone",mySpace,other,
				Vec2.weak(screenWidth, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(floor);
			
			floor = new Objects("Stone",mySpace,other,
				Vec2.weak(0, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(floor);
	
		}
		
		
		
		private function UpdateWorld( evt:Event ):void
		{
			mySpace.step( 1 / 60 );		
			mySpace.bodies.foreach( updateGraphics );
			
			bg.bgPosition(player.getBody().position);
		}
		
		private function touch(e:TouchEvent):void
		{
			globalFunctions.touchGlobal(e, stage,player,mySpace,projectile);
		}
		
		private function hasCollided(cb:InteractionCallback):void {
			
			var a:Body = cb.int1 as Body;
			var explosionPos:Vec2 = a.position;
			for(var i:int = 0; i < mySpace.liveBodies.length; i++)
			{		
				var b:Body = mySpace.liveBodies.at(i);
				var bodyPos:Vec2 = b.position;
				var impulseVector:Vec2 = new Vec2(bodyPos.x-explosionPos.x, bodyPos.y-explosionPos.y);
				if(b.cbTypes.has(other) && impulseVector.length < 400)
				{
					var impulseForce:Number = Math.log((400-impulseVector.length)/80 + 1)*80;
					var impulse:Vec2 = impulseVector.mul(impulseForce/impulseVector.length);
					b.applyImpulse(impulse);
					stage.removeChild(a.userData.graphic.parent);
					mySpace.bodies.remove(a);
				}
			}
		}

		private function updateGraphics( body:Body ):void
		{
			var graphic:Image = body.userData.graphic;
			//graphic.x = body.position.x;
			//Circlebadguy är här spelaren
			//Man kan lägga in ett krav som kollar 
			//mot golv och väggar och så
			//Avsluta funktionen.
			if(body != player.getBody())
			{
				graphic.y = body.position.y + (screenHeight / 2) - player.getBody().position.y;
				graphic.x = body.position.x + (screenWidth / 2) - player.getBody().position.x;
			}
			
			graphic.rotation = body.rotation;
			

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
			//stage.addEventListener(TouchEvent.TOUCH, touch);
		}
	}
}