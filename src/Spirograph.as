package{
	
	import com.SpirographView;
	import com.abacus.core.StarlingApp;
	import com.abacus.utils.Assets;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(width="800", height="800", frameRate="60", backgroundColor="0x000000")]
	public class Spirograph extends StarlingApp{
		
		public function Spirograph(){
			super(800, 800, false);
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_isWeb = true;
		}
		
		override protected function enqueueAssets():void{
			//var appDir:File = File.applicationDirectory;
			_assets = Assets.MANAGER;
			_assets.scaleFactor = _scaleFactor;
			_assets.verbose = Capabilities.isDebugger;
			_assets.enqueue(
				//appDir.resolvePath("assets/images/")
				Embed
			);
		}
		
		override protected function initStarling():void{
			_starling = new Starling(SpirographView, stage, _viewport);
			_starling.stage.stageWidth  = _viewPortWidth
			_starling.stage.stageHeight = _viewPortHeight;
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			//_starling.showStats = Capabilities.isDebugger;
			//_starling.showStatsAt("left", "top", 1/_scaleFactor);
			_starling.antiAliasing = 16;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
		
		override protected function onRootCreated(e:starling.events.Event):void{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_root = _starling.root as SpirographView;
			_starling.start();
			
			_assets.loadQueue(function(ratio:Number):void{
				_appLoader.updateProgress(ratio);
					if (ratio == 1.0){
					removeChild(_appLoader);
					removeChild(_background);
					SpirographView(_root).start();
				}
			});
		}
	}
}