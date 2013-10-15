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
		private var _objectBody:Body;
		private var _objectImage:Image;
		
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
				case "Fireball":
					trace("Fireball created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageFireball);
					break;
				case "Stone":
					trace("Stone created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
				break;
				case "Box":
					trace("Box created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageBox);
				break;
				case "Player": //Skulle vara bra med en singleton
					trace("Player created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStagePlayer);
					break;
			}
				
		}
		
		private function onAddedToStagePlayer(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStagePlayer);

			_objectImage = new Image(Assets.getTexture((("circleBadGuyRaw"))));
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.y / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
			
			_objectBody = new Body( BodyType.DYNAMIC );
			
			_objectBody.shapes.add( new Circle(_WidthHeight.x));
			_objectBody.setShapeFilters(new InteractionFilter(1));
			_objectBody.cbTypes.add(_cbType);
			
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.rubber() );
			_objectBody.userData.graphic = _objectImage;
			_objectBody.mass = 0.5;
			
			_objectBody.space = _mySpace;
			
			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			
			addChild(_objectImage);
			
		}
		
		private function onAddedToStageFireball(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStagePlayer);
			
			_objectImage = new Image(Assets.getTexture((("fireBallRaw"))));
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX =  8/648;//_WidthHeight.y / _objectImage.width;
			_objectImage.scaleY =  8/648;//_WidthHeight.y / _objectImage.height;
			
			_objectBody = new Body( BodyType.DYNAMIC );
			
			_objectBody.shapes.add( new Polygon(Polygon.box(_WidthHeight.x, _WidthHeight.y)));
			_objectBody.setShapeFilters(new InteractionFilter(1,~1));
			_objectBody.cbTypes.add(_cbType);
			
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.rubber() );
			_objectBody.userData.graphic = _objectImage;
			_objectBody.gravMass = 0.0;
			
			_objectBody.space = _mySpace;
			
			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			
			addChild(_objectImage);
			
		}
		
		private function onAddedToStageStone(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
			
			//The level building blocks.  -----------------------------------
			
			_objectImage = new Image(Assets.getTexture((("stoneBlock"))));
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.x / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
			
			_objectBody = new Body( BodyType.STATIC );
			
			_objectBody.shapes.add( new Polygon(Polygon.box(_WidthHeight.x, _WidthHeight.y)));
			_objectBody.setShapeFilters(new InteractionFilter(2));
			_objectBody.cbTypes.add(_cbType);
				
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.steel() );
			_objectBody.userData.graphic = _objectImage;

			_objectBody.space = _mySpace;

			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;

			addChild(_objectImage);

		}
		
		private function onAddedToStageBox(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageStone);
		
			_objectBody = new Body( BodyType.DYNAMIC );
			_objectImage =  new Image(Assets.getTexture((("scaredBoxRaw"))));
			
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.x / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
			
			_objectBody.shapes.add( new Polygon( Polygon.box(_WidthHeight.x, _WidthHeight.y) ) );
			_objectBody.position.setxy( _position.x, _position.y );
			_objectBody.setShapeMaterials( Material.steel() );
			_objectBody.userData.graphic = _objectImage;
			_objectBody.space = _mySpace;
			
			_objectBody.setShapeFilters(new InteractionFilter(2));
			
			_objectBody.cbTypes.add(_cbType);
			
			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			addChild(_objectImage);
		
		}
		
		public function getBody():Body
		{
			return _objectBody;
		}
		
		public function getImage():Image
		{
			return _objectImage;
		}
	}
}