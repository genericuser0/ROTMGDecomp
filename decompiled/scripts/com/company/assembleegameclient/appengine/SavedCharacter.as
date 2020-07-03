package com.company.assembleegameclient.appengine
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.AnimatedChars;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import com.company.util.CachingColorTransformer;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import io.decagames.rotmg.pets.data.PetsModel;
   import io.decagames.rotmg.pets.data.vo.PetVO;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.constants.GeneralConstants;
   import kabam.rotmg.core.StaticInjectorContext;
   import org.swiftsuspenders.Injector;
   
   public class SavedCharacter
   {
       
      
      public var charXML_:XML;
      
      public var name_:String = null;
      
      private var pet:PetVO;
      
      public function SavedCharacter(param1:XML, param2:String)
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:PetVO = null;
         super();
         this.charXML_ = param1;
         this.name_ = param2;
         if(this.charXML_.hasOwnProperty("Pet"))
         {
            _loc3_ = new XML(this.charXML_.Pet);
            _loc4_ = _loc3_.@instanceId;
            _loc5_ = StaticInjectorContext.getInjector().getInstance(PetsModel).getPetVO(_loc4_);
            _loc5_.apply(_loc3_);
            this.setPetVO(_loc5_);
         }
      }
      
      public static function getImage(param1:SavedCharacter, param2:XML, param3:int, param4:int, param5:Number, param6:Boolean, param7:Boolean) : BitmapData
      {
         var _loc8_:AnimatedChar = AnimatedChars.getAnimatedChar(String(param2.AnimatedTexture.File),int(param2.AnimatedTexture.Index));
         var _loc9_:MaskedImage = _loc8_.imageFromDir(param3,param4,param5);
         var _loc10_:int = param1 != null?int(param1.tex1()):int(null);
         var _loc11_:int = param1 != null?int(param1.tex2()):int(null);
         var _loc12_:BitmapData = TextureRedrawer.resize(_loc9_.image_,_loc9_.mask_,100,false,_loc10_,_loc11_);
         _loc12_ = GlowRedrawer.outlineGlow(_loc12_,0);
         if(!param6)
         {
            _loc12_ = CachingColorTransformer.transformBitmapData(_loc12_,new ColorTransform(0,0,0,0.5,0,0,0,0));
         }
         else if(!param7)
         {
            _loc12_ = CachingColorTransformer.transformBitmapData(_loc12_,new ColorTransform(0.75,0.75,0.75,1,0,0,0,0));
         }
         return _loc12_;
      }
      
      public static function compare(param1:SavedCharacter, param2:SavedCharacter) : Number
      {
         var _loc3_:Number = !!Parameters.data_.charIdUseMap.hasOwnProperty(param1.charId())?Number(Parameters.data_.charIdUseMap[param1.charId()]):Number(0);
         var _loc4_:Number = !!Parameters.data_.charIdUseMap.hasOwnProperty(param2.charId())?Number(Parameters.data_.charIdUseMap[param2.charId()]):Number(0);
         if(_loc3_ != _loc4_)
         {
            return _loc4_ - _loc3_;
         }
         return param2.xp() - param1.xp();
      }
      
      public function charId() : int
      {
         return int(this.charXML_.@id);
      }
      
      public function fameBonus() : int
      {
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc1_:Player = Player.fromPlayerXML("",this.charXML_);
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < GeneralConstants.NUM_EQUIPMENT_SLOTS)
         {
            if(_loc1_.equipment_ && _loc1_.equipment_.length > _loc3_)
            {
               _loc4_ = _loc1_.equipment_[_loc3_];
               if(_loc4_ != -1)
               {
                  _loc5_ = ObjectLibrary.xmlLibrary_[_loc4_];
                  if(_loc5_ != null && _loc5_.hasOwnProperty("FameBonus"))
                  {
                     _loc2_ = _loc2_ + int(_loc5_.FameBonus);
                  }
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function name() : String
      {
         return this.name_;
      }
      
      public function objectType() : int
      {
         return int(this.charXML_.ObjectType);
      }
      
      public function skinType() : int
      {
         return int(this.charXML_.Texture);
      }
      
      public function level() : int
      {
         return int(this.charXML_.Level);
      }
      
      public function tex1() : int
      {
         return int(this.charXML_.Tex1);
      }
      
      public function tex2() : int
      {
         return int(this.charXML_.Tex2);
      }
      
      public function xp() : int
      {
         return int(this.charXML_.Exp);
      }
      
      public function fame() : int
      {
         return int(this.charXML_.CurrentFame);
      }
      
      public function hp() : int
      {
         return int(this.charXML_.MaxHitPoints);
      }
      
      public function mp() : int
      {
         return int(this.charXML_.MaxMagicPoints);
      }
      
      public function att() : int
      {
         return int(this.charXML_.Attack);
      }
      
      public function def() : int
      {
         return int(this.charXML_.Defense);
      }
      
      public function spd() : int
      {
         return int(this.charXML_.Speed);
      }
      
      public function dex() : int
      {
         return int(this.charXML_.Dexterity);
      }
      
      public function vit() : int
      {
         return int(this.charXML_.HpRegen);
      }
      
      public function wis() : int
      {
         return int(this.charXML_.MpRegen);
      }
      
      public function displayId() : String
      {
         return ObjectLibrary.typeToDisplayId_[this.objectType()];
      }
      
      public function getIcon(param1:int = 100) : BitmapData
      {
         var _loc2_:Injector = StaticInjectorContext.getInjector();
         var _loc3_:ClassesModel = _loc2_.getInstance(ClassesModel);
         var _loc4_:CharacterFactory = _loc2_.getInstance(CharacterFactory);
         var _loc5_:CharacterClass = _loc3_.getCharacterClass(this.objectType());
         var _loc6_:CharacterSkin = _loc5_.skins.getSkin(this.skinType()) || _loc5_.skins.getDefaultSkin();
         var _loc7_:BitmapData = _loc4_.makeIcon(_loc6_.template,param1,this.tex1(),this.tex2());
         return _loc7_;
      }
      
      public function bornOn() : String
      {
         if(!this.charXML_.hasOwnProperty("CreationDate"))
         {
            return "Unknown";
         }
         return this.charXML_.CreationDate;
      }
      
      public function getPetVO() : PetVO
      {
         return this.pet;
      }
      
      public function setPetVO(param1:PetVO) : void
      {
         this.pet = param1;
      }
   }
}
