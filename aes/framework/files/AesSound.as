package aes.framework.files 
{
	import aes.framework.display.AesBasic;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	/**
	 * @author Назаров М. И.
	 */
	
	public class AesSound
	{
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform = new SoundTransform();
		private var _isPlaying:Boolean = false;
		private var _isPaused:Boolean = false;
		private var _source:AesBasic = null;
		private var _repeats:int = 1;
		private var _pausePos:Number = 0;
		
		public function AesSound(sound:Sound) 
		{
			_sound = sound;
		}
		
		public static function fromByteArray(data:ByteArray):AesSound
		{
			var snd:Sound = new Sound();
			snd.loadCompressedDataFromByteArray(data, data.length);
			
			return new AesSound(snd);
		}
		
		public function dispose():void 
		{	
			stop();
			
			_sound.close();
			_sound = null;
			_soundTransform = null;
		}
		
		public function update():void 
		{
			
		}
		
		public function play(source:AesBasic = null, pos:Number = 0, repeats:int = 1, volume:Number = 1):void
		{
			if (_isPlaying) {
				stop();
			}
			
			_isPaused = false;
			_pausePos = 0;
			_source = source;
			_repeats = repeats;
			_soundTransform.volume = volume;
			
			_soundChannel = _sound.play(pos, repeats, _soundTransform);
			if (_soundChannel != null) {
				_isPlaying = true;
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
		}
		
		public function stop():void
		{
			if (_isPlaying) {
				_isPlaying = false;
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		
		public function pause():void
		{
			if (_isPlaying) {
				_isPaused = true;
				_pausePos = _soundChannel.position;
			}
			
			stop();
		}
		
		public function resume():void
		{
			if (_isPaused) {
				play(_source, _pausePos, _repeats);
			}
		}
		
		private function soundCompleteHandler(event:Event):void
		{
			stop();
		}
		
	}
}