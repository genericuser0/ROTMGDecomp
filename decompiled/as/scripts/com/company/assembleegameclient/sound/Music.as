package com.company.assembleegameclient.sound
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.service.GoogleAnalytics;
   
   public class Music
   {
      
      private static var music_:Sound = null;
      
      private static var musicVolumeTransform:SoundTransform;
      
      private static var musicChannel_:SoundChannel = null;
      
      private static var volume:Number = 0.3;
       
      
      public function Music()
      {
         super();
      }
      
      public static function load() : void
      {
         var _loc1_:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
         var _loc2_:* = _loc1_.getAppEngineUrl(true) + "/music/sorc.mp3";
         volume = Parameters.data_.musicVolume;
         musicVolumeTransform = new SoundTransform(!!Parameters.data_.playMusic?Number(volume):Number(0));
         music_ = new Sound();
         music_.load(new URLRequest(_loc2_));
         musicChannel_ = music_.play(0,int.MAX_VALUE,musicVolumeTransform);
      }
      
      public static function setPlayMusic(param1:Boolean) : void
      {
         var _loc2_:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
         if(!_loc2_)
         {
         }
         Parameters.data_.playMusic = param1;
         Parameters.save();
         musicVolumeTransform.volume = !!Parameters.data_.playMusic?Number(volume):Number(0);
         musicChannel_.soundTransform = musicVolumeTransform;
      }
      
      public static function setMusicVolume(param1:Number) : void
      {
         Parameters.data_.musicVolume = param1;
         Parameters.save();
         if(!Parameters.data_.playMusic)
         {
            return;
         }
         if(musicVolumeTransform != null)
         {
            musicVolumeTransform.volume = param1;
         }
         else
         {
            musicVolumeTransform = new SoundTransform(param1);
         }
         musicChannel_.soundTransform = musicVolumeTransform;
      }
   }
}
