package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.TimeUtil;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import io.decagames.rotmg.fame.FameContentPopup;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.fortune.model.FortuneInfo;
   import kabam.rotmg.fortune.services.FortuneModel;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class CreditDisplay extends Sprite
   {
      
      private static const FONT_SIZE:int = 18;
      
      public static const IMAGE_NAME:String = "lofiObj3";
      
      public static const IMAGE_ID:int = 225;
      
      public static const waiter:SignalWaiter = new SignalWaiter();
       
      
      private var creditsText_:TextFieldDisplayConcrete;
      
      private var fameText_:TextFieldDisplayConcrete;
      
      private var fortuneText_:TextFieldDisplayConcrete;
      
      private var fortuneTimeText_:TextFieldDisplayConcrete;
      
      private var coinIcon_:Bitmap;
      
      private var fameIcon_:Bitmap;
      
      private var fortuneIcon_:Bitmap;
      
      private var credits_:int = -1;
      
      private var fame_:int = -1;
      
      private var fortune_:int = -1;
      
      private var displayFortune_:Boolean = false;
      
      private var displayFame_:Boolean = true;
      
      public var gs:GameSprite;
      
      public var _creditsButton:SliceScalingButton;
      
      public var _fameButton:SliceScalingButton;
      
      public var openAccountDialog:Signal;
      
      public var displayFameTooltip:Signal;
      
      private var fortuneTimeEnd:Number = -1;
      
      private var fortuneTimeLeftString:String = "";
      
      public var resourcePadding:int;
      
      public function CreditDisplay(param1:GameSprite = null, param2:Boolean = true, param3:Boolean = false, param4:Number = 0)
      {
         var _loc6_:FortuneInfo = null;
         this.openAccountDialog = new Signal();
         this.displayFameTooltip = new Signal();
         super();
         this.displayFortune_ = param3;
         this.displayFame_ = param2;
         this.gs = param1;
         this.creditsText_ = this.makeTextField();
         waiter.push(this.creditsText_.textChanged);
         addChild(this.creditsText_);
         var _loc5_:BitmapData = AssetLibrary.getImageFromSet(IMAGE_NAME,IMAGE_ID);
         _loc5_ = TextureRedrawer.redraw(_loc5_,40,true,0);
         this.coinIcon_ = new Bitmap(_loc5_);
         addChild(this.coinIcon_);
         if(this.displayFame_)
         {
            this.fameText_ = this.makeTextField();
            waiter.push(this.fameText_.textChanged);
            addChild(this.fameText_);
            this.fameIcon_ = new Bitmap(FameUtil.getFameIcon());
            addChild(this.fameIcon_);
         }
         if(this.displayFortune_ && FortuneModel.HAS_FORTUNES)
         {
            _loc6_ = StaticInjectorContext.getInjector().getInstance(FortuneModel).getFortune();
            if(_loc6_._endTime != null)
            {
               this.fortuneTimeEnd = _loc6_._endTime.time;
               this.fortuneTimeText_ = this.makeTextField(16777215);
               waiter.push(this.fortuneTimeText_.textChanged);
               this.fortuneTimeText_.setStringBuilder(new StaticStringBuilder(this.getFortuneTimeLeftStr()));
               addChild(this.fortuneTimeText_);
               this.fortuneTimeText_.visible = false;
            }
            this.fortuneText_ = this.makeTextField(16777215);
            waiter.push(this.fortuneText_.textChanged);
            addChild(this.fortuneText_);
            this.fortuneIcon_ = new Bitmap(IconFactory.makeFortune());
            addChild(this.fortuneIcon_);
         }
         else
         {
            this.displayFortune_ = false;
         }
         this.draw(0,0,0);
         mouseEnabled = true;
         waiter.complete.add(this.onAlignHorizontal);
      }
      
      public function addResourceButtons() : void
      {
         this.resourcePadding = 30;
         this._creditsButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","resourcesAddButton"));
         this._fameButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","tab_info_button"));
         addChild(this._creditsButton);
         addChild(this._fameButton);
      }
      
      public function removeResourceButtons() : void
      {
         this.resourcePadding = 5;
         if(this._creditsButton)
         {
            removeChild(this._creditsButton);
         }
         if(this._fameButton)
         {
            removeChild(this._fameButton);
         }
      }
      
      private function onAlignHorizontal() : void
      {
         if(this.displayFortune_)
         {
            this.coinIcon_.x = -this.coinIcon_.width;
            this.fortuneIcon_.x = -this.coinIcon_.width + 10;
            this.fortuneIcon_.y = 10;
            this.fortuneText_.x = this.coinIcon_.x - this.fortuneText_.width + 8;
            this.fortuneText_.y = this.coinIcon_.y + this.coinIcon_.height / 2 - this.creditsText_.height / 2;
            this.fortuneTimeText_.x = -this.fortuneTimeText_.width - 2;
            this.fortuneTimeText_.y = 33;
            this.coinIcon_.x = this.fortuneText_.x - this.coinIcon_.width;
            this.creditsText_.x = this.coinIcon_.x - this.creditsText_.width + 8;
            this.creditsText_.y = this.coinIcon_.y + this.coinIcon_.height / 2 - this.creditsText_.height / 2;
         }
         else
         {
            this.coinIcon_.x = -this.coinIcon_.width;
            this.creditsText_.x = this.coinIcon_.x - this.creditsText_.width + 8;
            this.creditsText_.y = this.coinIcon_.y + this.coinIcon_.height / 2 - this.creditsText_.height / 2;
            if(this._creditsButton)
            {
               this._creditsButton.x = this.coinIcon_.x - this.creditsText_.width - 16;
               this._creditsButton.y = 7;
            }
         }
         if(this.displayFame_)
         {
            this.fameIcon_.x = this.creditsText_.x - this.fameIcon_.width - this.resourcePadding;
            this.fameText_.x = this.fameIcon_.x - this.fameText_.width + 8;
            this.fameText_.y = this.fameIcon_.y + this.fameIcon_.height / 2 - this.fameText_.height / 2;
            if(this._fameButton)
            {
               this._fameButton.x = this.fameIcon_.x - this.fameText_.width - 16;
               this._fameButton.y = 7;
            }
         }
      }
      
      public function onFameClick(param1:MouseEvent) : void
      {
         this.onFameMask();
      }
      
      private function onFameMask() : void
      {
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         var _loc2_:ShowPopupSignal = _loc1_.getInstance(ShowPopupSignal);
         _loc2_.dispatch(new FameContentPopup());
      }
      
      public function onCreditsClick(param1:MouseEvent) : void
      {
         if(!this.gs || this.gs.evalIsNotInCombatMapArea() || Parameters.data_.clickForGold == true)
         {
            this.openAccountDialog.dispatch();
         }
      }
      
      public function makeTextField(param1:uint = 16777215) : TextFieldDisplayConcrete
      {
         var _loc2_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(FONT_SIZE).setColor(param1).setTextHeight(16);
         _loc2_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         return _loc2_;
      }
      
      private function handleFortuneTimeTextUpdate() : void
      {
         var _loc1_:String = this.getFortuneTimeLeftStr();
         if(_loc1_ != this.fortuneTimeLeftString)
         {
            if(_loc1_ == "Ended")
            {
               this.displayFortune_ = false;
               removeChild(this.fortuneTimeText_);
               removeChild(this.fortuneIcon_);
               removeChild(this.fortuneText_);
               FortuneModel.HAS_FORTUNES = false;
            }
            else
            {
               this.fortuneTimeText_.setStringBuilder(new StaticStringBuilder(_loc1_));
               this.fortuneTimeLeftString = _loc1_;
            }
            this.onAlignHorizontal();
         }
      }
      
      public function draw(param1:int, param2:int, param3:int = 0) : void
      {
         if(this.displayFortune_)
         {
            this.handleFortuneTimeTextUpdate();
         }
         if(param1 == this.credits_ && (this.displayFame_ && param2 == this.fame_) && (this.displayFortune_ && param3 == this.fortune_))
         {
            return;
         }
         this.credits_ = param1;
         this.creditsText_.setStringBuilder(new StaticStringBuilder(this.credits_.toString()));
         if(this.displayFame_)
         {
            this.fame_ = param2;
            this.fameText_.setStringBuilder(new StaticStringBuilder(this.fame_.toString()));
         }
         if(this.displayFortune_)
         {
            this.fortune_ = param3;
            this.fortuneText_.setStringBuilder(new StaticStringBuilder(this.fortune_.toString()));
         }
         if(waiter.isEmpty())
         {
            this.onAlignHorizontal();
         }
      }
      
      public function getFortuneTimeLeftStr() : String
      {
         var _loc1_:* = "";
         var _loc2_:Date = new Date();
         var _loc3_:Number = (this.fortuneTimeEnd - _loc2_.time) / 1000;
         if(_loc3_ > TimeUtil.DAY_IN_S)
         {
            _loc1_ = String(Math.ceil(TimeUtil.secondsToDays(_loc3_))) + " days";
         }
         else if(_loc3_ > TimeUtil.HOUR_IN_S)
         {
            _loc1_ = String(Math.ceil(TimeUtil.secondsToHours(_loc3_))) + " hours";
         }
         else if(_loc3_ > TimeUtil.MIN_IN_S)
         {
            _loc1_ = String(Math.ceil(TimeUtil.secondsToMins(_loc3_))) + " minutes";
         }
         else if(_loc3_ > TimeUtil.MIN_IN_S / 2)
         {
            _loc1_ = "One Minute Left!";
         }
         else if(_loc3_ > 0)
         {
            _loc1_ = "Ending in a few seconds!!";
         }
         else
         {
            _loc1_ = "Ended";
         }
         return _loc1_;
      }
      
      public function get creditsButton() : SliceScalingButton
      {
         return this._creditsButton;
      }
      
      public function get fameButton() : SliceScalingButton
      {
         return this._fameButton;
      }
   }
}
