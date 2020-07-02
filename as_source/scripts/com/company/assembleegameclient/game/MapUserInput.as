package com.company.assembleegameclient.game
{
   import com.company.assembleegameclient.map.Square#93;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.assembleegameclient.tutorial.Tutorial;
   import com.company.assembleegameclient.tutorial.doneAction;
   import com.company.assembleegameclient.ui.options.Options;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.KeyCodes;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.utils.getTimer;
   import io.decagames.rotmg.social.SocialPopupView;
   import io.decagames.rotmg.ui.popups.signals.CloseAllPopupsSignal;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupByClassSignal;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.chat.model.ChatMessage;
   import kabam.rotmg.constants.GeneralConstants;
   import kabam.rotmg.constants.UseType;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.view.Layers;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.friends.view.FriendListView;
   import kabam.rotmg.game.model.PotionInventoryModel;
   import kabam.rotmg.game.model.UseBuyPotionVO;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   import kabam.rotmg.game.signals.ExitGameSignal;
   import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
   import kabam.rotmg.game.signals.SetTextBoxVisibilitySignal;
   import kabam.rotmg.game.signals.UseBuyPotionSignal;
   import kabam.rotmg.game.view.components.StatsTabHotKeyInputSignal;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.minimap.control.MiniMapZoomSignal;
   import kabam.rotmg.ui.UIUtils;
   import kabam.rotmg.ui.model.TabStripModel;
   import kabam.rotmg.ui.signals.ToggleRealmQuestsDisplaySignal;
   import net.hires.debug.Stats;
   import org.swiftsuspenders.Injector;
   
   public class MapUserInput
   {
      
      private static var stats_:Stats = new Stats();
      
      private static const MOUSE_DOWN_WAIT_PERIOD:uint = 175;
      
      private static var arrowWarning_:Boolean = false;
       
      
      public var gs_:GameSprite;
      
      private var moveLeft_:Boolean = false;
      
      private var moveRight_:Boolean = false;
      
      private var moveUp_:Boolean = false;
      
      private var moveDown_:Boolean = false;
      
      private var rotateLeft_:Boolean = false;
      
      private var rotateRight_:Boolean = false;
      
      private var mouseDown_:Boolean = false;
      
      private var autofire_:Boolean = false;
      
      private var currentString:String = "";
      
      private var specialKeyDown_:Boolean = false;
      
      private var enablePlayerInput_:Boolean = true;
      
      private var giftStatusUpdateSignal:GiftStatusUpdateSignal;
      
      private var addTextLine:AddTextLineSignal;
      
      private var setTextBoxVisibility:SetTextBoxVisibilitySignal;
      
      private var statsTabHotKeyInputSignal:StatsTabHotKeyInputSignal;
      
      private var toggleRealmQuestsDisplaySignal:ToggleRealmQuestsDisplaySignal;
      
      private var miniMapZoom:MiniMapZoomSignal;
      
      private var useBuyPotionSignal:UseBuyPotionSignal;
      
      private var potionInventoryModel:PotionInventoryModel;
      
      private var openDialogSignal:OpenDialogSignal;
      
      private var closeDialogSignal:CloseDialogsSignal;
      
      private var closePopupByClassSignal:ClosePopupByClassSignal;
      
      private var tabStripModel:TabStripModel;
      
      private var layers:Layers;
      
      private var exitGame:ExitGameSignal;
      
      private var areFKeysAvailable:Boolean;
      
      private var isFriendsListOpen:Boolean;
      
      public function MapUserInput(param1:GameSprite)
      {
         super();
         this.gs_ = param1;
         this.gs_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.gs_.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         var _loc2_:Injector = StaticInjectorContext.getInjector();
         this.giftStatusUpdateSignal = _loc2_.getInstance(GiftStatusUpdateSignal);
         this.addTextLine = _loc2_.getInstance(AddTextLineSignal);
         this.setTextBoxVisibility = _loc2_.getInstance(SetTextBoxVisibilitySignal);
         this.miniMapZoom = _loc2_.getInstance(MiniMapZoomSignal);
         this.useBuyPotionSignal = _loc2_.getInstance(UseBuyPotionSignal);
         this.potionInventoryModel = _loc2_.getInstance(PotionInventoryModel);
         this.tabStripModel = _loc2_.getInstance(TabStripModel);
         this.layers = _loc2_.getInstance(Layers);
         this.statsTabHotKeyInputSignal = _loc2_.getInstance(StatsTabHotKeyInputSignal);
         this.toggleRealmQuestsDisplaySignal = _loc2_.getInstance(ToggleRealmQuestsDisplaySignal);
         this.exitGame = _loc2_.getInstance(ExitGameSignal);
         this.openDialogSignal = _loc2_.getInstance(OpenDialogSignal);
         this.closeDialogSignal = _loc2_.getInstance(CloseDialogsSignal);
         this.closePopupByClassSignal = _loc2_.getInstance(ClosePopupByClassSignal);
         var _loc3_:ApplicationSetup = _loc2_.getInstance(ApplicationSetup);
         this.areFKeysAvailable = _loc3_.areDeveloperHotkeysEnabled();
         this.gs_.map.signalRenderSwitch.add(this.onRenderSwitch);
      }
      
      public function onRenderSwitch(param1:Boolean) : void
      {
         if(param1)
         {
            this.gs_.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.gs_.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.gs_.map.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.gs_.map.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         else
         {
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.gs_.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.gs_.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
      }
      
      public function clearInput() : void
      {
         this.moveLeft_ = false;
         this.moveRight_ = false;
         this.moveUp_ = false;
         this.moveDown_ = false;
         this.rotateLeft_ = false;
         this.rotateRight_ = false;
         this.mouseDown_ = false;
         this.autofire_ = false;
         this.setPlayerMovement();
      }
      
      public function setEnablePlayerInput(param1:Boolean) : void
      {
         if(this.enablePlayerInput_ != param1)
         {
            this.enablePlayerInput_ = param1;
            this.clearInput();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc2_:Stage = this.gs_.stage;
         _loc2_.addEventListener(Event.ACTIVATE,this.onActivate);
         _loc2_.addEventListener(Event.DEACTIVATE,this.onDeactivate);
         _loc2_.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         _loc2_.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         _loc2_.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         if(Parameters.isGpuRender())
         {
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         else
         {
            this.gs_.map.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.gs_.map.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         _loc2_.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         _loc2_.addEventListener(MouseEvent.RIGHT_CLICK,this.disableRightClick);
      }
      
      public function disableRightClick(param1:MouseEvent) : void
      {
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         var _loc2_:Stage = this.gs_.stage;
         _loc2_.removeEventListener(Event.ACTIVATE,this.onActivate);
         _loc2_.removeEventListener(Event.DEACTIVATE,this.onDeactivate);
         _loc2_.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         _loc2_.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         _loc2_.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         if(Parameters.isGpuRender())
         {
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         else
         {
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         _loc2_.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         _loc2_.removeEventListener(MouseEvent.RIGHT_CLICK,this.disableRightClick);
      }
      
      private function onActivate(param1:Event) : void
      {
      }
      
      private function onDeactivate(param1:Event) : void
      {
         this.clearInput();
      }
      
      public function onMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Player = this.gs_.map.player_;
         if(_loc2_ == null)
         {
            return;
         }
         if(!this.enablePlayerInput_)
         {
            return;
         }
         if(param1.shiftKey)
         {
            _loc4_ = _loc2_.equipment_[1];
            if(_loc4_ == -1)
            {
               return;
            }
            _loc5_ = ObjectLibrary.xmlLibrary_[_loc4_];
            if(_loc5_ == null || _loc5_.hasOwnProperty("EndMpCost"))
            {
               return;
            }
            if(_loc2_.isUnstable())
            {
               _loc6_ = Math.random() * 600 - 300;
               _loc7_ = Math.random() * 600 - 325;
            }
            else
            {
               _loc6_ = this.gs_.map.mouseX;
               _loc7_ = this.gs_.map.mouseY;
            }
            if(Parameters.isGpuRender())
            {
               if(param1.currentTarget == param1.target || param1.target == this.gs_.map || param1.target == this.gs_ || param1.target == this.gs_.map.mapHitArea)
               {
                  _loc2_.useAltWeapon(_loc6_,_loc7_,UseType.START_USE);
               }
            }
            else
            {
               _loc2_.useAltWeapon(_loc6_,_loc7_,UseType.START_USE);
            }
            return;
         }
         if(Parameters.isGpuRender())
         {
            if(param1.currentTarget == param1.target || param1.target == this.gs_.map || param1.target == this.gs_ || param1.currentTarget == this.gs_.chatBox_.list || param1.target == this.gs_.map.mapHitArea)
            {
               _loc3_ = Math.atan2(this.gs_.map.mouseY,this.gs_.map.mouseX);
            }
            else
            {
               return;
            }
         }
         else
         {
            _loc3_ = Math.atan2(this.gs_.map.mouseY,this.gs_.map.mouseX);
         }
         doneAction(this.gs_,Tutorial.ATTACK_ACTION);
         if(_loc2_.isUnstable())
         {
            _loc2_.attemptAttackAngle(Math.random() * Math.PI * 2);
         }
         else
         {
            _loc2_.attemptAttackAngle(_loc3_);
         }
         this.mouseDown_ = true;
      }
      
      public function onMouseUp(param1:MouseEvent) : void
      {
         this.mouseDown_ = false;
         var _loc2_:Player = this.gs_.map.player_;
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.isShooting = false;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            this.miniMapZoom.dispatch(MiniMapZoomSignal.IN);
         }
         else
         {
            this.miniMapZoom.dispatch(MiniMapZoomSignal.OUT);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Player = null;
         var _loc3_:Number = NaN;
         doneAction(this.gs_,Tutorial.UPDATE_ACTION);
         if(this.enablePlayerInput_ && (this.mouseDown_ || this.autofire_))
         {
            _loc2_ = this.gs_.map.player_;
            if(_loc2_ != null)
            {
               if(_loc2_.isUnstable())
               {
                  _loc2_.attemptAttackAngle(Math.random() * Math.PI * 2);
               }
               else
               {
                  _loc3_ = Math.atan2(this.gs_.map.mouseY,this.gs_.map.mouseX);
                  _loc2_.attemptAttackAngle(_loc3_);
               }
            }
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc4_:CloseAllPopupsSignal = null;
         var _loc5_:AddTextLineSignal = null;
         var _loc6_:ChatMessage = null;
         var _loc7_:GameObject = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:ShowPopupSignal = null;
         var _loc12_:OpenDialogSignal = null;
         var _loc13_:Square = null;
         var _loc2_:Stage = this.gs_.stage;
         this.currentString = this.currentString + String.fromCharCode(param1.keyCode).toLowerCase();
         if(this.currentString == UIUtils.EXPERIMENTAL_MENU_PASSWORD.slice(0,this.currentString.length))
         {
            if(this.currentString.length == UIUtils.EXPERIMENTAL_MENU_PASSWORD.length)
            {
               _loc5_ = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
               _loc6_ = new ChatMessage();
               _loc6_.name = Parameters.SERVER_CHAT_NAME;
               this.currentString = "";
               UIUtils.SHOW_EXPERIMENTAL_MENU = !UIUtils.SHOW_EXPERIMENTAL_MENU;
               _loc6_.text = !!UIUtils.SHOW_EXPERIMENTAL_MENU?"Experimental menu activated":"Experimental menu deactivated";
               _loc5_.dispatch(_loc6_);
            }
         }
         else
         {
            this.currentString = "";
         }
         switch(param1.keyCode)
         {
            case KeyCodes.F1:
            case KeyCodes.F2:
            case KeyCodes.F3:
            case KeyCodes.F4:
            case KeyCodes.F5:
            case KeyCodes.F6:
            case KeyCodes.F7:
            case KeyCodes.F8:
            case KeyCodes.F9:
            case KeyCodes.F10:
            case KeyCodes.F11:
            case KeyCodes.F12:
            case KeyCodes.INSERT:
            case KeyCodes.ALTERNATE:
               break;
            default:
               if(_loc2_.focus != null)
               {
                  return;
               }
               break;
         }
         var _loc3_:Player = this.gs_.map.player_;
         switch(param1.keyCode)
         {
            case Parameters.data_.moveUp:
               doneAction(this.gs_,Tutorial.MOVE_FORWARD_ACTION);
               this.moveUp_ = true;
               break;
            case Parameters.data_.moveDown:
               doneAction(this.gs_,Tutorial.MOVE_BACKWARD_ACTION);
               this.moveDown_ = true;
               break;
            case Parameters.data_.moveLeft:
               doneAction(this.gs_,Tutorial.MOVE_LEFT_ACTION);
               this.moveLeft_ = true;
               break;
            case Parameters.data_.moveRight:
               doneAction(this.gs_,Tutorial.MOVE_RIGHT_ACTION);
               this.moveRight_ = true;
               break;
            case Parameters.data_.rotateLeft:
               if(!Parameters.data_.allowRotation)
               {
                  break;
               }
               doneAction(this.gs_,Tutorial.ROTATE_LEFT_ACTION);
               this.rotateLeft_ = true;
               break;
            case Parameters.data_.rotateRight:
               if(!Parameters.data_.allowRotation)
               {
                  break;
               }
               doneAction(this.gs_,Tutorial.ROTATE_RIGHT_ACTION);
               this.rotateRight_ = true;
               break;
            case Parameters.data_.resetToDefaultCameraAngle:
               Parameters.data_.cameraAngle = Parameters.data_.defaultCameraAngle;
               Parameters.save();
               break;
            case Parameters.data_.useSpecial:
               _loc7_ = this.gs_.map.player_;
               if(_loc7_ == null)
               {
                  break;
               }
               if(!this.specialKeyDown_)
               {
                  if(_loc3_.isUnstable())
                  {
                     _loc8_ = Math.random() * 600 - 300;
                     _loc9_ = Math.random() * 600 - 325;
                  }
                  else
                  {
                     _loc8_ = this.gs_.map.mouseX;
                     _loc9_ = this.gs_.map.mouseY;
                  }
                  _loc10_ = _loc3_.useAltWeapon(_loc8_,_loc9_,UseType.START_USE);
                  if(_loc10_)
                  {
                     this.specialKeyDown_ = true;
                  }
               }
               break;
            case Parameters.data_.autofireToggle:
               this.gs_.map.player_.isShooting = this.autofire_ = !this.autofire_;
               break;
            case Parameters.data_.toggleHPBar:
               Parameters.data_.HPBar = Parameters.data_.HPBar != 0?0:1;
               break;
            case Parameters.data_.toggleProjectiles:
               Parameters.data_.disableAllyShoot = Parameters.data_.disableAllyShoot != 0?0:1;
               break;
            case Parameters.data_.toggleMasterParticles:
               Parameters.data_.noParticlesMaster = !Parameters.data_.noParticlesMaster;
               break;
            case Parameters.data_.useInvSlot1:
               this.useItem(4);
               break;
            case Parameters.data_.useInvSlot2:
               this.useItem(5);
               break;
            case Parameters.data_.useInvSlot3:
               this.useItem(6);
               break;
            case Parameters.data_.useInvSlot4:
               this.useItem(7);
               break;
            case Parameters.data_.useInvSlot5:
               this.useItem(8);
               break;
            case Parameters.data_.useInvSlot6:
               this.useItem(9);
               break;
            case Parameters.data_.useInvSlot7:
               this.useItem(10);
               break;
            case Parameters.data_.useInvSlot8:
               this.useItem(11);
               break;
            case Parameters.data_.useHealthPotion:
               if(this.potionInventoryModel.getPotionModel(PotionInventoryModel.HEALTH_POTION_ID).available)
               {
                  this.useBuyPotionSignal.dispatch(new UseBuyPotionVO(PotionInventoryModel.HEALTH_POTION_ID,UseBuyPotionVO.CONTEXTBUY));
               }
               break;
            case Parameters.data_.GPURenderToggle:
               Parameters.data_.GPURender = !Parameters.data_.GPURender;
               break;
            case Parameters.data_.useMagicPotion:
               if(this.potionInventoryModel.getPotionModel(PotionInventoryModel.MAGIC_POTION_ID).available)
               {
                  this.useBuyPotionSignal.dispatch(new UseBuyPotionVO(PotionInventoryModel.MAGIC_POTION_ID,UseBuyPotionVO.CONTEXTBUY));
               }
               break;
            case Parameters.data_.miniMapZoomOut:
               this.miniMapZoom.dispatch(MiniMapZoomSignal.OUT);
               break;
            case Parameters.data_.miniMapZoomIn:
               this.miniMapZoom.dispatch(MiniMapZoomSignal.IN);
               break;
            case Parameters.data_.togglePerformanceStats:
               this.togglePerformanceStats();
               break;
            case Parameters.data_.escapeToNexus:
            case Parameters.data_.escapeToNexus2:
               _loc4_ = StaticInjectorContext.getInjector().getInstance(CloseAllPopupsSignal);
               _loc4_.dispatch();
               this.exitGame.dispatch();
               this.gs_.gsc_.escape();
               Parameters.data_.needsRandomRealm = false;
               Parameters.save();
               break;
            case Parameters.data_.friendList:
               this.isFriendsListOpen = !this.isFriendsListOpen;
               if(this.isFriendsListOpen)
               {
                  if(Parameters.USE_NEW_FRIENDS_UI)
                  {
                     _loc11_ = StaticInjectorContext.getInjector().getInstance(ShowPopupSignal);
                     _loc11_.dispatch(new SocialPopupView());
                  }
                  else
                  {
                     _loc12_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
                     _loc12_.dispatch(new FriendListView());
                  }
               }
               else
               {
                  this.closeDialogSignal.dispatch();
                  this.closePopupByClassSignal.dispatch(SocialPopupView);
               }
               break;
            case Parameters.data_.options:
               _loc4_ = StaticInjectorContext.getInjector().getInstance(CloseAllPopupsSignal);
               _loc4_.dispatch();
               this.clearInput();
               this.layers.overlay.addChild(new Options(this.gs_));
               break;
            case Parameters.data_.toggleCentering:
               Parameters.data_.centerOnPlayer = !Parameters.data_.centerOnPlayer;
               Parameters.save();
               break;
            case Parameters.data_.toggleFullscreen:
               if(Capabilities.playerType == "Desktop")
               {
                  Parameters.data_.fullscreenMode = !Parameters.data_.fullscreenMode;
                  Parameters.save();
                  _loc2_.displayState = !!Parameters.data_.fullscreenMode?"fullScreenInteractive":StageDisplayState.NORMAL;
               }
               break;
            case Parameters.data_.switchTabs:
               _loc4_ = StaticInjectorContext.getInjector().getInstance(CloseAllPopupsSignal);
               _loc4_.dispatch();
               this.statsTabHotKeyInputSignal.dispatch();
               break;
            case Parameters.data_.interact:
               _loc4_ = StaticInjectorContext.getInjector().getInstance(CloseAllPopupsSignal);
               _loc4_.dispatch();
               break;
            case Parameters.data_.testOne:
               break;
            case Parameters.data_.toggleRealmQuestDisplay:
               this.toggleRealmQuestsDisplaySignal.dispatch();
         }
         if(Parameters.ALLOW_SCREENSHOT_MODE)
         {
            switch(param1.keyCode)
            {
               case KeyCodes.F2:
                  this.toggleScreenShotMode();
                  break;
               case KeyCodes.F3:
                  Parameters.screenShotSlimMode_ = !Parameters.screenShotSlimMode_;
                  break;
               case KeyCodes.F4:
                  this.gs_.map.mapOverlay_.visible = !this.gs_.map.mapOverlay_.visible;
                  this.gs_.map.partyOverlay_.visible = !this.gs_.map.partyOverlay_.visible;
            }
         }
         if(this.areFKeysAvailable)
         {
            switch(param1.keyCode)
            {
               case KeyCodes.F6:
                  TextureRedrawer.clearCache();
                  Parameters.projColorType_ = (Parameters.projColorType_ + 1) % 7;
                  this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"Projectile Color Type: " + Parameters.projColorType_));
                  break;
               case KeyCodes.F7:
                  for each(_loc13_ in this.gs_.map.squares_)
                  {
                     if(_loc13_ != null)
                     {
                        _loc13_.faces_.length = 0;
                     }
                  }
                  Parameters.blendType_ = (Parameters.blendType_ + 1) % 2;
                  this.addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME,"Blend type: " + Parameters.blendType_));
                  break;
               case KeyCodes.F8:
                  Parameters.data_.surveyDate = 0;
                  Parameters.data_.needsSurvey = true;
                  Parameters.data_.playTimeLeftTillSurvey = 5;
                  Parameters.data_.surveyGroup = "testing";
                  break;
               case KeyCodes.F9:
                  Parameters.drawProj_ = !Parameters.drawProj_;
            }
         }
         this.setPlayerMovement();
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         switch(param1.keyCode)
         {
            case Parameters.data_.moveUp:
               this.moveUp_ = false;
               break;
            case Parameters.data_.moveDown:
               this.moveDown_ = false;
               break;
            case Parameters.data_.moveLeft:
               this.moveLeft_ = false;
               break;
            case Parameters.data_.moveRight:
               this.moveRight_ = false;
               break;
            case Parameters.data_.rotateLeft:
               this.rotateLeft_ = false;
               break;
            case Parameters.data_.rotateRight:
               this.rotateRight_ = false;
               break;
            case Parameters.data_.useSpecial:
               if(this.specialKeyDown_)
               {
                  this.specialKeyDown_ = false;
                  if(this.gs_.map.player_.isUnstable())
                  {
                     _loc2_ = Math.random() * 600 - 300;
                     _loc3_ = Math.random() * 600 - 325;
                  }
                  else
                  {
                     _loc2_ = this.gs_.map.mouseX;
                     _loc3_ = this.gs_.map.mouseY;
                  }
                  this.gs_.map.player_.useAltWeapon(this.gs_.map.mouseX,this.gs_.map.mouseY,UseType.END_USE);
               }
         }
         this.setPlayerMovement();
      }
      
      private function setPlayerMovement() : void
      {
         var _loc1_:Player = this.gs_.map.player_;
         if(_loc1_ != null)
         {
            if(this.enablePlayerInput_)
            {
               _loc1_.setRelativeMovement((!!this.rotateRight_?1:0) - (!!this.rotateLeft_?1:0),(!!this.moveRight_?1:0) - (!!this.moveLeft_?1:0),(!!this.moveDown_?1:0) - (!!this.moveUp_?1:0));
            }
            else
            {
               _loc1_.setRelativeMovement(0,0,0);
            }
         }
      }
      
      private function useItem(param1:int) : void
      {
         if(this.tabStripModel.currentSelection == TabStripModel.BACKPACK)
         {
            param1 = param1 + GeneralConstants.NUM_INVENTORY_SLOTS;
         }
         var _loc2_:Player = this.gs_.map.player_;
         var _loc3_:int = _loc2_.equipment_[param1];
         var _loc4_:int = ObjectLibrary.getMatchingSlotIndex(_loc3_,_loc2_);
         if(_loc4_ != -1)
         {
            if(!this.swapTooSoon())
            {
               GameServerConnection.instance.invSwap(_loc2_,_loc2_,param1,_loc3_,_loc2_,_loc4_,_loc2_.equipment_[_loc4_]);
            }
         }
         else
         {
            GameServerConnection.instance.useItem_new(_loc2_,param1);
         }
      }
      
      private function swapTooSoon() : Boolean
      {
         var _loc1_:int = getTimer();
         if(this.gs_.map.player_.lastSwap_ + 600 > _loc1_)
         {
            SoundEffectLibrary.play("error");
            return true;
         }
         this.gs_.map.player_.lastSwap_ = _loc1_;
         return false;
      }
      
      private function togglePerformanceStats() : void
      {
         if(this.gs_.contains(stats_))
         {
            this.gs_.removeChild(stats_);
            this.gs_.removeChild(this.gs_.gsc_.jitterWatcher_);
            this.gs_.gsc_.disableJitterWatcher();
         }
         else
         {
            this.gs_.addChild(stats_);
            this.gs_.gsc_.enableJitterWatcher();
            this.gs_.gsc_.jitterWatcher_.y = stats_.height;
            this.gs_.addChild(this.gs_.gsc_.jitterWatcher_);
         }
      }
      
      private function toggleScreenShotMode() : void
      {
         Parameters.screenShotMode_ = !Parameters.screenShotMode_;
         if(Parameters.screenShotMode_)
         {
            this.gs_.hudView.visible = false;
            this.setTextBoxVisibility.dispatch(false);
         }
         else
         {
            this.gs_.hudView.visible = true;
            this.setTextBoxVisibility.dispatch(true);
         }
      }
   }
}
