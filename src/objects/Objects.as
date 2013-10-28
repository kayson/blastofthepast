package objects
{
	import nape.callbacks.CbType;
	import nape.constraint.Constraint;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	

	
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
		private var _objectsMovieClip:MovieClip;
		
		private var animationState:int;
		private var _playerIdleMovie:MovieClip;
		private var _playerShootMovie:MovieClip;
		private var _playerInairMovie:MovieClip;
		private var movieVector:Vector.<MovieClip>;
		private static const IDLE_MOVIE:int = 0;
		private static const IN_AIR_MOVIE:int = 1;
		private static const SHOOT_MOVIE:int = 2;
		
		//private var _type:String;

		private var _speed:Number = 0;
		
		public function Objects(type:String,mySpace:Space,position:Vec2,wh:Vec2 )
		{
			super();
			//Koppla till de lokala variablerna
			_mySpace 	= mySpace;
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
				case "Enemy":
					trace("Enemy created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageEnemy);
					break;
				case "Box":
					trace("Box created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageBox);
				break;
				case "Player": //Skulle vara bra med en singleton
					trace("Player created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStagePlayer);
					break;
				case "Goal": //Skulle vara bra med en singleton
					trace("Goal created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageGoal);
					break;
				case "Water":
					trace("Water created ");
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageWater);
					break;
				
			}
				
		}
		
		private function onAddedToStageGoal(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageGoal);
			
			_objectImage = new Image(Assets.getTexture((("goalRaw"))));
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.x / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
			
			_objectBody = new Body( BodyType.STATIC );
			
			_objectBody.shapes.add( new Polygon(Polygon.box(_WidthHeight.x, _WidthHeight.y)));
			_objectBody.setShapeFilters(new InteractionFilter(2));
			_objectBody.cbTypes.add(globalFunctions.goal);
			
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.steel() );
			_objectBody.userData.graphic = _objectImage;
			
			_objectBody.space = _mySpace;
			
			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			
			addChild(_objectImage);
			
			
		}
		
		private function onAddedToStagePlayer(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStagePlayer);

			_playerIdleMovie = new MovieClip(Assets.getAtlas().getTextures("Tween 1 instance 10000"), 1);
			animationState = IDLE_MOVIE;
			
			_playerInairMovie = new MovieClip(Assets.getAtlas().getTextures("Tween 1"), 30);
			
			_playerIdleMovie.pivotX = _playerIdleMovie.width / 2;
			_playerIdleMovie.pivotY = _playerIdleMovie.height / 2;
			_playerIdleMovie.scaleX = _WidthHeight.y / _playerIdleMovie.width;
			_playerIdleMovie.scaleY = _WidthHeight.y / _playerIdleMovie.height;
			
			
			_playerInairMovie.pivotX = _playerInairMovie.width / 2;
			_playerInairMovie.pivotY = _playerInairMovie.height / 2;
			_playerInairMovie.scaleX = _WidthHeight.y / _playerInairMovie.width;
			_playerInairMovie.scaleY = _WidthHeight.y / _playerInairMovie.height;
			
			
			_objectBody = new Body( BodyType.DYNAMIC );
			
			_objectBody.shapes.add( new Circle(_WidthHeight.x));
			_objectBody.setShapeFilters(new InteractionFilter(1));
			_objectBody.cbTypes.add(globalFunctions.player);
			
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.rubber() );
			_objectBody.userData.graphic = _playerIdleMovie;
			_objectBody.mass = 0.5;
			
			_objectBody.space = _mySpace;
			
			_playerIdleMovie.x = _objectBody.position.x;
			_playerIdleMovie.y = _objectBody.position.y;
			
			movieVector = new Vector.<MovieClip>();
			movieVector[IDLE_MOVIE] = _playerIdleMovie;
			movieVector[IN_AIR_MOVIE] = _playerInairMovie;
			
			Starling.juggler.add(_playerIdleMovie);
			addChild(_playerIdleMovie);
			
			this.addEventListener(Event.ENTER_FRAME, playerStateCheck);
		}
		
		private function playerStateCheck():void
		{
			var newAnimationState:int = -1;	
			
			// TODO Auto Generated method stub
			if(this._objectBody.velocity.x > 0.3 || this._objectBody.velocity.y > 0.3 )
			{
				newAnimationState = IN_AIR_MOVIE;
			}else
			{
				newAnimationState = IDLE_MOVIE;
			}
			
			//trace(movieVector[animationState].currentFrame == (movieVector[animationState].numFrames - 1));
			
			if((newAnimationState != animationState) && 
				(movieVector[animationState].currentFrame == (movieVector[animationState].numFrames - 1)))
			{
				
				this.getBody().userData.graphic = movieVector[newAnimationState];
				movieVector[newAnimationState].x = movieVector[animationState].x;
				movieVector[newAnimationState].y = movieVector[animationState].y;
				//trace(movieVector[animationState].rotation);
				movieVector[newAnimationState].rotation = movieVector[animationState].rotation;
				//movieVector[newAnimationState].pivotX = movieVector[animationState].pivotX;
				//movieVector[newAnimationState].pivotY = movieVector[animationState].pivotY;
				//movieVector[newAnimationState].c = movieVector[animationState].root;
				
				
				removeChild(movieVector[animationState]);
				Starling.juggler.remove(movieVector[animationState]);
				
				animationState = newAnimationState;
				addChild(movieVector[animationState]);
				Starling.juggler.add(movieVector[animationState]);
				
			}
			
			//trace("currentFrame: " + movieVector[animationState].currentFrame); 
			//trace("totalFrames: " + (movieVector[animationState].numFrames - 1));
					
			
		}
		
		private function onAddedToStageEnemy(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageEnemy);
			
			_objectImage = new Image(Assets.getTexture("enemyRaw"));
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.y / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
						
			_objectBody = PhysicsData.createBody("enemy");
			_objectBody.type = BodyType.DYNAMIC;
			_objectBody.space = _mySpace;
			_objectBody.mass = 5;
			_objectBody.gravMass = 20;
			_objectBody.position.setxy( _position.x, _position.y );
			_objectBody.setShapeMaterials( Material.steel()	 );
			_objectBody.userData.graphic = _objectImage;
			
			_objectBody.setShapeFilters(new InteractionFilter(2));
			
			_objectBody.cbTypes.add(globalFunctions.enemyCb);
			_objectBody.cbTypes.add(globalFunctions.other);
			
			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			addChild(_objectImage);
			
			var animation:Tween = new Tween(_objectImage, 15);
			animation.repeatCount = int.MAX_VALUE;
			animation.animate("rotation", 180);
			Starling.juggler.add(animation);
												
			Assets.saw.play(0,int.MAX_VALUE);
			var anchor:Vec2 = Vec2.get(_objectBody.position.x, _objectBody.position.y - 400);		
			
			var pivotJoint:Constraint = new PivotJoint(_objectBody, _mySpace.world, _objectBody.worldPointToLocal(anchor), anchor);
			pivotJoint.space = _mySpace;
			pivotJoint.stiff = false;
			pivotJoint.frequency = 20;
			pivotJoint.damping = 1;
						
		}
		
		private function onAddedToStageFireball(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageFireball);
			
			_objectImage = new Image(Assets.getTexture((("fireBallRaw"))));
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX =  8/648;//_WidthHeight.y / _objectImage.width;
			_objectImage.scaleY =  8/648;//_WidthHeight.y / _objectImage.height;
			
			_objectBody = new Body( BodyType.DYNAMIC );
			
			_objectBody.shapes.add( new Circle(_WidthHeight.x));
			_objectBody.setShapeFilters(new InteractionFilter(1,~1));
			_objectBody.cbTypes.add(globalFunctions.projectile);
			
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.rubber() );
			_objectBody.isBullet = true;
			_objectBody.userData.graphic = _objectImage;
			_objectBody.gravMass = 0.0;
			_objectBody.mass = 10;
			
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
			_objectBody.cbTypes.add(globalFunctions.other);
				
			_objectBody.position.setxy(_position.x, _position.y);
			_objectBody.setShapeMaterials( Material.steel() );
			_objectBody.userData.graphic = _objectImage;
			
			_objectBody.space = _mySpace;

			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			_objectImage.blendMode = BlendMode.NONE;
			addChild(_objectImage);

		}
		
		private function onAddedToStageBox(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageBox);
		
			_objectBody = new Body( BodyType.DYNAMIC );
			_objectImage =  new Image(Assets.getTexture((("scaredBoxRaw"))));
			
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.x / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
			
			_objectBody.shapes.add( new Polygon( Polygon.box(_WidthHeight.x, _WidthHeight.y) ) );
			_objectBody.position.setxy( _position.x, _position.y );
			_objectBody.setShapeMaterials( Material.wood() );
			_objectBody.userData.graphic = _objectImage;
			_objectBody.space = _mySpace;
			_objectBody.mass = 0.5;
			
			_objectBody.setShapeFilters(new InteractionFilter(2));
			
			_objectBody.cbTypes.add(globalFunctions.other);
			
			_objectImage.x = _objectBody.position.x;
			_objectImage.y = _objectBody.position.y;
			addChild(_objectImage);
		
		}
		
		private function onAddedToStageWater(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageWater);
			
			//_objectBody = new Body( BodyType.STATIC );
			_objectImage =  new Image(Assets.getTexture((("waterRaw"))));
			
			_objectImage.pivotX = _objectImage.width / 2;
			_objectImage.pivotY = _objectImage.height / 2;
			_objectImage.scaleX = _WidthHeight.x / _objectImage.width;
			_objectImage.scaleY = _WidthHeight.y / _objectImage.height;
			
			var water:Polygon = new Polygon(Polygon.box( _WidthHeight.x, _WidthHeight.y));
			water.fluidEnabled = true;
			water.fluidProperties.density = 3;
			water.fluidProperties.viscosity = 5;
			water.body = new Body(BodyType.STATIC);
			water.body.position.setxy(_position.x,_position.y);
			water.body.userData.graphic = _objectImage;
			water.body.space = _mySpace;		
			
			_objectBody = water.body;
			
			_objectImage.x = _position.x;
			_objectImage.y = _position.y;
			_objectImage.alpha = 0.8;
			//_objectImage.color = Color.WHITE;
			_objectImage.filter = new BlurFilter(0.5,0.5,0.5);
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
		
		public function getMovieClip():MovieClip
		{
			return _objectsMovieClip;
		}
	}
}