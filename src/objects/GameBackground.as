package objects
{
	import nape.geom.Vec2;
	
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameBackground extends Sprite
	{
		public var bgLayer1:BgLayer;
		public var bgLayer2:BgLayer;
		private var bgLayer3:BgLayer;
		private var bgLayer4:BgLayer;
		
		private var _speed:Number = 0;
		
		public function GameBackground()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			bgLayer1 = new BgLayer(1);
			bgLayer1.parallax = 1;
			bgLayer1.y = - 1150;
			bgLayer1.blendMode = BlendMode.NONE;
			this.addChild(bgLayer1);
			
			bgLayer2 = new BgLayer(2);
			bgLayer2.parallax = 1.1;
			bgLayer1.y = 640;
			//this.addChild(bgLayer2);
			
			bgLayer3 = new BgLayer(3);
			bgLayer3.parallax = 1.15;
			//this.addChild(bgLayer3);
			
			bgLayer4 = new BgLayer(4);
			bgLayer4.parallax = 1.2;
			//this.addChild(bgLayer4);
			
			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			bgLayer1.x -= Math.ceil(_speed * bgLayer1.parallax);
			if (bgLayer1.x < -stage.stageWidth) bgLayer1.x = 0;
			
			bgLayer2.x -= Math.ceil(_speed * bgLayer2.parallax);
			if (bgLayer2.x < -stage.stageWidth) bgLayer2.x = 0;
			
			bgLayer3.x -= Math.ceil(_speed * bgLayer3.parallax);
			if (bgLayer3.x < -stage.stageWidth) bgLayer3.x = 0;
			
			bgLayer4.x -= Math.ceil(_speed * bgLayer4.parallax);
			if (bgLayer4.x < -stage.stageWidth) bgLayer4.x = 0;
		}
		
		public function bgPosition(position:Vec2):void
		{

			/*if((640 - position.y) > 640/2)
			{*/
				bgLayer1.y = (-1300 - position.y) * bgLayer1.parallax;
				bgLayer1.x = (360 + 960 / 2 - position.x) * bgLayer1.parallax;
				//if (bgLayer1.x < -stage.stageWidth) bgLayer1.x = 0;
				
				bgLayer2.y = (640 - 200 - position.y) *1;
				bgLayer2.x = (960 - position.x) * bgLayer2.parallax;
				//if (bgLayer2.x < -stage.stageWidth) bgLayer2.x = 0;
				
				bgLayer3.y = (640 / 2 - position.y) * bgLayer3.parallax;
				bgLayer3.x = (960 / 2 - position.x) * bgLayer3.parallax;
				//if (bgLayer3.x < -stage.stageWidth) bgLayer3.x = 0;
				
				bgLayer4.y = (640 / 2 - position.y) * bgLayer4.parallax;
				bgLayer4.x = (960 / 2 - position.x) * bgLayer4.parallax;
				
			/*}else
			{
				bgLayer1.y = (640 / 2 - position.y) * bgLayer1.parallax;
				bgLayer1.x = (960 / 2 - position.x) * bgLayer1.parallax;
				//if (bgLayer1.x < -stage.stageWidth) bgLayer1.x = 0;
				
				bgLayer2.y = (640 / 2 - position.y) * bgLayer2.parallax;
				bgLayer2.x = (960 / 2 - position.x) * bgLayer2.parallax;
				//if (bgLayer2.x < -stage.stageWidth) bgLayer2.x = 0;
				
				bgLayer3.y = (640 / 2 - position.y) * bgLayer3.parallax;
				bgLayer3.x = (960 / 2 - position.x) * bgLayer3.parallax;
				//if (bgLayer3.x < -stage.stageWidth) bgLayer3.x = 0;
				
				bgLayer4.y = (640 / 2 - position.y) * bgLayer4.parallax;
				bgLayer4.x = (960 / 2 - position.x) * bgLayer4.parallax;
			}*/
			
			
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
	}
}