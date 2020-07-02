package io.decagames.rotmg.pets.commands
{
   import com.company.assembleegameclient.editor.Command;
   import io.decagames.rotmg.pets.utils.PetsConstants;
   import kabam.lib.net.api.MessageProvider;
   import kabam.lib.net.impl.SocketServer;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
   
   public class ReleasePetCommand extends Command
   {
       
      
      [Inject]
      public var messages:MessageProvider;
      
      [Inject]
      public var server:SocketServer;
      
      [Inject]
      public var instanceID:int;
      
      public function ReleasePetCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var _loc1_:ActivePetUpdateRequest = this.messages.require(GameServerConnection.ACTIVE_PET_UPDATE_REQUEST) as ActivePetUpdateRequest;
         _loc1_.instanceid = this.instanceID;
         _loc1_.commandtype = PetsConstants.RELEASE;
         this.server.sendMessage(_loc1_);
      }
   }
}
