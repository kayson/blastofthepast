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
		private var scaredBox:Body;
		private var circleBadGuy:Body;
		private var xDir:Number;
		private var yDir:Number;

				
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
			
			mySpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, projectile, projectile, hasCollided));
			
		
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
			
			circleBadGuyImage = new Image(Assets.getTexture((("circleBadGuyRaw"))));
			circleBadGuyImage.pivotX = circleBadGuyImage.width / 2;
			circleBadGuyImage.pivotY = circleBadGuyImage.height / 2;
			circleBadGuyImage.scaleX = 0.5;
			circleBadGuyImage.scaleY = 0.5;		
			
			circleBadGuy = new Body( BodyType.DYNAMIC );
			circleBadGuy.shapes.add( new Circle( 32 ) );
			circleBadGuy.position.setxy(screenWidth / 2, 0);
			circleBadGuy.setShapeMaterials( Material.steel() );
			circleBadGuy.userData.graphic = circleBadGuyImage;
			circleBadGuy.space = mySpace;
			
			circleBadGuy.setShapeFilters(new InteractionFilter(1));
			
			circleBadGuyImage.x = circleBadGuy.position.x;
			circleBadGuyImage.y = circleBadGuy.position.y;
			addChild(circleBadGuyImage);
			
			
			
			scaredBoxImage = new Image(Assets.getTexture((("scaredBoxRaw"))));
			scaredBoxImage.pivotX = scaredBoxImage.width / 2;
			scaredBoxImage.pivotY = scaredBoxImage.height / 2;
			
			
			scaredBox = new Body( BodyType.DYNAMIC );
			scaredBox.shapes.add( new Polygon( Polygon.box(32,32)) );
			scaredBox.position.setxy(700 , 50);
			
			scaredBox.setShapeFilters(new InteractionFilter(2));
			
			scaredBox.userData.graphic = scaredBoxImage;
			scaredBox.space = mySpace;
			scaredBox.gravMass = 0;
			
			scaredBoxImage.x = scaredBox.position.x;
			scaredBoxImage.y = scaredBox.position.y;
			addChild(scaredBoxImage);
			
			
			
			
			var floor:Body = new Body( BodyType.STATIC );
			floor.shapes.add( new Polygon(Polygon.rect(0,screenHeight - 20, screenWidth, 20)) );
			floor.space = mySpace;
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
			}
			
			if(touch.phase == TouchPhase.ENDED) //on finger up
			{	
				var shootDir:Vec2 = Vec2.get(1*(touch.globalX-xDir),1*(touch.globalY-yDir));
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
			var b:Body = cb.int2 as Body;
			
			trace("COLLIDE");
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