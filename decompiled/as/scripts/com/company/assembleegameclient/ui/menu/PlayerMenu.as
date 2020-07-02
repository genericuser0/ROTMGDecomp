package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.game.AGameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.util.AssetLibrary;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import io.decagames.rotmg.social.config.FriendsActions;
   import io.decagames.rotmg.social.model.FriendRequestVO;
   import io.decagames.rotmg.social.signals.FriendActionSignal;
   import kabam.rotmg.chat.control.ShowChatInputSignal;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PlayerMenu extends Menu
   {
       
      
      public var gs_:AGameSprite;
      
      public var playerName_:String;
      
      public var player_:Player;
      
      public var playerPanel_:GameObjectListItem;
      
      public var namePlate_:TextFieldDisplayConcrete;
      
      public function PlayerMenu()
      {
         super(3552822,16777215);
      }
      
      public function initDifferentServer(param1:AGameSprite, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:MenuOption = null;
         this.gs_ = param1;
         this.playerName_ = param2;
         this.player_ = null;
         this.namePlate_ = new TextFieldDisplayConcrete().setSize(13).setColor(16572160).setHTML(true);
         this.namePlate_.setStringBuilder(new LineBuilder().setParams(this.playerName_));
         this.namePlate_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.namePlate_);
         this.yOffset = this.yOffset - 13;
         _loc5_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",21),16777215,TextKey.PLAYERMENU_PM);
         _loc5_.addEventListener(MouseEvent.CLICK,this.onPrivateMessage);
         addOption(_loc5_);
         _loc5_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",8),16777215,TextKey.FRIEND_BLOCK_BUTTON);
         _loc5_.addEventListener(MouseEvent.CLICK,this.onIgnoreDifferentServer);
         addOption(_loc5_);
         _loc5_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",18),16777215,"Add Friend");
         _loc5_.addEventListener(MouseEvent.CLICK,this.onAddFriend);
         addOption(_loc5_);
      }
      
      private function onIgnoreDifferentServer(param1:Event) : void
      {
         this.gs_.gsc_.playerText("/ignore " + this.playerName_);
         remove();
      }
      
      public function init(param1:AGameSprite, param2:Player) : void
      {
         var _loc3_:MenuOption = null;
         this.gs_ = param1;
         this.playerName_ = param2.name_;
         this.player_ = param2;
         this.playerPanel_ = new GameObjectListItem(11776947,true,this.player_,true);
         this.yOffset = this.yOffset + 7;
         addChild(this.playerPanel_);
         if(Player.isAdmin || Player.isMod)
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",10),16777215,"Ban MultiBoxer");
            _loc3_.addEventListener(MouseEvent.CLICK,this.onKickMultiBox);
            addOption(_loc3_);
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",10),16777215,"Ban RWT");
            _loc3_.addEventListener(MouseEvent.CLICK,this.onKickRWT);
            addOption(_loc3_);
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",10),16777215,"Ban Cheat");
            _loc3_.addEventListener(MouseEvent.CLICK,this.onKickCheat);
            addOption(_loc3_);
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",4),16777215,TextKey.PLAYERMENU_MUTE);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onMute);
            addOption(_loc3_);
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",3),16777215,TextKey.PLAYERMENU_UNMUTE);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onUnMute);
            addOption(_loc3_);
         }
         if(this.gs_.map.allowPlayerTeleport() && this.player_.isTeleportEligible(this.player_))
         {
            _loc3_ = new TeleportMenuOption(this.gs_.map.player_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onTeleport);
            addOption(_loc3_);
         }
         if(this.gs_.map.player_.guildRank_ >= GuildUtil.OFFICER && (param2.guildName_ == null || param2.guildName_.length == 0))
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",10),16777215,TextKey.PLAYERMENU_INVITE);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onInvite);
            addOption(_loc3_);
         }
         if(!this.player_.starred_)
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2",5),16777215,TextKey.PLAYERMENU_LOCK);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onLock);
            addOption(_loc3_);
         }
         else
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2",6),16777215,TextKey.PLAYERMENU_UNLOCK);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onUnlock);
            addOption(_loc3_);
         }
         _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",7),16777215,TextKey.PLAYERMENU_TRADE);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onTrade);
         addOption(_loc3_);
         _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",21),16777215,TextKey.PLAYERMENU_PM);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onPrivateMessage);
         addOption(_loc3_);
         if(this.player_.isFellowGuild_)
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",21),16777215,TextKey.PLAYERMENU_GUILDCHAT);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onGuildMessage);
            addOption(_loc3_);
         }
         if(!this.player_.ignored_)
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",8),16777215,TextKey.PLAYERMENU_IGNORE);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onIgnore);
            addOption(_loc3_);
         }
         else
         {
            _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",9),16777215,TextKey.PLAYERMENU_UNIGNORE);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onUnignore);
            addOption(_loc3_);
         }
         _loc3_ = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",18),16777215,"Add Friend");
         _loc3_.addEventListener(MouseEvent.CLICK,this.onAddFriend);
         addOption(_loc3_);
      }
      
      private function onKickMultiBox(param1:Event) : void
      {
         this.gs_.gsc_.playerText("/akick " + this.player_.name_ + " Multiboxing");
         remove();
      }
      
      private function onKickRWT(param1:Event) : void
      {
         this.gs_.gsc_.playerText("/akick " + this.player_.name_ + " RWT");
         remove();
      }
      
      private function onKickCheat(param1:Event) : void
      {
         this.gs_.gsc_.playerText("/akick " + this.player_.name_ + " Cheating");
         remove();
      }
      
      private function onMute(param1:Event) : void
      {
         this.gs_.gsc_.playerText("/mute " + this.player_.name_);
         remove();
      }
      
      private function onUnMute(param1:Event) : void
      {
         this.gs_.gsc_.playerText("/unmute " + this.player_.name_);
         remove();
      }
      
      private function onPrivateMessage(param1:Event) : void
      {
         var _loc2_:ShowChatInputSignal = StaticInjectorContext.getInjector().getInstance(ShowChatInputSignal);
         _loc2_.dispatch(true,"/tell " + this.playerName_ + " ");
         remove();
      }
      
      private function onAddFriend(param1:Event) : void
      {
         var _loc2_:FriendActionSignal = StaticInjectorContext.getInjector().getInstance(FriendActionSignal);
         _loc2_.dispatch(new FriendRequestVO(FriendsActions.INVITE,this.playerName_));
         remove();
      }
      
      private function onTradeMessage(param1:Event) : void
      {
         var _loc2_:ShowChatInputSignal = StaticInjectorContext.getInjector().getInstance(ShowChatInputSignal);
         _loc2_.dispatch(true,"/trade " + this.playerName_);
         remove();
      }
      
      private function onGuildMessage(param1:Event) : void
      {
         var _loc2_:ShowChatInputSignal = StaticInjectorContext.getInjector().getInstance(ShowChatInputSignal);
         _loc2_.dispatch(true,"/g ");
         remove();
      }
      
      private function onTeleport(param1:Event) : void
      {
         this.gs_.map.player_.teleportTo(this.player_);
         remove();
      }
      
      private function onInvite(param1:Event) : void
      {
         this.gs_.gsc_.guildInvite(this.playerName_);
         remove();
      }
      
      private function onLock(param1:Event) : void
      {
         this.gs_.map.party_.lockPlayer(this.player_);
         remove();
      }
      
      private function onUnlock(param1:Event) : void
      {
         this.gs_.map.party_.unlockPlayer(this.player_);
         remove();
      }
      
      private function onTrade(param1:Event) : void
      {
         this.gs_.gsc_.requestTrade(this.playerName_);
         remove();
      }
      
      private function onIgnore(param1:Event) : void
      {
         this.gs_.map.party_.ignorePlayer(this.player_);
         remove();
      }
      
      private function onUnignore(param1:Event) : void
      {
         this.gs_.map.party_.unignorePlayer(this.player_);
         remove();
      }
   }
}
