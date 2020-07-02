package kabam.rotmg.util.components
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   
   public class InfoHoverPaneFactory extends Sprite
   {
       
      
      public function InfoHoverPaneFactory()
      {
         super();
      }
      
      public static function make(param1:DisplayObject) : Sprite
      {
         var _loc4_:PopupWindowBackground = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Sprite = new Sprite();
         var _loc3_:int = 8;
         param1.width = 291 - _loc3_;
         param1.height = 598 - _loc3_ * 2 - 2;
         _loc2_.addChild(param1);
         _loc4_ = new PopupWindowBackground();
         _loc4_.draw(param1.width,param1.height + 2,PopupWindowBackground.TYPE_TRANSPARENT_WITHOUT_HEADER);
         _loc4_.x = param1.x;
         _loc4_.y = param1.y - 1;
         _loc2_.addChild(_loc4_);
         return _loc2_;
      }
   }
}
