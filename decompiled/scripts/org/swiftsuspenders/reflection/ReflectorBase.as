package org.swiftsuspenders.reflection
{
   import flash.utils.Proxy;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class ReflectorBase
   {
       
      
      public function ReflectorBase()
      {
         super();
      }
      
      public function getClass(param1:Object) : Class
      {
         if(param1 is Proxy || param1 is Number || param1 is XML || param1 is XMLList)
         {
            return Class(getDefinitionByName(getQualifiedClassName(param1)));
         }
         return param1.constructor;
      }
      
      public function getFQCN(param1:*, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(param1 is String)
         {
            _loc3_ = param1;
            if(!param2 && _loc3_.indexOf("::") == -1)
            {
               _loc4_ = _loc3_.lastIndexOf(".");
               if(_loc4_ == -1)
               {
                  return _loc3_;
               }
               return _loc3_.substring(0,_loc4_) + "::" + _loc3_.substring(_loc4_ + 1);
            }
         }
         else
         {
            _loc3_ = getQualifiedClassName(param1);
         }
         return !!param2?_loc3_.replace("::","."):_loc3_;
      }
   }
}
