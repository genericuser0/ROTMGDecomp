package io.decagames.rotmg.dailyQuests.view.panel
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
   import io.decagames.rotmg.dailyQuests.view.DailyQuestWindow;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupByClassSignal;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.ui.signals.UpdateQuestSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class DailyQuestsPanelMediator extends Mediator
   {
       
      
      [Inject]
      public var view:DailyQuestsPanel;
      
      [Inject]
      public var questModel:DailyQuestsModel;
      
      [Inject]
      public var openDialogSignal:ShowPopupSignal;
      
      [Inject]
      public var closePopupByClassSignal:ClosePopupByClassSignal;
      
      [Inject]
      public var updateQuestSignal:UpdateQuestSignal;
      
      public function DailyQuestsPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.addSeeQuestsText();
      }
      
      private function addSeeQuestsText() : void
      {
         this.view.addSeeOffersButton();
         this.view.feedButton.addEventListener(MouseEvent.CLICK,this.onButtonLeftClick);
         WebMain.STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      override public function destroy() : void
      {
         if(this.view.feedButton)
         {
            this.view.feedButton.removeEventListener(MouseEvent.CLICK,this.onButtonLeftClick);
         }
         WebMain.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.closePopupByClassSignal.dispatch(DailyQuestWindow);
      }
      
      protected function onButtonLeftClick(param1:MouseEvent) : void
      {
         if(!this.questModel.isPopupOpened)
         {
            this.openDialogSignal.dispatch(new DailyQuestWindow());
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && WebMain.STAGE.focus == null)
         {
            this.onButtonLeftClick(null);
         }
      }
   }
}
