package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.PointUtil;
   import flash.display.BitmapData;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import kabam.rotmg.text.model.TextKey;
   
   public class ConditionEffect
   {
      
      public static const NOTHING:uint = 0;
      
      public static const DEAD:uint = 1;
      
      public static const QUIET:uint = 2;
      
      public static const WEAK:uint = 3;
      
      public static const SLOWED:uint = 4;
      
      public static const SICK:uint = 5;
      
      public static const DAZED:uint = 6;
      
      public static const STUNNED:uint = 7;
      
      public static const BLIND:uint = 8;
      
      public static const HALLUCINATING:uint = 9;
      
      public static const DRUNK:uint = 10;
      
      public static const CONFUSED:uint = 11;
      
      public static const STUN_IMMUNE:uint = 12;
      
      public static const INVISIBLE:uint = 13;
      
      public static const PARALYZED:uint = 14;
      
      public static const SPEEDY:uint = 15;
      
      public static const BLEEDING:uint = 16;
      
      public static const ARMORBROKENIMMUNE:uint = 17;
      
      public static const HEALING:uint = 18;
      
      public static const DAMAGING:uint = 19;
      
      public static const BERSERK:uint = 20;
      
      public static const PAUSED:uint = 21;
      
      public static const STASIS:uint = 22;
      
      public static const STASIS_IMMUNE:uint = 23;
      
      public static const INVINCIBLE:uint = 24;
      
      public static const INVULNERABLE:uint = 25;
      
      public static const ARMORED:uint = 26;
      
      public static const ARMORBROKEN:uint = 27;
      
      public static const HEXED:uint = 28;
      
      public static const NINJA_SPEEDY:uint = 29;
      
      public static const UNSTABLE:uint = 30;
      
      public static const DARKNESS:uint = 31;
      
      public static const SLOWED_IMMUNE:uint = 32;
      
      public static const DAZED_IMMUNE:uint = 33;
      
      public static const PARALYZED_IMMUNE:uint = 34;
      
      public static const PETRIFIED:uint = 35;
      
      public static const PETRIFIED_IMMUNE:uint = 36;
      
      public static const PET_EFFECT_ICON:uint = 37;
      
      public static const CURSE:uint = 38;
      
      public static const CURSE_IMMUNE:uint = 39;
      
      public static const HP_BOOST:uint = 40;
      
      public static const MP_BOOST:uint = 41;
      
      public static const ATT_BOOST:uint = 42;
      
      public static const DEF_BOOST:uint = 43;
      
      public static const SPD_BOOST:uint = 44;
      
      public static const VIT_BOOST:uint = 45;
      
      public static const WIS_BOOST:uint = 46;
      
      public static const DEX_BOOST:uint = 47;
      
      public static const SILENCED:uint = 48;
      
      public static const EXPOSED:uint = 49;
      
      public static const ENERGIZED:uint = 50;
      
      public static const HP_DEBUFF:uint = 51;
      
      public static const MP_DEBUFF:uint = 52;
      
      public static const ATT_DEBUFF:uint = 53;
      
      public static const DEF_DEBUFF:uint = 54;
      
      public static const SPD_DEBUFF:uint = 55;
      
      public static const VIT_DEBUFF:uint = 56;
      
      public static const WIS_DEBUFF:uint = 57;
      
      public static const DEX_DEBUFF:uint = 58;
      
      public static const INSPIRED:uint = 59;
      
      public static const GROUND_DAMAGE:uint = 99;
      
      public static const DEAD_BIT:uint = 1 << DEAD - 1;
      
      public static const QUIET_BIT:uint = 1 << QUIET - 1;
      
      public static const WEAK_BIT:uint = 1 << WEAK - 1;
      
      public static const SLOWED_BIT:uint = 1 << SLOWED - 1;
      
      public static const SICK_BIT:uint = 1 << SICK - 1;
      
      public static const DAZED_BIT:uint = 1 << DAZED - 1;
      
      public static const STUNNED_BIT:uint = 1 << STUNNED - 1;
      
      public static const BLIND_BIT:uint = 1 << BLIND - 1;
      
      public static const HALLUCINATING_BIT:uint = 1 << HALLUCINATING - 1;
      
      public static const DRUNK_BIT:uint = 1 << DRUNK - 1;
      
      public static const CONFUSED_BIT:uint = 1 << CONFUSED - 1;
      
      public static const STUN_IMMUNE_BIT:uint = 1 << STUN_IMMUNE - 1;
      
      public static const INVISIBLE_BIT:uint = 1 << INVISIBLE - 1;
      
      public static const PARALYZED_BIT:uint = 1 << PARALYZED - 1;
      
      public static const SPEEDY_BIT:uint = 1 << SPEEDY - 1;
      
      public static const BLEEDING_BIT:uint = 1 << BLEEDING - 1;
      
      public static const ARMORBROKEN_IMMUNE_BIT:uint = 1 << ARMORBROKENIMMUNE - 1;
      
      public static const HEALING_BIT:uint = 1 << HEALING - 1;
      
      public static const DAMAGING_BIT:uint = 1 << DAMAGING - 1;
      
      public static const BERSERK_BIT:uint = 1 << BERSERK - 1;
      
      public static const PAUSED_BIT:uint = 1 << PAUSED - 1;
      
      public static const STASIS_BIT:uint = 1 << STASIS - 1;
      
      public static const STASIS_IMMUNE_BIT:uint = 1 << STASIS_IMMUNE - 1;
      
      public static const INVINCIBLE_BIT:uint = 1 << INVINCIBLE - 1;
      
      public static const INVULNERABLE_BIT:uint = 1 << INVULNERABLE - 1;
      
      public static const ARMORED_BIT:uint = 1 << ARMORED - 1;
      
      public static const ARMORBROKEN_BIT:uint = 1 << ARMORBROKEN - 1;
      
      public static const HEXED_BIT:uint = 1 << HEXED - 1;
      
      public static const NINJA_SPEEDY_BIT:uint = 1 << NINJA_SPEEDY - 1;
      
      public static const UNSTABLE_BIT:uint = 1 << UNSTABLE - 1;
      
      public static const DARKNESS_BIT:uint = 1 << DARKNESS - 1;
      
      public static const SLOWED_IMMUNE_BIT:uint = 1 << SLOWED_IMMUNE - NEW_CON_THREASHOLD;
      
      public static const DAZED_IMMUNE_BIT:uint = 1 << DAZED_IMMUNE - NEW_CON_THREASHOLD;
      
      public static const PARALYZED_IMMUNE_BIT:uint = 1 << PARALYZED_IMMUNE - NEW_CON_THREASHOLD;
      
      public static const PETRIFIED_BIT:uint = 1 << PETRIFIED - NEW_CON_THREASHOLD;
      
      public static const PETRIFIED_IMMUNE_BIT:uint = 1 << PETRIFIED_IMMUNE - NEW_CON_THREASHOLD;
      
      public static const PET_EFFECT_ICON_BIT:uint = 1 << PET_EFFECT_ICON - NEW_CON_THREASHOLD;
      
      public static const CURSE_BIT:uint = 1 << CURSE - NEW_CON_THREASHOLD;
      
      public static const CURSE_IMMUNE_BIT:uint = 1 << CURSE_IMMUNE - NEW_CON_THREASHOLD;
      
      public static const HP_BOOST_BIT:uint = 1 << HP_BOOST - NEW_CON_THREASHOLD;
      
      public static const MP_BOOST_BIT:uint = 1 << MP_BOOST - NEW_CON_THREASHOLD;
      
      public static const ATT_BOOST_BIT:uint = 1 << ATT_BOOST - NEW_CON_THREASHOLD;
      
      public static const DEF_BOOST_BIT:uint = 1 << DEF_BOOST - NEW_CON_THREASHOLD;
      
      public static const SPD_BOOST_BIT:uint = 1 << SPD_BOOST - NEW_CON_THREASHOLD;
      
      public static const VIT_BOOST_BIT:uint = 1 << VIT_BOOST - NEW_CON_THREASHOLD;
      
      public static const WIS_BOOST_BIT:uint = 1 << WIS_BOOST - NEW_CON_THREASHOLD;
      
      public static const DEX_BOOST_BIT:uint = 1 << DEX_BOOST - NEW_CON_THREASHOLD;
      
      public static const SILENCED_BIT:uint = 1 << SILENCED - NEW_CON_THREASHOLD;
      
      public static const EXPOSED_BIT:uint = 1 << EXPOSED - NEW_CON_THREASHOLD;
      
      public static const ENERGIZED_BIT:uint = 1 << ENERGIZED - NEW_CON_THREASHOLD;
      
      public static const HP_DEBUFF_BIT:uint = 1 << HP_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const MP_DEBUFF_BIT:uint = 1 << MP_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const ATT_DEBUFF_BIT:uint = 1 << ATT_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const DEF_DEBUFF_BIT:uint = 1 << DEF_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const SPD_DEBUFF_BIT:uint = 1 << SPD_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const VIT_DEBUFF_BIT:uint = 1 << VIT_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const WIS_DEBUFF_BIT:uint = 1 << WIS_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const DEX_DEBUFF_BIT:uint = 1 << DEX_DEBUFF - NEW_CON_THREASHOLD;
      
      public static const INSPIRED_BIT:uint = 1 << INSPIRED - NEW_CON_THREASHOLD;
      
      public static const MAP_FILTER_BITMASK:uint = DRUNK_BIT | BLIND_BIT | PAUSED_BIT;
      
      public static const CE_FIRST_BATCH:uint = 0;
      
      public static const CE_SECOND_BATCH:uint = 1;
      
      public static const NUMBER_CE_BATCHES:uint = 2;
      
      public static const NEW_CON_THREASHOLD:uint = 32;
      
      public static var effects_:Vector.<ConditionEffect> = new <ConditionEffect>[new ConditionEffect("Nothing",0,null,TextKey.CONDITIONEFFECT_NOTHING),new ConditionEffect("Dead",DEAD_BIT,null,TextKey.CONDITIONEFFECT_DEAD),new ConditionEffect("Quiet",QUIET_BIT,[32],TextKey.CONDITIONEFFECT_QUIET),new ConditionEffect("Weak",WEAK_BIT,[34,35,36,37],TextKey.CONDITIONEFFECT_WEAK),new ConditionEffect("Slowed",SLOWED_BIT,[1],TextKey.CONDITION_EFFECT_SLOWED),new ConditionEffect("Sick",SICK_BIT,[39],TextKey.CONDITIONEFFECT_SICK),new ConditionEffect("Dazed",DAZED_BIT,[44],TextKey.CONDITION_EFFECT_DAZED),new ConditionEffect("Stunned",STUNNED_BIT,[45],TextKey.CONDITIONEFFECT_STUNNED),new ConditionEffect("Blind",BLIND_BIT,[41],TextKey.CONDITIONEFFECT_BLIND),new ConditionEffect("Hallucinating",HALLUCINATING_BIT,[42],TextKey.CONDITIONEFFECT_HALLUCINATING),new ConditionEffect("Drunk",DRUNK_BIT,[43],TextKey.CONDITIONEFFECT_DRUNK),new ConditionEffect("Confused",CONFUSED_BIT,[2],TextKey.CONDITIONEFFECT_CONFUSED),new ConditionEffect("Stun Immune",STUN_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_STUN_IMMUNE),new ConditionEffect("Invisible",INVISIBLE_BIT,null,TextKey.CONDITIONEFFECT_INVISIBLE),new ConditionEffect("Paralyzed",PARALYZED_BIT,[53,54],TextKey.CONDITION_EFFECT_PARALYZED),new ConditionEffect("Speedy",SPEEDY_BIT,[0],TextKey.CONDITIONEFFECT_SPEEDY),new ConditionEffect("Bleeding",BLEEDING_BIT,[46],TextKey.CONDITIONEFFECT_BLEEDING),new ConditionEffect("Armor Broken Immune",ARMORBROKEN_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_ARMOR_BROKEN_IMMUNE),new ConditionEffect("Healing",HEALING_BIT,[47],TextKey.CONDITIONEFFECT_HEALING),new ConditionEffect("Damaging",DAMAGING_BIT,[49],TextKey.CONDITIONEFFECT_DAMAGING),new ConditionEffect("Berserk",BERSERK_BIT,[50],TextKey.CONDITIONEFFECT_BERSERK),new ConditionEffect("Paused",PAUSED_BIT,null,TextKey.CONDITIONEFFECT_PAUSED),new ConditionEffect("Stasis",STASIS_BIT,null,TextKey.CONDITIONEFFECT_STASIS),new ConditionEffect("Stasis Immune",STASIS_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_STASIS_IMMUNE),new ConditionEffect("Invincible",INVINCIBLE_BIT,null,TextKey.CONDITIONEFFECT_INVINCIBLE),new ConditionEffect("Invulnerable",INVULNERABLE_BIT,[17],TextKey.CONDITIONEFFECT_INVULNERABLE),new ConditionEffect("Armored",ARMORED_BIT,[16],TextKey.CONDITIONEFFECT_ARMORED),new ConditionEffect("Armor Broken",ARMORBROKEN_BIT,[55],TextKey.CONDITIONEFFECT_ARMOR_BROKEN),new ConditionEffect("Hexed",HEXED_BIT,[42],TextKey.CONDITIONEFFECT_HEXED),new ConditionEffect("Ninja Speedy",NINJA_SPEEDY_BIT,[0],TextKey.CONDITIONEFFECT_NINJA_SPEEDY),new ConditionEffect("Unstable",UNSTABLE_BIT,[56],TextKey.CONDITIONEFFECT_UNSTABLE),new ConditionEffect("Darkness",DARKNESS_BIT,[57],TextKey.CONDITIONEFFECT_DARKNESS),new ConditionEffect("Slowed Immune",SLOWED_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_SLOWIMMUNE),new ConditionEffect("Dazed Immune",DAZED_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_DAZEDIMMUNE),new ConditionEffect("Paralyzed Immune",PARALYZED_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_PARALYZEDIMMUNE),new ConditionEffect("Petrify",PETRIFIED_BIT,null,TextKey.CONDITIONEFFECT_PETRIFIED),new ConditionEffect("Petrify Immune",PETRIFIED_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_PETRIFY_IMMUNE),new ConditionEffect("Pet Disable",PET_EFFECT_ICON_BIT,[27],TextKey.CONDITIONEFFECT_STASIS,true),new ConditionEffect("Curse",CURSE_BIT,[58],TextKey.CONDITIONEFFECT_CURSE),new ConditionEffect("Curse Immune",CURSE_IMMUNE_BIT,null,TextKey.CONDITIONEFFECT_CURSE_IMMUNE),new ConditionEffect("HP Boost",HP_BOOST_BIT,[32],"HP Boost",true),new ConditionEffect("MP Boost",MP_BOOST_BIT,[33],"MP Boost",true),new ConditionEffect("Att Boost",ATT_BOOST_BIT,[34],"Att Boost",true),new ConditionEffect("Def Boost",DEF_BOOST_BIT,[35],"Def Boost",true),new ConditionEffect("Spd Boost",SPD_BOOST_BIT,[36],"Spd Boost",true),new ConditionEffect("Vit Boost",VIT_BOOST_BIT,[38],"Vit Boost",true),new ConditionEffect("Wis Boost",WIS_BOOST_BIT,[39],"Wis Boost",true),new ConditionEffect("Dex Boost",DEX_BOOST_BIT,[37],"Dex Boost",true),new ConditionEffect("Silenced",SILENCED_BIT,[33],"Silenced"),new ConditionEffect("Exposed",EXPOSED_BIT,[59],"Exposed"),new ConditionEffect("Energized",ENERGIZED_BIT,[60],"Energized"),new ConditionEffect("HP Debuff",HP_DEBUFF_BIT,[48],"HP Debuff",true),new ConditionEffect("MP Debuff",MP_DEBUFF_BIT,[49],"MP Debuff",true),new ConditionEffect("Att Debuff",ATT_DEBUFF_BIT,[50],"Att Debuff",true),new ConditionEffect("Def Debuff",DEF_DEBUFF_BIT,[51],"Def Debuff",true),new ConditionEffect("Spd Debuff",SPD_DEBUFF_BIT,[52],"Spd Debuff",true),new ConditionEffect("Vit Debuff",VIT_DEBUFF_BIT,[54],"Vit Debuff",true),new ConditionEffect("Wis Debuff",WIS_DEBUFF_BIT,[55],"Wis Debuff",true),new ConditionEffect("Dex Debuff",DEX_DEBUFF_BIT,[53],"Dex Debuff",true),new ConditionEffect("Inspired",INSPIRED_BIT,[62],"Inspired")];
      
      private static var conditionEffectFromName_:Object = null;
      
      private static var effectIconCache:Object = null;
      
      private static var bitToIcon_:Object = null;
      
      private static const GLOW_FILTER:GlowFilter = new GlowFilter(0,0.3,6,6,2,BitmapFilterQuality.LOW,false,false);
      
      private static var bitToIcon2_:Object = null;
       
      
      public var name_:String;
      
      public var bit_:uint;
      
      public var iconOffsets_:Array;
      
      public var localizationKey_:String;
      
      public var icon16Bit_:Boolean;
      
      public function ConditionEffect(param1:String, param2:uint, param3:Array, param4:String = "", param5:Boolean = false)
      {
         super();
         this.name_ = param1;
         this.bit_ = param2;
         this.iconOffsets_ = param3;
         this.localizationKey_ = param4;
         this.icon16Bit_ = param5;
      }
      
      public static function getConditionEffectFromName(param1:String) : uint
      {
         var _loc2_:uint = 0;
         if(conditionEffectFromName_ == null)
         {
            conditionEffectFromName_ = new Object();
            _loc2_ = 0;
            while(_loc2_ < effects_.length)
            {
               conditionEffectFromName_[effects_[_loc2_].name_] = _loc2_;
               _loc2_++;
            }
         }
         return conditionEffectFromName_[param1];
      }
      
      public static function getConditionEffectEnumFromName(param1:String) : ConditionEffect
      {
         var _loc2_:ConditionEffect = null;
         for each(_loc2_ in effects_)
         {
            if(_loc2_.name_ == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getConditionEffectIcons(param1:uint, param2:Vector.<BitmapData>, param3:int) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<BitmapData> = null;
         while(param1 != 0)
         {
            _loc4_ = param1 & param1 - 1;
            _loc5_ = param1 ^ _loc4_;
            _loc6_ = getIconsFromBit(_loc5_);
            if(_loc6_ != null)
            {
               param2.push(_loc6_[param3 % _loc6_.length]);
            }
            param1 = _loc4_;
         }
      }
      
      public static function getConditionEffectIcons2(param1:uint, param2:Vector.<BitmapData>, param3:int) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<BitmapData> = null;
         while(param1 != 0)
         {
            _loc4_ = param1 & param1 - 1;
            _loc5_ = param1 ^ _loc4_;
            _loc6_ = getIconsFromBit2(_loc5_);
            if(_loc6_ != null)
            {
               param2.push(_loc6_[param3 % _loc6_.length]);
            }
            param1 = _loc4_;
         }
      }
      
      public static function addConditionEffectIcon(param1:Vector.<BitmapData>, param2:int, param3:Boolean) : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = null;
         var _loc6_:Matrix = null;
         if(effectIconCache == null)
         {
            effectIconCache = {};
         }
         if(effectIconCache[param2])
         {
            _loc4_ = effectIconCache[param2];
         }
         else
         {
            _loc5_ = new Matrix();
            _loc5_.translate(4,4);
            _loc6_ = new Matrix();
            _loc6_.translate(1.5,1.5);
            if(param3)
            {
               _loc4_ = new BitmapDataSpy(18,18,true,0);
               _loc4_.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig",param2),_loc6_);
            }
            else
            {
               _loc4_ = new BitmapDataSpy(16,16,true,0);
               _loc4_.draw(AssetLibrary.getImageFromSet("lofiInterface2",param2),_loc5_);
            }
            _loc4_ = GlowRedrawer.outlineGlow(_loc4_,4294967295);
            _loc4_.applyFilter(_loc4_,_loc4_.rect,PointUtil.ORIGIN,GLOW_FILTER);
            effectIconCache[param2] = _loc4_;
         }
         param1.push(_loc4_);
      }
      
      private static function getIconsFromBit(param1:uint) : Vector.<BitmapData>
      {
         var _loc2_:Matrix = null;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<BitmapData> = null;
         var _loc5_:int = 0;
         var _loc6_:BitmapData = null;
         if(bitToIcon_ == null)
         {
            bitToIcon_ = new Object();
            _loc2_ = new Matrix();
            _loc2_.translate(4,4);
            _loc3_ = 0;
            while(_loc3_ < 32)
            {
               _loc4_ = null;
               if(effects_[_loc3_].iconOffsets_ != null)
               {
                  _loc4_ = new Vector.<BitmapData>();
                  _loc5_ = 0;
                  while(_loc5_ < effects_[_loc3_].iconOffsets_.length)
                  {
                     _loc6_ = new BitmapDataSpy(16,16,true,0);
                     _loc6_.draw(AssetLibrary.getImageFromSet("lofiInterface2",effects_[_loc3_].iconOffsets_[_loc5_]),_loc2_);
                     _loc6_ = GlowRedrawer.outlineGlow(_loc6_,4294967295);
                     _loc6_.applyFilter(_loc6_,_loc6_.rect,PointUtil.ORIGIN,GLOW_FILTER);
                     _loc4_.push(_loc6_);
                     _loc5_++;
                  }
               }
               bitToIcon_[effects_[_loc3_].bit_] = _loc4_;
               _loc3_++;
            }
         }
         return bitToIcon_[param1];
      }
      
      private static function getIconsFromBit2(param1:uint) : Vector.<BitmapData>
      {
         var _loc2_:Vector.<BitmapData> = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Matrix = null;
         var _loc5_:Matrix = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         if(bitToIcon2_ == null)
         {
            bitToIcon2_ = [];
            _loc2_ = new Vector.<BitmapData>();
            _loc4_ = new Matrix();
            _loc4_.translate(4,4);
            _loc5_ = new Matrix();
            _loc5_.translate(1.5,1.5);
            _loc6_ = 32;
            while(_loc6_ < effects_.length)
            {
               _loc2_ = null;
               if(effects_[_loc6_].iconOffsets_ != null)
               {
                  _loc2_ = new Vector.<BitmapData>();
                  _loc7_ = 0;
                  while(_loc7_ < effects_[_loc6_].iconOffsets_.length)
                  {
                     if(effects_[_loc6_].icon16Bit_)
                     {
                        _loc3_ = new BitmapDataSpy(18,18,true,0);
                        _loc3_.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig",effects_[_loc6_].iconOffsets_[_loc7_]),_loc5_);
                     }
                     else
                     {
                        _loc3_ = new BitmapDataSpy(16,16,true,0);
                        _loc3_.draw(AssetLibrary.getImageFromSet("lofiInterface2",effects_[_loc6_].iconOffsets_[_loc7_]),_loc4_);
                     }
                     _loc3_ = GlowRedrawer.outlineGlow(_loc3_,4294967295);
                     _loc3_.applyFilter(_loc3_,_loc3_.rect,PointUtil.ORIGIN,GLOW_FILTER);
                     _loc2_.push(_loc3_);
                     _loc7_++;
                  }
               }
               bitToIcon2_[effects_[_loc6_].bit_] = _loc2_;
               _loc6_++;
            }
         }
         if(bitToIcon2_ != null && bitToIcon2_[param1] != null)
         {
            return bitToIcon2_[param1];
         }
         return null;
      }
   }
}
