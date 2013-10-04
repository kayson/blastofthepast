package
{
	import flash.display.Bitmap;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;

	//touchevents
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Event;
	
	
	public class GameWorld extends Sprite
	{
		[Embed(source="../images/CircleBadGuy.png")] private const circleBadGuyRaw:Class;
		private const circleBadGuyBitmap:Bitmap = new circleBadGuyRaw();
		
		[Embed(source="../images/ScaredBox.png")] private const scaredBoxRaw:Class;
		private const scaredBoxBitmap:Bitmap = new scaredBoxRaw();
		
		private var mySpace:Space;
		private var screenWidth:Number;
		private var screenHeight:Number;
		private var circleBadGuyImage:Image;
		private var scaredBoxImage:Image;
		
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
			stage.addEventListener(TouchEvent.TOUCH, touch);
		}		
		
		
		private function InitSpace():void
		{
			var worldGravity:Vec2 = Vec2.weak(0,500);
			mySpace = new Space( worldGravity );
			
			screenWidth = 960;//Starling.current.nativeStage.fullScreenWidth;
			screenHeight = 640;//Starling.current.nativeStage.fullScreenHeight;

		}
		
		
		private function InitBodies():void
		{	
			circleBadGuyImage = Image.fromBitmap( circleBadGuyBitmap, false );
			circleBadGuyImage.pivotX = circleBadGuyImage.width / 2;
			circleBadGuyImage.pivotY = circleBadGuyImage.height / 2;
			
			var circleBadGuy:Body = new Body( BodyType.DYNAMIC );
			circleBadGuy.shapes.add( new Circle( 64 ) );
			circleBadGuy.position.setxy(screenWidth / 2, 0);
			circleBadGuy.setShapeMaterials( Material.steel() );
			circleBadGuy.userData.graphic = circleBadGuyImage;
			circleBadGuy.space = mySpace;
			
			circleBadGuyImage.x = circleBadGuy.position.x;
			circleBadGuyImage.y = circleBadGuy.position.y;
			addChild(circleBadGuyImage);
			
			var floor:Body = new Body( BodyType.STATIC );
			floor.shapes.add( new Polygon(Polygon.rect(0,screenHeight - 20, screenWidth, 20)) );
			floor.space = mySpace;
			
			
			
			for( var i:int = 0; i < 6; i++ )
			{
				for( var j:int = -3; j < 4; j++ )
				{
					var scaredBox:Body = new Body( BodyType.DYNAMIC );
					var scaredBoxImage:Image = Image.fromBitmap( scaredBoxBitmap );
					
					scaredBoxImage.pivotX = scaredBoxImage.width / 2;
					scaredBoxImage.pivotY = scaredBoxImage.height / 2;
					
					scaredBox.shapes.add( new Polygon( Polygon.box(32,32) ) );
					scaredBox.position.setxy( (screenWidth / 2) - (j * 32), (screenHeight - 20) - (i * 32) );

					scaredBox.userData.graphic = scaredBoxImage;
					scaredBox.space = mySpace;
					
					scaredBoxImage.x = scaredBox.position.x;
					scaredBoxImage.y = scaredBox.position.y;
					addChild(scaredBoxImage);
				}
			}
			
		}
		
		
		private function UpdateWorld( evt:Event ):void
		{
			mySpace.step( 1 / 60 );
			
			mySpace.liveBodies.foreach( updateGraphics );
		}
		
		private function touch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				mySpace.liveBodies.at(0).position.setxy(screenWidth / 2, 0);
			}
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