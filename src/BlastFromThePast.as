package
{

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	public class BlastFromThePast extends Sprite
	{
		
		private var stats:Stats;
		private var myStarling:Starling;
		
		
		public function BlastFromThePast()
		{
			stats = new Stats();
			this.addChild(stats);
			
			
			Starling.multitouchEnabled = true;
			
			stage.frameRate = 60;
		
			myStarling = new Starling(GameWorld, stage, new Rectangle(0,0,640,960));
			myStarling.simulateMultitouch = true;
			myStarling.antiAliasing = 1;
			myStarling.start();
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}