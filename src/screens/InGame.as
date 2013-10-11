package screens
{
	import events.NavigationEvent;
	
	import flash.display.Bitmap;
	
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
	import objects.StaticObjects;
	
	import starling.core.Starling;
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
		private var circleBadGuyImage:Image;
		private var fireBallImage:Image;
		private var scaredBoxImage:Image;
		private var projectile:CbType = new CbType();
		private var other:CbType = new CbType();
		private var scaredBox:Body;
		private var circleBadGuy:Body;
		private var xDir:Number = 0;
		private var yDir:Number = 0;
		
		private var bg:GameBackground;
		private var floor:StaticObjects;

				
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
			
			addEventListener( TouchEvent.TOUCH, touch );
			
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
			bg.speed = 10;
			this.addChild(bg);
			
			// Initialize objects etc
			
			circleBadGuyImage = new Image(Assets.getTexture((("circleBadGuyRaw"))));
			circleBadGuyImage.pivotX = circleBadGuyImage.width / 2;
			circleBadGuyImage.pivotY = circleBadGuyImage.height / 2;
			circleBadGuyImage.scaleX = 0.5;
			circleBadGuyImage.scaleY = 0.5;		
			
			circleBadGuy = new Body( BodyType.DYNAMIC );
			circleBadGuy.shapes.add( new Circle( 32 ) );
			circleBadGuy.position.setxy(screenWidth / 2, 0);
			circleBadGuy.setShapeMaterials( Material.rubber() );
			circleBadGuy.userData.graphic = circleBadGuyImage;
			circleBadGuy.space = mySpace;		
			circleBadGuy.cbTypes.add(other);
			circleBadGuy.mass = 0.5;
			

			circleBadGuy.setShapeFilters(new InteractionFilter(1));
			
			circleBadGuyImage.x = circleBadGuy.position.x;
			circleBadGuyImage.y = circleBadGuy.position.y;
			addChild(circleBadGuyImage);
			
			for( var i:int = 0; i < 6; i++ )
			{
				for( var j:int = -3; j < 4; j++ )
				{
					var scaredBox:Body = new Body( BodyType.DYNAMIC );
					var scaredBoxImage:Image =  new Image(Assets.getTexture((("scaredBoxRaw"))));
					
					scaredBoxImage.pivotX = scaredBoxImage.width / 2;
					scaredBoxImage.pivotY = scaredBoxImage.height / 2;
					scaredBoxImage.scaleX = 0.5;
					scaredBoxImage.scaleY = 0.5;
				
					
					scaredBox.shapes.add( new Polygon( Polygon.box(16,16) ) );
					scaredBox.position.setxy( (screenWidth / 2) - (j * 16), (screenHeight - 100) - (i * 16) );
					scaredBox.userData.graphic = scaredBoxImage;
					scaredBox.space = mySpace;
					
					scaredBox.setShapeFilters(new InteractionFilter(2));
					
					scaredBox.cbTypes.add(other);
					
					scaredBoxImage.x = scaredBox.position.x;
					scaredBoxImage.y = scaredBox.position.y;
					addChild(scaredBoxImage);
				}
			}
						
			//Detta har Anders gjort , temporärt lite grötigt bara för att få upp lite hinder etc.
			
			//The level building blocks. (STATIC objects)  -----------------------------------
			
			floor = new StaticObjects("Stone",mySpace,other,
					Vec2.weak(screenWidth / 2, screenHeight - 20),
					Vec2.weak(960,128));	
			addChild(floor);
			
			floor = new StaticObjects("Stone",mySpace,other,
				Vec2.weak(screenWidth, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(floor);
			
			floor = new StaticObjects("Stone",mySpace,other,
				Vec2.weak(0, screenHeight / 2),
				Vec2.weak(128,960));	
			addChild(floor);
	
		}
		
		
		
		private function UpdateWorld( evt:Event ):void
		{
			mySpace.step( 1 / 60 );
			
			mySpace.liveBodies.foreach( updateGraphics );
		}
		
		private function touch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch.phase == TouchPhase.BEGAN)//on finger down
			{
				trace("BEGIN");
				xDir = touch.globalX;
				yDir = touch.globalY;
			}else if(touch.phase == TouchPhase.ENDED) //on finger up
			{	
				var shootDir:Vec2 = Vec2.get(-1*(touch.globalX-xDir),-1*(touch.globalY-yDir));
				if(shootDir.length != 0)
					shootDir = shootDir.normalise();
				
				shootDir.x *= 100;
				shootDir.y *= 100;
				
				var fireBall:Body = new Body( BodyType.DYNAMIC );
				var fireBallImage:Image = new Image(Assets.getTexture((("fireBallRaw"))));
				
				fireBallImage.pivotX = fireBallImage.width / 2;
				fireBallImage.pivotY = fireBallImage.height / 2;
				fireBallImage.scaleX = 16/648;
				fireBallImage.scaleY = 16/648;
				
				fireBall.shapes.add( new Polygon( Polygon.box(16,16) ) );		
				fireBall.position.setxy( xDir, yDir );
				
				fireBall.userData.graphic = fireBallImage;
				fireBall.space = mySpace;
				fireBall.gravMass = 0;
				fireBall.setShapeFilters(new InteractionFilter(1,~1));
				fireBall.rotation = shootDir.angle;
				
				fireBallImage.x = circleBadGuy.position.x;
				fireBallImage.y = circleBadGuy.position.y;
				addChild(fireBallImage);
				
				fireBall.applyImpulse(shootDir);			
				
				fireBall.cbTypes.add(projectile);
				
			}
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
				}
			}
		}

		private function updateGraphics( body:Body ):void
		{
			var graphic:Image = body.userData.graphic;
			graphic.x = body.position.x;
			graphic.y = body.position.y;
			
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