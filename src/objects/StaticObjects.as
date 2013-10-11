package objects
{
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
	
	public class StaticObjects extends Sprite
	{
		
		private var bgLayer1:BgLayer;
		private var screenWidth:Number = 960;
		private var screenHeight:Number= 640;
		private var _mySpace:Space;
		private var _cbStatic:CbType;
		private var _position:Vec2;
		private var _WidthHeight:Vec2;
		
		//private var _type:String;

		private var _speed:Number = 0;
		
		public function StaticObjects(type:String,mySpace:Space,cbStatic:CbType,position:Vec2,wh:Vec2 )
		{
			super();
			//Koppla till de lokala variablerna
			_mySpace 	= mySpace;
			_cbStatic	= cbStatic;
			_position	= position;
			_WidthHeight= wh;
			
			//kanske fixa så det inte kan bli fel här.
			if(type == "Stone")
			{
				trace("Stone created");
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
			}
				
		}
		
		private function onAddedToStageStone(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
			
			//The level building blocks.  -----------------------------------
			
			var stoneImage:Image;
			stoneImage = new Image(Assets.getTexture((("stoneBlock"))));
			stoneImage.pivotX = stoneImage.width / 2;
			stoneImage.pivotY = stoneImage.height / 2;
			stoneImage.scaleX = _WidthHeight.x / stoneImage.width;
			stoneImage.scaleY = _WidthHeight.y / stoneImage.height;
			//stoneImage.width = screenWidth;
			//stoneImage.height = 20;
			
			var floor:Body = new Body( BodyType.STATIC );
			
			floor.shapes.add( new Polygon(Polygon.box(_WidthHeight.x, _WidthHeight.y)));
			floor.setShapeFilters(new InteractionFilter(2));
			floor.cbTypes.add(_cbStatic);
				
			floor.position.setxy(_position.x, _position.y);
			//floor.setShapeMaterials( Material.steel() );
			floor.userData.graphic = stoneImage;

			floor.space = _mySpace;

			stoneImage.x = floor.position.x;
			stoneImage.y = floor.position.y;

			addChild(stoneImage);

			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			bgLayer1.x -= Math.ceil(_speed * bgLayer1.parallax);
			if (bgLayer1.x < -stage.stageWidth) bgLayer1.x = 0;
			

		}
		
		public function get position():Number
		{
			return _speed;
		}
		
		public function set positionX(xy:Vec2):void
		{
			//this.position.setxy(
		}
		
		public function set positionY(y:Number):void
		{
			//_speed = value;
		}
		
		
	}
}