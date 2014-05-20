package  
{
	import away3d.controllers.HoverController;
	import away3d.core.base.Geometry;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.FresnelPlanarReflectionMethod;
	import away3d.materials.methods.PlanarReflectionMethod;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SkyBox;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.CubeTextureBase;
	import away3d.textures.PlanarReflectionTexture;
	import away3d.utils.Cast;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Scarbo
	 */
	public class DemoMaterial extends BaseStage 
	{
		[Embed(source = "../assets/material/BeerGlass_V01.3DS", mimeType = "application/octet-stream")]
		private static var Model:Class;
		
		[Embed(source = "../assets/material/image 2.png")]
		private static var Texture:Class;
		
		[Embed(source = "../assets/material/image 3.png")]
		private static var CubeTexture:Class;
		
		[Embed(source = "../assets/material/image 1.png")]
		private static var Logo:Class;
		
		private var skyBox:SkyBox;
		private var skyBoxCubeMap:BitmapCubeTexture;
		private var lightPicker:StaticLightPicker;
		private var reflectionTexture:PlanarReflectionTexture;
		
		public function DemoMaterial() 
		{
			super();
		}
		
		override protected function _initCamera():void
		{
			_cameraController = new HoverController(_view.camera, null, 180, 10, 300, 5);
		}
		
		override protected function init(event:Event = null):void
		{
			_demoRotation = false;
			_view.antiAlias = 16;
			
			var light:DirectionalLight = new DirectionalLight(0, 10, 80);
			light.ambientColor = 16777215;
			light.diffuse = 1;
			lightPicker = new StaticLightPicker([light]);
			
			skyBoxCubeMap = new BitmapCubeTexture(Cast.bitmapData(CubeTexture), Cast.bitmapData(CubeTexture), Cast.bitmapData(CubeTexture), Cast.bitmapData(CubeTexture), Cast.bitmapData(CubeTexture), Cast.bitmapData(CubeTexture));
			skyBox = new SkyBox(skyBoxCubeMap);
			_view.scene.addChild(skyBox);
			
			var colorMaterial:ColorMaterial = new ColorMaterial(8092539, 0.8);
			colorMaterial.bothSides = false;
			colorMaterial.lightPicker = lightPicker;
			
			reflectionTexture = new PlanarReflectionTexture();
			reflectionTexture.scale = .5;
			
			var planar:PlanarReflectionMethod = new PlanarReflectionMethod(reflectionTexture);
			var fresnel:FresnelPlanarReflectionMethod = new FresnelPlanarReflectionMethod(reflectionTexture, 0.4);
			fresnel.fresnelPower = 100;
			fresnel.normalReflectance = 0.8;
			colorMaterial.addMethod(fresnel);
			
			var mesh:Mesh = new Mesh(new PlaneGeometry(250, 250, 1, 1, false), colorMaterial);
			mesh.z = mesh.maxZ;
			mesh.y = 0;
			mesh.rotationX = 90;
			mesh.rotationY = 180;
			_view.scene.addChild(mesh);
			
			reflectionTexture.applyTransform(mesh.sceneTransform);
			
			var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();
			//assetLoaderContext.mapUrlToData('HOLDER1.JPG', new Texture());
			AssetLibrary.loadData(new Model(), assetLoaderContext, null, new Max3DSParser());
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			
			addChild(new AwayStats());
		}
		
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH) {
				var mesh:Mesh = event.asset as Mesh;
				if (mesh.name == "glass") {
                    var colorMaterial:ColorMaterial = new ColorMaterial(13553358, 0.8);
                    colorMaterial.smooth = true;
                    colorMaterial.specular = 0.3;
					
                    var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(Texture), Cast.bitmapData(Texture), Cast.bitmapData(Texture), Cast.bitmapData(Texture), Cast.bitmapData(Texture), Cast.bitmapData(Texture));
                    var mapMethod:EnvMapMethod = new EnvMapMethod(cubeTexture, 0.6);
                    colorMaterial.addMethod(mapMethod);
                    colorMaterial.lightPicker = lightPicker;
                    mesh.material = colorMaterial;
                }
                if (mesh.name == "pa_1") {
                    var matrix:Matrix3D = new Matrix3D();
                    matrix.appendScale(13, 30, 13);
                    mesh.geometry.applyTransformation(matrix);
					
                    var texture:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(Logo));
                    texture.smooth = true;
                    texture.alphaBlending = true;
                    texture.bothSides = true;
                    texture.mipmap = false;
                    texture.lightPicker = lightPicker;
                    mesh.material = texture;
                    mesh.z = -38;
                    mesh.scale(0.1);
                }
				_view.scene.addChild(mesh);
			}
		}

		override protected function onEnterFrame(event:Event = null):void
		{
			reflectionTexture.render(_view);
		}
	}

}