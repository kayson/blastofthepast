package screens
{
	import events.NavigationEvent;
	
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
		private var scaredBoxImage:Image;
				
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
			circleBadGuyImage = new Image(Assets.getTexture((("circleBadGuyRaw"))));
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
			
			
			var floorImage:Image = new Image(Assets.getTexture((("scaredBoxRaw"))));
			
			floorImage.pivotX = floorImage.width / 2;
			floorImage.pivotY = floorImage.height / 2;
			
			var staticStone:Body = new Body( BodyType.STATIC );
			staticStone.shapes.add(new Polygon( Polygon.rect(0,screenHeight - 50, screenWidth, 20)));
			//staticStone.position.setxy( 0, screenHeight - 50  );
			
			floorImage.scaleX = 100;
			
			
			staticStone.userData.graphic = floorImage;
			staticStone.space = mySpace;
			
			floorImage.x = 0;
			floorImage.y = screenHeight - 50;
			addChild(floorImage);
			
			
			
			for( var i:int = 0; i < 6; i++ )
			{
				for( var j:int = -3; j < 3; j++ )
				{
					var scaredBox:Body = new Body( BodyType.DYNAMIC );
					var scaredBoxImage:Image = new Image(Assets.getTexture((("scaredBoxRaw"))));
					
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
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			removeEventListener(Event.ENTER_FRAME, UpdateWorld );
		}
		
		public function initialize():void
		{
			this.visible = true;
			addEventListener( Event.ENTER_FRAME, UpdateWorld );
			stage.addEventListener(TouchEvent.TOUCH, touch);
		}
	}
}