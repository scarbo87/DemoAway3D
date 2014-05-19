package  
{
	import away3d.controllers.HoverController;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	import flash.events.Event;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class Demo3DSModel extends BaseStage 
	{
		[Embed(source="../assets/3ds/holder1.3DS", mimeType="application/octet-stream")]
		private static var Model:Class;
		
		[Embed(source="../assets/3ds/holder1.jpg")]
		private static var Texture01:Class;
		
		private var _mesh:Mesh;
		private var _board:Mesh;
		private var _material:TextureMaterial;
		
		public function Demo3DSModel() 
		{
			super();
		}
		
		override protected function _initCamera():void
		{
			_cameraController = new HoverController(_view.camera, null, 50, 20, 200, 5);
		}
		
		override protected function init(event:Event = null):void
		{
			_demoRotation = false;
			
			_board = new Mesh(new PlaneGeometry(500, 500), new ColorMaterial(0xc8c8c8));
			_view.scene.addChild(_board);
			
			var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();
			assetLoaderContext.mapUrlToData('HOLDER1.JPG', new Texture01());
			
			_material = new TextureMaterial(Cast.bitmapTexture(Texture01));
			AssetLibrary.loadData(new Model(), assetLoaderContext, null, new Max3DSParser());
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
		}
		
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH) {
				_mesh = event.asset as Mesh;
				_mesh.scale(5);
				_mesh.x = 50;
				_mesh.z = 20;
				_mesh.y = 40;
				//_mesh.transform.appendScale(5, 5, 5);
				//_mesh.transform.appendTranslation( -600, 300, 600);
				//_mesh.transform.appendRotation( 90, Vector3D.Y_AXIS);
				_mesh.material = _material;
				//
				_view.scene.addChild(_mesh);
			}
		}
	}

}