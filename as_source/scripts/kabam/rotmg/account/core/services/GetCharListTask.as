package kabam.rotmg.account.core.services
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import com.company.util.MoreObjectUtil;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import io.decagames.rotmg.seasonalEvent.popups.SeasonalEventErrorPopup;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import io.decagames.rotmg.unity.popup.UnitySignUpPopup;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.CharListDataSignal;
   import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
   import kabam.rotmg.account.web.WebAccount;
   import kabam.rotmg.account.web.view.MigrationDialog;
   import kabam.rotmg.account.web.view.WebLoginDialog;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.CharListLoadedSignal;
   import kabam.rotmg.core.signals.SetLoadingMessageSignal;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.fortune.components.TimerCallback;
   import kabam.rotmg.text.model.TextKey;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetCharListTask extends BaseTask
   {
      
      private static const ONE_SECOND_IN_MS:int = 1000;
      
      private static const MAX_RETRIES:int = 7;
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      [Inject]
      public var setLoadingMessage:SetLoadingMessageSignal;
      
      [Inject]
      public var charListData:CharListDataSignal;
      
      [Inject]
      public var charListLoadedSignal:CharListLoadedSignal;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var securityQuestionsModel:SecurityQuestionsModel;
      
      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      [Inject]
      public var showPopupSignal:ShowPopupSignal;
      
      private var requestData:Object;
      
      private var retryTimer:Timer;
      
      private var numRetries:int = 0;
      
      private var fromMigration:Boolean = false;
      
      private var seasonalEventErrorPopUp:SeasonalEventErrorPopup;
      
      public function GetCharListTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.info("GetUserDataTask start");
         this.requestData = this.makeRequestData();
         this.sendRequest();
         Parameters.sendLogin_ = false;
      }
      
      private function sendRequest() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/char/list",this.requestData);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onListComplete(param2);
         }
         else
         {
            this.onTextError(param2);
         }
      }
      
      public function makeRequestData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.game_net_user_id = this.account.gameNetworkUserId();
         _loc1_.game_net = this.account.gameNetwork();
         _loc1_.play_platform = this.account.playPlatform();
         _loc1_.do_login = Parameters.sendLogin_;
         _loc1_.challenger = Boolean(this.seasonalEventModel.isChallenger);
         MoreObjectUtil.addToObject(_loc1_,this.account.getCredentials());
         return _loc1_;
      }
      
      private function onListComplete(param1:String) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:MigrationDialog = null;
         var _loc5_:XML = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.hasOwnProperty("MigrateStatus"))
         {
            _loc3_ = _loc2_.MigrateStatus;
            if(_loc3_ == 5)
            {
               this.sendRequest();
            }
            _loc4_ = new MigrationDialog(this.account,_loc3_);
            this.fromMigration = true;
            _loc4_.done.addOnce(this.sendRequest);
            _loc4_.cancel.addOnce(this.clearAccountAndReloadCharacters);
            this.openDialog.dispatch(_loc4_);
         }
         else
         {
            if(_loc2_.hasOwnProperty("Account"))
            {
               if(this.account is WebAccount)
               {
                  WebAccount(this.account).userDisplayName = _loc2_.Account[0].Name;
                  WebAccount(this.account).paymentProvider = _loc2_.Account[0].PaymentProvider;
                  if(_loc2_.Account[0].hasOwnProperty("PaymentData"))
                  {
                     WebAccount(this.account).paymentData = _loc2_.Account[0].PaymentData;
                  }
               }
               this.account.creationDate = new Date(_loc2_.Account[0].CreationTimestamp * 1000);
               if(_loc2_.Account[0].hasOwnProperty("SecurityQuestions"))
               {
                  this.securityQuestionsModel.showSecurityQuestionsOnStartup = _loc2_.Account[0].SecurityQuestions[0].ShowSecurityQuestionsDialog[0] == "1";
                  this.securityQuestionsModel.clearQuestionsList();
                  for each(_loc5_ in _loc2_.Account[0].SecurityQuestions[0].SecurityQuestionsKeys[0].SecurityQuestionsKey)
                  {
                     this.securityQuestionsModel.addSecurityQuestion(_loc5_.toString());
                  }
               }
            }
            if(_loc2_ && Boolean(this.seasonalEventModel.isChallenger) && _loc2_.Account[0].hasOwnProperty("RemainingLives"))
            {
               this.seasonalEventModel.remainingCharacters = _loc2_.Account[0].RemainingLives;
            }
            this.charListData.dispatch(_loc2_);
            if(!this.model.isLogOutLogIn)
            {
               this.charListLoadedSignal.dispatch();
            }
            this.model.isLogOutLogIn = false;
            completeTask(true);
            if(!this.model.hasShownUnitySignUp && Parameters.data_.unitySignUp && _loc2_.hasOwnProperty("DecaSignupPopup"))
            {
               this.model.hasShownUnitySignUp = true;
               this.showPopupSignal.dispatch(new UnitySignUpPopup());
            }
         }
         if(this.retryTimer != null)
         {
            this.stopRetryTimer();
         }
      }
      
      private function onTextError(param1:String) : void
      {
         var _loc2_:WebLoginDialog = null;
         if(this.numRetries < MAX_RETRIES)
         {
            this.setLoadingMessage.dispatch("Loading.text");
         }
         else
         {
            this.setLoadingMessage.dispatch("error.loadError");
         }
         if(param1 == "Account credentials not valid")
         {
            if(this.fromMigration)
            {
               _loc2_ = new WebLoginDialog();
               _loc2_.setError(TextKey.WEB_LOGIN_DIALOG_PASSWORD_INVALID);
               _loc2_.setEmail(this.account.getUserId());
               StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(_loc2_);
            }
            this.clearAccountAndReloadCharacters();
         }
         else if(param1 == "Account is under maintenance")
         {
            this.setLoadingMessage.dispatch("This account has been banned");
            new TimerCallback(5,this.clearAccountAndReloadCharacters);
         }
         else if(param1 == "Account has fame lower than minimal for the season")
         {
            this.showSeasonalErrorPopUp(param1);
         }
         else if(param1 == "No more live left for the current season.")
         {
            this.showSeasonalErrorPopUp(param1);
         }
         else
         {
            this.waitForASecondThenRetryRequest();
         }
      }
      
      private function showSeasonalErrorPopUp(param1:String) : void
      {
         this.seasonalEventErrorPopUp = new SeasonalEventErrorPopup(param1);
         this.seasonalEventErrorPopUp.okButton.addEventListener(MouseEvent.CLICK,this.onSeasonalErrorPopUpClose);
         this.showPopupSignal.dispatch(this.seasonalEventErrorPopUp);
      }
      
      private function onSeasonalErrorPopUpClose(param1:MouseEvent) : void
      {
         this.seasonalEventErrorPopUp.okButton.removeEventListener(MouseEvent.CLICK,this.onSeasonalErrorPopUpClose);
         var _loc2_:String = this.seasonalEventErrorPopUp.message;
         this.closePopupSignal.dispatch(this.seasonalEventErrorPopUp);
         this.seasonalEventModel.isChallenger = 0;
         ObjectLibrary.usePatchedData = false;
         if(_loc2_ == "Account has fame lower than minimal for the season" || _loc2_ == "No more live left for the current season.")
         {
            this.setScreenWithValidData.dispatch(new CharacterSelectionAndNewsScreen());
         }
      }
      
      private function clearAccountAndReloadCharacters() : void
      {
         this.logger.info("GetUserDataTask invalid credentials");
         this.account.clear();
         this.client.complete.addOnce(this.onComplete);
         this.requestData = this.makeRequestData();
         this.client.sendRequest("/char/list",this.requestData);
      }
      
      private function waitForASecondThenRetryRequest() : void
      {
         this.logger.info("GetUserDataTask error - retrying");
         this.retryTimer = new Timer(ONE_SECOND_IN_MS,1);
         this.retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
         this.retryTimer.start();
      }
      
      private function stopRetryTimer() : void
      {
         this.retryTimer.stop();
         this.retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
         this.retryTimer = null;
      }
      
      private function onRetryTimer(param1:TimerEvent) : void
      {
         this.stopRetryTimer();
         if(this.numRetries < MAX_RETRIES)
         {
            this.sendRequest();
            this.numRetries++;
         }
         else
         {
            this.clearAccountAndReloadCharacters();
            this.setLoadingMessage.dispatch("LoginError.tooManyFails");
         }
      }
   }
}
