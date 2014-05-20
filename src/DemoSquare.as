package  
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Scarbo
	 */
	public class DemoSquare extends BaseStage 
	{
		
		[Embed(source = "../assets/scenegraph/floor_diffuse.jpg")]
		private static var FLOOR_DIFFUSE:Class;
		
		private var _model:Mesh;
		
		public function DemoSquare() 
		{
			super();
		}
		
		override protected function initPrimitives():void
		{
			//demoRotation = false;
			_model = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FLOOR_DIFFUSE)));
			_view.scene.addChild(_model);
		}
		
	}

}