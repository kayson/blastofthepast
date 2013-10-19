package
{
	import events.NavigationEvent;
	
	import flash.display.Screen;
	import flash.display.Sprite;
	
	import flashx.textLayout.tlf_internal;
	
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Circle;
	import nape.space.Space;
	
	import objects.GameBackground;
	import objects.Objects;
	
	import screens.LevelInterface;
	import screens.lvl1;
	
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
			public static var enemyCb:CbType = new CbType();
			
			public static function performAction():void {
				
			}
			
			public static function touchGlobal(e:TouchEvent, stage:Stage,
								player:Objects, mySpace:Space, lvlInterf:LevelInterface):void
			{
				var touch:Touch = e.getTouch(stage);
				if( touch )
				{
					if(touch.phase == TouchPhase.BEGAN)//on finger down
					{
						xDir = touch.globalX;
						yDir = touch.globalY;		
					}else if(touch.phase == TouchPhase.ENDED) //on finger up
					{	
						var shootDir:Vec2 = Vec2.get(-1*(touch.globalX-xDir),-1*(touch.globalY-yDir));
					
						if(shootDir.length != 0)
							shootDir = shootDir.normalise();
						
						shootDir.x *= 100;
						shootDir.y *= 100;

						var fireball:Objects = new Objects("Fireball",mySpace,
							Vec2.weak(player.getBody().position.x, player.getBody().position.y),
							Vec2.weak(8,8));	
						lvlInterf.addObjectToInstance(fireball);
						fireball.getBody().rotation = shootDir.angle;
						fireball.getBody().applyImpulse(shootDir);
						
						Assets.shoot.play();
					}
				}
			}
			
			public static function hasCollidedGlobal(cb:InteractionCallback, 
									mySpace:Space, stage:Stage, lvlInterf:LevelInterface):void {
				
				var a:Body = cb.int1 as Body;
				var explosionPos:Vec2 = a.position;				
				
				var psConfig:XML = XML(new Assets.FireConfig());
				var psTexture:Texture = Texture.fromBitmap(new Assets.FireParticle());
				
				var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
				ps.x = a.userData.graphic.x;
				ps.y = a.userData.graphic.y;

				lvlInterf.addObjectToInstance(ps);
				Starling.juggler.add(ps);
				
				ps.start(0.2);
				
				
				for(var i:int = 0; i < mySpace.liveBodies.length; i++)
				{		
					var b:Body = mySpace.liveBodies.at(i);
					var bodyPos:Vec2 = b.position;
					var impulseVector:Vec2 = new Vec2(bodyPos.x-explosionPos.x, bodyPos.y-explosionPos.y);
					if(b.cbTypes.has(other) && impulseVector.length < 300)
					{
						var impulseForce:Number = Math.log((300-impulseVector.length)/80 + 1)*80;
						var impulse:Vec2 = impulseVector.mul(impulseForce/impulseVector.length * 2);
						b.applyImpulse(impulse);
						
					}
					else if(b.cbTypes.has(enemyCb) && impulseVector.length < 300)
					{
						lvlInterf.removeObjectFromInstance(b.userData.graphic.parent);
						mySpace.bodies.remove(b);
						
						var psConfig2:XML = XML(new Assets.EnemyDeathConfig());
						var psTexture2:Texture = Texture.fromBitmap(new Assets.EnemyDeathParticle());
						
						var ps2:PDParticleSystem = new PDParticleSystem(psConfig2, psTexture2);
						ps2.x = b.userData.graphic.x;
						ps2.y = b.userData.graphic.y;
						
						ps2.scaleX = 0.8;
						ps2.scaleY = 0.8;
						
						lvlInterf.addObjectToInstance(ps2);
						Starling.juggler.add(ps2);
						
						ps2.start(1);
					}
					
				}
				
				lvlInterf.removeObjectFromInstance(a.userData.graphic.parent);
				mySpace.bodies.remove(a);
			}
			
			public static function enemyHitGlobal(cb:InteractionCallback, 
													 mySpace:Space, stage:Stage, lvlInterf:LevelInterface):void {
				
				var a:Body = cb.int1 as Body;	
				var b:Body = cb.int2 as Body;

				lvlInterf.removeObjectFromInstance(a.userData.graphic.parent);
				mySpace.bodies.remove(a);
				
				var psConfig:XML = XML(new Assets.FireConfig());
				var psTexture:Texture = Texture.fromBitmap(new Assets.FireParticle());
				
				var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
				ps.x = a.userData.graphic.x;
				ps.y = a.userData.graphic.y;
				
				lvlInterf.addObjectToInstance(ps);
				Starling.juggler.add(ps);
				
				ps.start(0.2);
				
				var psConfig2:XML = XML(new Assets.EnemyDeathConfig());
				var psTexture2:Texture = Texture.fromBitmap(new Assets.EnemyDeathParticle());
				
				var ps2:PDParticleSystem = new PDParticleSystem(psConfig2, psTexture2);
				ps2.x = b.userData.graphic.x;
				ps2.y = b.userData.graphic.y;
				
				ps2.scaleX = 0.8;
				ps2.scaleY = 0.8;
				
				lvlInterf.addObjectToInstance(ps2);
				Starling.juggler.add(ps2);
				
				ps2.start(1);
				
				lvlInterf.removeObjectFromInstance(b.userData.graphic.parent);
				mySpace.bodies.remove(b);

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

				graphic.rotation = body.rotation;
			}
			
			public static function UpdateWorldGlobal( evt:Event, mySpace:Space,
								player:Objects, bg:GameBackground , func:Function):void
			{
				
				mySpace.step( 1 / 60 );		
				mySpace.bodies.foreach( func );

				bg.bgPosition(player.getBody().position);
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