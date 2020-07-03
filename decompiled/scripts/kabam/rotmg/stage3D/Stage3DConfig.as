package kabam.rotmg.stage3D
{
   import com.company.assembleegameclient.engine3d.Model3D;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.Stage3DProxy;
   import com.company.assembleegameclient.util.StageProxy;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import kabam.rotmg.stage3D.graphic3D.Graphic3DHelper;
   import kabam.rotmg.stage3D.graphic3D.IndexBufferFactory;
   import kabam.rotmg.stage3D.graphic3D.TextureFactory;
   import kabam.rotmg.stage3D.graphic3D.VertexBufferFactory;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IConfig;
   
   public class Stage3DConfig implements IConfig
   {
      
      public static const WIDTH:int = 600;
      
      public static const HALF_WIDTH:int = WIDTH / 2;
      
      public static const HEIGHT:int = 600;
      
      public static const HALF_HEIGHT:int = HEIGHT / 2;
       
      
      [Inject]
      public var stageProxy:StageProxy;
      
      [Inject]
      public var injector:Injector;
      
      public var renderer:Renderer;
      
      private var stage3D:Stage3DProxy;
      
      public function Stage3DConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.mapSingletons();
         this.stage3D = this.stageProxy.getStage3Ds(0);
         this.stage3D.addEventListener(ErrorEvent.ERROR,Parameters.clearGpuRenderEvent);
         this.stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContextCreate);
         this.stage3D.requestContext3D();
      }
      
      private function mapSingletons() : void
      {
         this.injector.map(Render3D).asSingleton();
         this.injector.map(TextureFactory).asSingleton();
         this.injector.map(IndexBufferFactory).asSingleton();
         this.injector.map(VertexBufferFactory).asSingleton();
      }
      
      private function onContextCreate(param1:Event) : void
      {
         this.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContextCreate);
         var _loc2_:Context3DProxy = this.stage3D.getContext3D();
         if(_loc2_.GetContext3D().driverInfo.toLowerCase().indexOf("software") != -1)
         {
            Parameters.clearGpuRender();
         }
         _loc2_.configureBackBuffer(WIDTH,HEIGHT,2,true);
         _loc2_.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
         _loc2_.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
         this.injector.map(Context3DProxy).toValue(_loc2_);
         Graphic3DHelper.map(this.injector);
         this.renderer = this.injector.getInstance(Renderer);
         this.renderer.init(_loc2_.GetContext3D());
         Model3D.Create3dBuffer(_loc2_.GetContext3D());
      }
   }
}
