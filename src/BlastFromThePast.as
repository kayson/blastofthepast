package 
{

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60",backgroundColor="#000000")]
	
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
			
			myStarling = new Starling(GameWorld, stage, new Rectangle(0,0,960,640));
			myStarling.simulateMultitouch = true;
				//myStarling.antiAliasing = 1;
			myStarling.start();
			super();
			
		}
	}
}