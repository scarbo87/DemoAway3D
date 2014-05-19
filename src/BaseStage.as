package  
{
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.HoverController;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class BaseStage extends Sprite 
	{
		protected var _view:View3D;
		protected var _cameraController:ControllerBase;
		protected var _lookAtPosition:Vector3D = new Vector3D();
		protected var _demoRotation:Boolean = true;
		protected var _move:Boolean = false;
		protected var _lastMouseX:Number;
		protected var _lastMouseY:Number;
		protected var _lastPanAngle:Number;
		protected var _lastTiltAnge:Number;
		
		public function BaseStage() 
		{
			if (stage) _init();
			else addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		protected function _init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_initView();
			_initCamera();
			init(event);
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE, _onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			stage.addEventListener(Event.RESIZE, _onResize);
			onResize();
		}
		
		protected function _initView():void
		{
			_view = new View3D();
			addChild(_view);
		}
		
		protected function _initCamera():void
		{
			_cameraController = new HoverController(_view.camera, null, 20, 45, 500, 5);
		}
		
		protected function _onEnterFrame(event:Event):void 
		{
			if (_demoRotation) {
				HoverController(_cameraController).panAngle -= 0.2;
			}
			if (_move) {
				HoverController(_cameraController).panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
				HoverController(_cameraController).tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAnge;
			}
			HoverController(_cameraController).lookAtPosition = _lookAtPosition;
			_view.render();
			//
			onEnterFrame(event);
		}
		
		protected function _onMouseDown(event:MouseEvent):void
		{
			_lastPanAngle = HoverController(_cameraController).panAngle;
			_lastTiltAnge = HoverController(_cameraController).tiltAngle;
			_lastMouseX = stage.mouseX;
			_lastMouseY = stage.mouseY;
			_move = true;
			//
			onMouseDown(event);
		}
		
		protected function _onMouseUp(event:Event):void
		{
			_move = false;
			//
			onMouseUp(event);
		}
		
		protected function _onMouseWheel(event:MouseEvent):void
		{
			HoverController(_cameraController).distance -= event.delta * 5;
			if (HoverController(_cameraController).distance < 100) {
				HoverController(_cameraController).distance = 100;
			}
			else if (HoverController(_cameraController).distance > 2000) {
				HoverController(_cameraController).distance = 2000;
			}
			//
			onMouseWheel(event);
		}
		
		protected function _onResize(event:Event = null):void 
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
			//
			onResize(event);
		}
		
		/*************************/
		//Overrideted methods
		/*************************/
		protected function init(event:Event = null):void 
		{
			//override this
		}
		
		protected function onEnterFrame(event:Event = null):void
		{
			//override this
		}
		
		protected function onMouseDown(event:MouseEvent = null):void
		{
			//override this
		}
		
		protected function onMouseUp(event:Event = null):void
		{
			//override this
		}
		
		protected function onMouseWheel(event:MouseEvent = null):void
		{
			//override this
		}
		
		protected function onResize(event:Event = null):void
		{
			//override this
		}
	}

}