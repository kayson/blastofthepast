package 
{

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate="60",backgroundColor="#000000")]
	
	public class BlastFromThePast extends Sprite
	{
		
		private var stats:Stats;
		private var myStarling:Starling;
		
		
		public function BlastFromThePast()
		{
			stats = new Stats();
			//this.addChild(stats);
			// this is the flash stage
			stage.addEventListener(flash.events.Event.RESIZE, onResize, false, 0, true);
			
			Starling.multitouchEnabled = true;
			
			stage.frameRate = 60;
			
			myStarling = new Starling(GameWorld, stage, new Rectangle(0,0,960,640));
			myStarling.simulateMultitouch = true;
			
			myStarling.stage.stageHeight = 640;
			myStarling.stage.stageWidth = 960;
				//myStarling.antiAliasing = 1;
			myStarling.start();
			
			
			
			super();
			
		}
		
		private function onResize(e:flash.events.Event):void
		{
			// note this is the flash stage.stageWidth/Height in a startup class, not root class
			var newViewportWidth:Number = stage.stageWidth;
			var newViewportHeight:Number = stage.stageHeight;
			
			var desiredScaleFactor:Number = 1;
			/*
			// you want to check if on iPhone or iPad retina...
			if (iOSRetinaDeviceTest) desiredScaleFactor = 2;
			// maybe for Android you use 2x assets with high screenDPI
			if (Capabilities.screenDPI >= 220) desiredScaleFactor = 2;
			// maybe you have some super-rocked out device needing 3x assets
			if (amazingSuperHDTest) desiredScaleFactor = 3;
			*/
			// note you might need to check if Starling stage is up yet...
			Starling.current.stage.stageWidth = newViewportWidth/desiredScaleFactor;
			Starling.current.stage.stageHeight = newViewportHeight/desiredScaleFactor;
			Starling.current.viewPort = new Rectangle(0,0, newViewportWidth, newViewportHeight);
		}
	}
}