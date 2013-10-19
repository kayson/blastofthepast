package screens
{
	import nape.callbacks.InteractionCallback;
	import nape.phys.Body;
	
	import objects.Objects;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.TouchEvent;

	public interface LevelInterface
	{	
				//function onAddedToStage(event:Event):void;
				function InitSpace():void;
				/*function InitBodies():void;
				function onMainMenuClick(event:Event):void;
				function UpdateWorld( evt:Event ):void;
				function touch(e:TouchEvent):void;
				function hasCollided(cb:InteractionCallback):void;
				function enemyHit(cb:InteractionCallback):void;
				function updateGraphics( body:Body ):void;
				function disposeTemporarily():void;
				function initialize():void;*/
				//function addObjectToInstance(obj:Objects):void;
				function removeObjectFromInstance(obj:DisplayObject):void;
				function addObjectToInstance(obj:DisplayObject):void;
	}
}