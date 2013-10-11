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
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;

	
	public class Objects extends Sprite
	{
		private var screenWidth:Number = 960;
		private var screenHeight:Number= 640;
		private var _mySpace:Space;
		private var _cbType:CbType;
		private var _position:Vec2;
		private var _WidthHeight:Vec2;
		
		//private var _type:String;

		private var _speed:Number = 0;
		
		public function Objects(type:String,mySpace:Space,cbType:CbType,position:Vec2,wh:Vec2 )
		{
			super();
			//Koppla till de lokala variablerna
			_mySpace 	= mySpace;
			_cbType		= cbType;
			_position	= position;
			_WidthHeight= wh;

			switch(type)	
			{
				case "Stone":
					trace("Stone created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
				break;
				case "Box":
					trace("Box created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageBox);
				break;
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
			
			var floor:Body = new Body( BodyType.STATIC );
			
			floor.shapes.add( new Polygon(Polygon.box(_WidthHeight.x, _WidthHeight.y)));
			floor.setShapeFilters(new InteractionFilter(2));
			floor.cbTypes.add(_cbType);
				
			floor.position.setxy(_position.x, _position.y);
			floor.setShapeMaterials( Material.steel() );
			floor.userData.graphic = stoneImage;

			floor.space = _mySpace;

			stoneImage.x = floor.position.x;
			stoneImage.y = floor.position.y;

			addChild(stoneImage);

		}
		
		private function onAddedToStageBox(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
		
			var scaredBox:Body = new Body( BodyType.DYNAMIC );
			var scaredBoxImage:Image =  new Image(Assets.getTexture((("scaredBoxRaw"))));
			
			scaredBoxImage.pivotX = scaredBoxImage.width / 2;
			scaredBoxImage.pivotY = scaredBoxImage.height / 2;
			scaredBoxImage.scaleX = _WidthHeight.x / scaredBoxImage.width;
			scaredBoxImage.scaleY = _WidthHeight.y / scaredBoxImage.height;
			
			scaredBox.shapes.add( new Polygon( Polygon.box(_WidthHeight.x, _WidthHeight.y) ) );
			scaredBox.position.setxy( _position.x, _position.y );
			scaredBox.setShapeMaterials( Material.steel() );
			scaredBox.userData.graphic = scaredBoxImage;
			scaredBox.space = _mySpace;
			
			scaredBox.setShapeFilters(new InteractionFilter(2));
			
			scaredBox.cbTypes.add(_cbType);
			
			scaredBoxImage.x = scaredBox.position.x;
			scaredBoxImage.y = scaredBox.position.y;
			addChild(scaredBoxImage);
		
		}
	}
}