package robotlegs.bender.extensions.commandCenter.impl
{
   import robotlegs.bender.extensions.commandCenter.api.CommandMappingError;
   import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
   import robotlegs.bender.framework.impl.MappingConfigValidator;
   
   public class CommandMapping implements ICommandMapping, ICommandMappingConfig
   {
       
      
      private var _commandClass:Class;
      
      private var _guards:Array;
      
      private var _hooks:Array;
      
      private var _once:Boolean;
      
      private var _next:ICommandMapping;
      
      private var _validator:MappingConfigValidator;
      
      public function CommandMapping(param1:Class)
      {
         this._guards = [];
         this._hooks = [];
         super();
         this._commandClass = param1;
      }
      
      public function get commandClass() : Class
      {
         return this._commandClass;
      }
      
      public function get guards() : Array
      {
         return this._guards;
      }
      
      public function get hooks() : Array
      {
         return this._hooks;
      }
      
      public function withGuards(... rest) : ICommandMappingConfig
      {
         this._validator && this._validator.checkGuards(rest);
         this._guards = this._guards.concat.apply(null,rest);
         return this;
      }
      
      public function withHooks(... rest) : ICommandMappingConfig
      {
         this._validator && this._validator.checkHooks(rest);
         this._hooks = this._hooks.concat.apply(null,rest);
         return this;
      }
      
      public function get fireOnce() : Boolean
      {
         return this._once;
      }
      
      public function once(param1:Boolean = true) : ICommandMappingConfig
      {
         this._validator && !this._once && this.throwMappingError("You attempted to change an existing mapping for " + this._commandClass + " by setting once(). Please unmap first.");
         this._once = param1;
         return this;
      }
      
      public function get next() : ICommandMapping
      {
         return this._next;
      }
      
      public function set next(param1:ICommandMapping) : void
      {
         this._next = param1;
      }
      
      private function throwMappingError(param1:String) : void
      {
         throw new CommandMappingError(param1);
      }
      
      function invalidate() : void
      {
         if(this._validator)
         {
            this._validator.invalidate();
         }
         else
         {
            this.createValidator();
         }
         this._guards = [];
         this._hooks = [];
      }
      
      public function validate() : void
      {
         if(!this._validator)
         {
            this.createValidator();
         }
         else if(!this._validator.valid)
         {
            this._validator.validate(this._guards,this._hooks);
         }
      }
      
      private function createValidator() : void
      {
         this._validator = new MappingConfigValidator(this._guards.slice(),this._hooks.slice(),null,this._commandClass);
      }
   }
}
