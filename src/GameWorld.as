package
{
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
	
	
	public class GameWorld extends Sprite
	{
		[Embed(source="../images/CircleBadGuy.png")] private const circleBadGuyRaw:Class;
		private const circleBadGuyBitmap:Bitmap = new circleBadGuyRaw();
		
		[Embed(source="../images/ScaredBox.png")] private const scaredBoxRaw:Class;
		private const scaredBoxBitmap:Bitmap = new scaredBoxRaw();
		
		[Embed(source="../images/Fireball.png")] private const fireBallRaw:Class;
		private const fireBallBitmap:Bitmap = new fireBallRaw();
		
		private var mySpace:Space;
		private var screenWidth:Number;
		private var screenHeight:Number;
		private var circleBadGuyImage:Image;
		private var fireBallImage:Image;
		private var projectile:CbType = new CbType();
		
		private var circleBadGuy:Body;
		
		private var xDir:Number;
		private var yDir:Number;
		
		public function GameWorld()
		{
			addEventListener( Event.ADDED_TO_STAGE, onInit );
			super();
		}
		
		private function onInit(evt:Event):void
		{
			InitSpace();
			InitBodies();
			
			addEventListener( Event.ENTER_FRAME, UpdateWorld );
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
			circleBadGuyImage = Image.fromBitmap( circleBadGuyBitmap, false );
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
				var fireBallImage:Image = Image.fromBitmap(fireBallBitmap);
				
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
		
		

	}
}