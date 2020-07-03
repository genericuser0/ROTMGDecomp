package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Portal;
   import com.company.assembleegameclient.objects.PortalNameParser;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.tutorial.Tutorial;
   import com.company.assembleegameclient.tutorial.doneAction;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.core.service.GoogleAnalytics;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   
   public class PortalPanel extends Panel
   {
       
      
      public const exitGameSignal:Signal = new Signal();
      
      private const LOCKED:String = "Locked ";
      
      private const TEXT_PATTERN:RegExp = /\{"text":"(.+)"}/;
      
      private const waiter:SignalWaiter = new SignalWaiter();
      
      public var owner_:Portal;
      
      public var googleAnalytics:GoogleAnalytics;
      
      private var nameText_:TextFieldDisplayConcrete;
      
      private var _enterButton_:DeprecatedTextButton;
      
      private var fullText_:TextFieldDisplayConcrete;
      
      public function PortalPanel(param1:GameSprite, param2:Portal)
      {
         super(param1);
         this.owner_ = param2;
         this.nameText_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setBold(true).setTextWidth(WIDTH).setWordWrap(true).setHorizontalAlign(TextFormatAlign.CENTER);
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.waiter.push(this.nameText_.textChanged);
         this._enterButton_ = new DeprecatedTextButton(16,TextKey.PANEL_ENTER);
         addChild(this._enterButton_);
         this.waiter.push(this._enterButton_.textChanged);
         this.fullText_ = new TextFieldDisplayConcrete().setSize(18).setColor(16711680).setHTML(true).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         var _loc3_:String = !!this.owner_.lockedPortal_?TextKey.PORTAL_PANEL_LOCKED:TextKey.PORTAL_PANEL_FULL;
         this.fullText_.setStringBuilder(new LineBuilder().setParams(_loc3_).setPrefix("<p align=\"center\">").setPostfix("</p>"));
         this.fullText_.filters = [new DropShadowFilter(0,0,0)];
         this.fullText_.textChanged.addOnce(this.alignUI);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.waiter.complete.addOnce(this.alignUI);
      }
      
      private function alignUI() : void
      {
         this.nameText_.y = 6;
         this._enterButton_.x = WIDTH / 2 - this._enterButton_.width / 2;
         this._enterButton_.y = HEIGHT - this._enterButton_.height - 4;
         this.fullText_.y = HEIGHT - 30;
         this.fullText_.x = WIDTH / 2;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this._enterButton_.removeEventListener(MouseEvent.CLICK,this.onEnterSpriteClick);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      public function onEnterSpriteClick(param1:MouseEvent) : void
      {
         this.enterPortal();
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && stage.focus == null)
         {
            this.enterPortal();
         }
      }
      
      private function enterPortal() : void
      {
         var _loc1_:String = ObjectLibrary.typeToDisplayId_[this.owner_.objectType_];
         if(this.googleAnalytics && (_loc1_ == "Kitchen Portal" || _loc1_ == "Vault Explanation" || _loc1_ == "Guild Explanation" || _loc1_ == "Nexus Explanation"))
         {
            this.googleAnalytics.trackEvent("enterPortal",_loc1_);
         }
         doneAction(gs_,Tutorial.ENTER_PORTAL_ACTION);
         gs_.gsc_.usePortal(this.owner_.objectId_);
         this.exitGameSignal.dispatch();
      }
      
      override public function draw() : void
      {
         this.updateNameText();
         if(!this.owner_.lockedPortal_ && this.owner_.active_ && contains(this.fullText_))
         {
            removeChild(this.fullText_);
            addChild(this._enterButton_);
         }
         else if((this.owner_.lockedPortal_ || !this.owner_.active_) && contains(this._enterButton_))
         {
            removeChild(this._enterButton_);
            addChild(this.fullText_);
         }
      }
      
      private function updateNameText() : void
      {
         var _loc1_:String = this.getName();
         var _loc2_:StringBuilder = new PortalNameParser().makeBuilder(_loc1_);
         this.nameText_.setStringBuilder(_loc2_);
         this.nameText_.x = (WIDTH - this.nameText_.width) * 0.5;
         this.nameText_.y = this.nameText_.height > 30?Number(0):Number(6);
      }
      
      private function getName() : String
      {
         var _loc1_:String = this.owner_.getName();
         if(this.owner_.lockedPortal_ && _loc1_.indexOf(this.LOCKED) == 0)
         {
            return _loc1_.substr(this.LOCKED.length);
         }
         return this.parseJson(_loc1_);
      }
      
      private function parseJson(param1:String) : String
      {
         var _loc2_:Array = param1.match(this.TEXT_PATTERN);
         return !!_loc2_?_loc2_[1]:param1;
      }
      
      public function get enterButton_() : DeprecatedTextButton
      {
         return this._enterButton_;
      }
   }
}
