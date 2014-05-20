package  
{
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.HoverController;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	[SWF(backgroundColor="#000000", frameRate="60", width="800", height="600")]
	public class BaseStage extends Sprite 
	{
		protected var antiAlias:uint = 4;
		protected var demoRotation:Boolean = true;
		
		protected var _view:View3D;
		protected var _cameraController:HoverController;
		protected var _lookAtPosition:Vector3D = new Vector3D();
		protected var _move:Boolean = false;
		protected var _lastMouseX:Number;
		protected var _lastMouseY:Number;
		protected var _keyUp:Boolean;
		protected var _keyDown:Boolean;
		protected var _keyLeft:Boolean;
		protected var _keyRight:Boolean;
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
			
			initView();
			initCamera();
			initPrimitives();
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE, _onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			stage.addEventListener(Event.RESIZE, _onResize);
			onResize();
		}
		
		protected function initView():void
		{
			_view = new View3D();
			_view.antiAlias = antiAlias;
			addChild(_view);
		}
		
		protected function initCamera():void
		{
			_cameraController = new HoverController(_view.camera, null, 20, 45, 500, 5);
		}
		
		protected function initPrimitives():void
		{
			//override this
		}
		
		protected function _onEnterFrame(event:Event):void 
		{
			if (_cameraController) {
				if (_move) {
					_cameraController.panAngle = 0.3 * (stage.mouseX - _lastMouseX) + _lastPanAngle;
					_cameraController.tiltAngle = 0.3 * (stage.mouseY - _lastMouseY) + _lastTiltAnge;
				}
			
				if (demoRotation) _cameraController.panAngle -= 0.2;
				if (_keyUp) _lookAtPosition.x -= 10;
				if (_keyDown) _lookAtPosition.x += 10;
				if (_keyLeft) _lookAtPosition.z -= 10;
				if (_keyRight)_lookAtPosition.z += 10;
			
				_cameraController.lookAtPosition = _lookAtPosition;
			}
			
			_view.render();
			onEnterFrame(event);
		}
		
		protected function _onMouseDown(event:MouseEvent):void
		{
			_lastPanAngle = _cameraController.panAngle;
			_lastTiltAnge = _cameraController.tiltAngle;
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
			_cameraController.distance -= event.delta * 5;
			if (_cameraController.distance < 100) {
				_cameraController.distance = 100;
			}
			else if (_cameraController.distance > 2000) {
				_cameraController.distance = 2000;
			}
			//
			onMouseWheel(event);
		}
		
		protected function _onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					_keyUp = true;
					break;
					
				case Keyboard.DOWN:
				case Keyboard.S:
					_keyDown = true;
					break;
					
				case Keyboard.LEFT:
				case Keyboard.A:
					_keyLeft = true;
					break;
					
				case Keyboard.RIGHT:
				case Keyboard.D:
					_keyRight = true;
					break;
			}
			//
			onKeyDown(event);
		}
		
		protected function _onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					_keyUp = false;
					break;
					
				case Keyboard.DOWN:
				case Keyboard.S:
					_keyDown = false;
					break;
					
				case Keyboard.LEFT:
				case Keyboard.A:
					_keyLeft = false;
					break;
					
				case Keyboard.RIGHT:
				case Keyboard.D:
					_keyRight = false;
					break;
			}
			//
			onKeyUp(event);
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
		
		protected function onKeyUp(event:KeyboardEvent = null):void
		{
			//override this
		}
		
		protected function onKeyDown(event:KeyboardEvent = null):void
		{
			//override this
		}
		
		protected function onResize(event:Event = null):void
		{
			//override this
		}
	}

}