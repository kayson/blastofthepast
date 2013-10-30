package
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.StaticText;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	
	import objects.GameBackground;
	import objects.Objects;
	import objects.UI;
	
	import screens.LevelInterface;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;


	public class globalFunctions extends Sprite
	{
			//For touchGlobal
			private static var xDir:Number = 0;
			private static var yDir:Number = 0;
			
			// CBTYPES!!!
			public static var projectile:CbType = new CbType();
			public static var other:CbType = new CbType();
			public static var player:CbType = new CbType();
			public static var enemyCb:CbType = new CbType();
			public static var goal:CbType = new CbType();

			public static var shootCooldown:int;
			private static var maxCooldown:int = 60;
					
			private static var psConfig:XML;
			private static var psTexture:Texture;
			private static var ps:PDParticleSystem;
			private static var particleVec:Vector.<PDParticleSystem> = new Vector.<PDParticleSystem>();

			
			
			public static function performAction():void {
				
			}
			
			
			public static function touchGlobal(e:TouchEvent, stage:Stage,
								player:Objects, mySpace:Space, lvlInterf:LevelInterface):void
			{
				var touch:Touch = e.getTouch(stage);
				if( touch && shootCooldown == 0 )
				{
					if(touch.phase == TouchPhase.BEGAN)//on finger down
					{
						xDir = touch.globalX;
						yDir = touch.globalY;		
					}else if(touch.phase == TouchPhase.ENDED) //on finger up
					{	
						var shootDir:Vec2 = Vec2.get((touch.globalX-xDir),(touch.globalY-yDir));
					
						if(shootDir.length > 0.1)
						{
							shootDir = shootDir.normalise();
							
							//Anropa state-change till shoot
							player.playerStateShoot(shootDir);
							
							shootDir.x *= 5000;
							shootDir.y *= 5000;
		
							var fireball:Objects = new Objects("Fireball",mySpace,
								Vec2.weak(player.getBody().position.x, player.getBody().position.y),
								Vec2.weak(32,32));
							lvlInterf.addObjectToInstance(fireball);
							fireball.getBody().rotation = shootDir.angle;
							fireball.getBody().applyImpulse(shootDir);
													
							shootCooldown = maxCooldown;
						}
					}
					
				}
			}
			
			public static function hasCollidedGlobal(cb:InteractionCallback, 
									mySpace:Space, stage:Stage, lvlInterf:LevelInterface):void {
				
				var a:Body = cb.int1 as Body;
				var explosionPos:Vec2 = a.position;				
				
				//lvlInterf.removeObjectFromInstance(a.userData.graphic.parent);
				//mySpace.bodies.remove(a);
				
				psConfig = XML(new Assets.FireConfig());
				psTexture = Texture.fromBitmap(new Assets.FireParticle());
				
				var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
				particleVec.push(ps);
				ps.emitterX = a.userData.graphic.x;
				ps.emitterY = a.userData.graphic.y;
				ps.name = String(lvlInterf.getPlayer().getBody().position.x) + " " +
					String(lvlInterf.getPlayer().getBody().position.y);
				
				lvlInterf.addObjectToInstance(ps);
				Starling.juggler.add(ps);
				
				ps.start(0.5);
				ps.advanceTime(0.1);
				
				Assets.shoot.play();
				
				var impulseForce:Number;
				var impulse:Vec2;
				for(var i:int = 0; i < mySpace.liveBodies.length; i++)
				{		
					var b:Body = mySpace.liveBodies.at(i);
					var bodyPos:Vec2 = b.position;
					var impulseVector:Vec2 = new Vec2(bodyPos.x-explosionPos.x, bodyPos.y-explosionPos.y);
					if(impulseVector.length < 200 && impulseVector.length > 0)
					{
						if(b.cbTypes.has(player) || b.cbTypes.has(other))
						{
							impulseForce = Math.log((100-impulseVector.length)/80 + 1)*200;
							if(impulseForce > 0)
							{
								impulse = impulseVector.mul(impulseForce/impulseVector.length * 2);
								b.applyImpulse(impulse);
							}
							
						}
					}
					
					
				}
				
				lvlInterf.removeObjectFromInstance(a.userData.graphic.parent);
				mySpace.bodies.remove(a);
			}
			
			public static function enemyHitGlobal(cb:InteractionCallback, 
													 mySpace:Space, stage:Stage, lvlInterf:LevelInterface):void {
				
				var a:Body = cb.int1 as Body;
				psConfig = XML(new Assets.EnemyDeathConfig());
				psTexture = Texture.fromBitmap(new Assets.EnemyDeathParticle());
				
				var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
				particleVec.push(ps);
				ps.emitterX = a.userData.graphic.x;
				ps.emitterY = a.userData.graphic.y;
				ps.name = String(lvlInterf.getPlayer().getBody().position.x) + " " +
					String(lvlInterf.getPlayer().getBody().position.y);
				
				lvlInterf.addObjectToInstance(ps);
				Starling.juggler.add(ps);
				
				ps.start(0.5);
				ps.advanceTime(0.1);
				//lvlInterf.onMainMenuClick();

			}
			
			public static function playerInGoal(cb:InteractionCallback, 
												  mySpace:Space, stage:Stage, lvlInterf:LevelInterface):void {
				
				lvlInterf.onMainMenuClick();		
			}
			
			public static function updateGraphicsGlobal( body:Body, player:Objects, wh:Vec2):void
			{
				var graphic:Image = body.userData.graphic;
				//graphic.x = body.position.x;
				//Circlebadguy är här spelaren
				//Man kan lägga in ett krav som kollar 
				//mot golv och väggar och så
				//Avsluta funktionen.
				if(body != player.getBody())
				{
					graphic.y = body.position.y + (wh.y / 2) - player.getBody().position.y;
					graphic.x = body.position.x + (wh.x / 2) - player.getBody().position.x;
					
				}
				//Fixar så golvet hänger med, men funkar inte riktigt än.
				/*if(body != player.getBody() && (wh.y - player.getBody().position.y) > wh.y/2)
				{
					graphic.y = body.position.y + (wh.y / 2) - player.getBody().position.y;
					graphic.x = body.position.x + (wh.x / 2) - player.getBody().position.x;
				}else if(body != player.getBody())
				{
					graphic.y = body.position.y;
					graphic.x = body.position.x + (wh.x / 2) - player.getBody().position.x;
				}else if((wh.y - player.getBody().position.y) < wh.y/2)
				{
					graphic.y = body.position.y;
					//graphic.x = body.position.x;
				}*/
				
				//timer.currentCount
				
				
				graphic.rotation = body.rotation;
			}
			
			public static function UpdateWorldGlobal( evt:Event, mySpace:Space,
								player:Objects, bg:GameBackground , func:Function):void
			{
				
				mySpace.step( 1 / 60 );		
				mySpace.bodies.foreach( func );			

				//OBS LEVEL 1 FUNKAR INTE NÄR DENNA ÄR MED!?
				bg.bgPosition(player.getBody().position);
				
				if(shootCooldown > 0)
				{
					shootCooldown--;
					UI.shootTimer.value = 1-shootCooldown/maxCooldown;
				}
				// DETTA FUNKAR BRA !!!!!!!!!!!
				//var length:int = particleVec.length;
				var arr:Array;
				var diffX:Number;
				var diffY:Number
				for(var i:int=0; i<particleVec.length; i++)
				{
					ps = particleVec[i];
					if(ps.numParticles == 0)
					{
						ps.stop();
						particleVec.splice(i, 1);
						Starling.juggler.remove(ps);
						//removeChild(ps, true);
					}
					
					arr = ps.name.split(" ");
					//trace("Player creation pos: " + arr[0] + " " + arr[1]);
					//trace("Player pos: " + player.getBody().position.x);
					//trace("Final diff: " + (int(ps.name) - player.getBody().position.x)) ;
					diffX = (int(arr[0]) - player.getBody().position.x);
					diffY = (int(arr[1]) - player.getBody().position.y);
					
					ps.x = diffX;
					ps.y = diffY;
					
					//ps.emitterX += (960 / 2) - player.getBody().position.x;
					//ps.emitterY += (640 / 2) - player.getBody().position.y;
				}
			}
			
			public static function onMainMenuClickGlobal(event:Event, dispatchFuncEvent:Function):void
			{
				var buttonClicked:Button = event.target as Button;
				if(buttonClicked)	
				{
					dispatchFuncEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "lvl1"}, true));
				}
			}
		
		
	}
}