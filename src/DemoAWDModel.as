package  
{
	import away3d.core.base.CompactSubGeometry;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class DemoAWDModel extends BaseStage 
	{
		//[Embed(source="../assets/awd/sphere_magic_v2.awd", mimeType="application/octet-stream")]
		[Embed(source="../assets/awd/sphere_magic_v3.awd", mimeType="application/octet-stream")]
		private static var Model:Class;
		
		[Embed(source="../assets/awd/magic_texture.png")]
		private static var Texture:Class;
		
		[Embed(source = "../assets/awd/beachball_diffuse.jpg")]
		private static var TextureDiffuse:Class;
		
		[Embed(source = "../assets/awd/beachball_specular.jpg")]
		private static var TextureSpecular:Class;
		
		private var material:TextureMaterial;
		private var light1:DirectionalLight;
		private var light2:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		
		public function DemoAWDModel() 
		{
			super();
		}
		
		override protected function initPrimitives():void
		{
			demoRotation = false;
			
			light1 = new DirectionalLight();
			light1.direction = new Vector3D(0, -1, 0);
			light1.ambient = 0.1;
			light1.diffuse = 0.7;
			_view.scene.addChild(light1);
			
			light2 = new DirectionalLight();
			light2.direction = new Vector3D(0, -1, 0);
			light2.color = 0x00FFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.7;
			_view.scene.addChild(light2);
			
			lightPicker = new StaticLightPicker([light1, light2]);
			
			material = new TextureMaterial(Cast.bitmapTexture(Texture));
			material.specularMap = Cast.bitmapTexture(TextureSpecular);
			material.lightPicker = lightPicker;
			
			var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();
			AssetLibrary.loadData(new Model(), assetLoaderContext, null, new AWD2Parser());
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onCompleteHandler);
			
			addChild(new AwayStats());
		}
		
		private function onCompleteHandler(event:AssetEvent):void 
		{
			trace(event.asset.assetType);
			if (event.asset.assetType == AssetType.MESH) {
				var mesh:Mesh = event.asset as Mesh;
				mesh.material = material;
				_view.scene.addChild(mesh);
			}
		}
		
		override protected function onEnterFrame(event:Event = null):void 
		{
			light1.direction = new Vector3D(Math.sin(getTimer() / 10000) * 150000, 1000, Math.cos(getTimer() / 10000) * 150000);
		}
		

	}

}