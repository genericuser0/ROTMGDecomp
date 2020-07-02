package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.map.AbstractMap;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.osflash.signals.Signal;
   
   public class PlayerGroupMenu extends Menu
   {
       
      
      private var playerPanels_:Vector.<GameObjectListItem>;
      
      private var posY:uint = 4;
      
      public var map_:AbstractMap;
      
      public var players_:Vector.<Player>;
      
      public var teleportOption_:MenuOption;
      
      public var lineBreakDesign_:LineBreakDesign;
      
      public var unableToTeleport:Signal;
      
      public function PlayerGroupMenu(param1:AbstractMap, param2:Vector.<Player>)
      {
         this.playerPanels_ = new Vector.<GameObjectListItem>();
         this.unableToTeleport = new Signal();
         super(3552822,16777215);
         this.map_ = param1;
         this.players_ = param2.concat();
         this.createHeader();
         this.createPlayerList();
      }
      
      private function createPlayerList() : void
      {
         var _loc1_:Player = null;
         var _loc2_:GameObjectListItem = null;
         for each(_loc1_ in this.players_)
         {
            _loc2_ = new GameObjectListItem(11776947,true,_loc1_);
            _loc2_.x = 0;
            _loc2_.y = this.posY;
            addChild(_loc2_);
            this.playerPanels_.push(_loc2_);
            _loc2_.textReady.addOnce(this.onTextChanged);
            this.posY = this.posY + 32;
         }
      }
      
      private function onTextChanged() : void
      {
         var _loc1_:GameObjectListItem = null;
         draw();
         for each(_loc1_ in this.playerPanels_)
         {
            _loc1_.textReady.remove(this.onTextChanged);
         }
      }
      
      private function createHeader() : void
      {
         if(this.map_.allowPlayerTeleport())
         {
            this.teleportOption_ = new TeleportMenuOption(this.map_.player_);
            this.teleportOption_.x = 8;
            this.teleportOption_.y = 8;
            this.teleportOption_.addEventListener(MouseEvent.CLICK,this.onTeleport);
            addChild(this.teleportOption_);
            this.lineBreakDesign_ = new LineBreakDesign(150,1842204);
            this.lineBreakDesign_.x = 6;
            this.lineBreakDesign_.y = 40;
            addChild(this.lineBreakDesign_);
            this.posY = 52;
         }
      }
      
      private function onTeleport(param1:Event) : void
      {
         var _loc4_:Player = null;
         var _loc2_:Player = this.map_.player_;
         var _loc3_:Player = null;
         for each(_loc4_ in this.players_)
         {
            if(_loc2_.isTeleportEligible(_loc4_))
            {
               _loc3_ = _loc4_;
               if(_loc2_.msUtilTeleport() > Player.MS_BETWEEN_TELEPORT)
               {
                  if(_loc4_.isFellowGuild_)
                  {
                     break;
                  }
                  continue;
               }
               break;
            }
         }
         if(_loc3_ != null)
         {
            _loc2_.teleportTo(_loc3_);
         }
         else
         {
            this.unableToTeleport.dispatch();
         }
         remove();
      }
   }
}
