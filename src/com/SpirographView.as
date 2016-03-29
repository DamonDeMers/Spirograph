package com{
	
	import com.abacus.core.AbacusRoot;
	import com.abacus.ui.backgrounder.Backgrounder;
	import com.abacus.ui.backgrounder.VignetteMode;
	import com.abacus.ui.slider.AbacusSlider;
	import com.abacus.ui.toggle.AbacusToggleButton;
	import com.abacus.utils.Assets;
	import com.abacus.utils.LayoutUtils;
	
	import flash.utils.Dictionary;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class SpirographView extends AbacusRoot{
		
		private const CIRCLE_SPEED_DEFAULT:int = 2;
		private const ROTATION_SPEED_DEFAULT:int = 8;
		private const NUM_CIRCLES_DEFAULT:int = 2;
		private const STARTING_STEP_VALUE_RADIANS:Number = -Math.PI/2;
		
		private var _bg:Backgrounder;
		private var _circleContainer:Sprite;
		private var _penContainer:Sprite;
		
		private var _dict:Dictionary;
		private var _circleData:Vector.<CircleVO>;
		private var _outerCircleRadius:Number;
		private var _outerCircleYPos:Number;
		
		private var _speedSlider:AbacusSlider;
		private var _rotationSlider:AbacusSlider;
		private var _numCircles:AbacusSlider;
		private var _invertRotation:AbacusToggleButton;
		
		
		public function SpirographView(){
			super();
		}
		
		public function start():void{
			initData();
			initAssets();
			initListeners();
		}
		
		private function initData():void{
			_dict = new Dictionary();
			_circleData = new Vector.<CircleVO>;
			_outerCircleRadius = stage.stageWidth/2 - 100;
			_outerCircleYPos = stage.stageHeight/2 - _outerCircleRadius + 70;

			_speedSlider = new AbacusSlider(Assets.MANAGER.getTexture("sliderHandle"), Assets.MANAGER.getTexture("sliderGuide"), CIRCLE_SPEED_DEFAULT, 1, 10, "Circle Speed");
			_speedSlider.fontColor = 0x0;
			_speedSlider.fontSize = 20;
			
			_rotationSlider = new AbacusSlider(Assets.MANAGER.getTexture("sliderHandle"), Assets.MANAGER.getTexture("sliderGuide"), ROTATION_SPEED_DEFAULT, 1, 20, "Rotation Speed");
			_rotationSlider.fontColor = 0x0;
			_rotationSlider.fontSize = 20;
			
			_numCircles = new AbacusSlider(Assets.MANAGER.getTexture("sliderHandle"), Assets.MANAGER.getTexture("sliderGuide"), NUM_CIRCLES_DEFAULT, 1, 4, "Num Circles");
			_numCircles.fontColor = 0x0;
			_numCircles.fontSize = 20;
			
			_invertRotation = new AbacusToggleButton(Assets.MANAGER.getTexture("toggleBg"), Assets.MANAGER.getTexture("toggle"), "Invert Rotation");
			_numCircles.fontColor = 0x0;
			_invertRotation.fontSize = 20;

			generateCircleData(CIRCLE_SPEED_DEFAULT, ROTATION_SPEED_DEFAULT);
		}
		
		private function initAssets():void{
			_bg = new Backgrounder(Backgrounder.DEFAULT_BG_COLOR, VignetteMode.SUBTLE);
			addChild(_bg);

			_circleContainer = new Sprite();
			addChild(_circleContainer);
			
			_penContainer = new Sprite();
			addChild(_penContainer);
			
			createCircles();
			createPens();

			addChild(_speedSlider);
			LayoutUtils.layout(_speedSlider, LayoutUtils.ALIGN_TOP_LEFT, 40);

			addChild(_rotationSlider);
			LayoutUtils.layout(_rotationSlider, LayoutUtils.ALIGN_TOP_LEFT, 40);
			_rotationSlider.y += 60;
			
			addChild(_numCircles);
			LayoutUtils.layout(_numCircles, LayoutUtils.ALIGN_TOP_RIGHT, 40);
			
			addChild(_invertRotation);
			LayoutUtils.layout(_invertRotation, LayoutUtils.ALIGN_TOP_RIGHT, 40);
			_invertRotation.y += 35;
			_invertRotation.x -= 145;
		}
		
		private function initListeners():void{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_speedSlider.addEventListener(Event.CHANGE, onSliderChange);
			_rotationSlider.addEventListener(Event.CHANGE, onSliderChange);
			_numCircles.addEventListener(Event.CHANGE, onSliderChange);
			_invertRotation.addEventListener(Event.CHANGE, onSliderChange);
		}
		
		private function generateCircleData(circleSpeed:Number, rotationSpeed:Number):void{
			var currentRadius:Number = _outerCircleRadius;
			var count:int = 0;
			while(count <= Math.round(_numCircles.value)){
				var circleVO:CircleVO = new CircleVO();
				circleVO.radius = currentRadius;
				circleVO.location.x = stage.stageWidth/2;
				circleVO.location.y = _outerCircleYPos + circleVO.radius;
				circleVO.step = STARTING_STEP_VALUE_RADIANS;
				circleVO.speed = circleSpeed/100;
				circleVO.rotationSpeed = rotationSpeed/currentRadius;
				circleVO.index = count;
				_circleData.push(circleVO);
				currentRadius *= 1/1.61803398875;
				count++;
			}
		}
		
		private function createCircles():void{
			var len:int = _circleData.length;
			for (var i:int = 0; i < len; i++){
				var circleVO:CircleVO = _circleData[i];
				var circle:Circle = new Circle(circleVO);
				circle.x = circleVO.location.x;
				circle.y = circleVO.location.y;
				_dict[circleVO] = circle;
				_circleContainer.addChild(circle);
			}
		}
		
		private function createPens():void{
			var len:int = _circleData.length - 1;
			for (var i:int = 0; i < len; i++){
				var pen:Shape = new Shape();
				pen.graphics.lineStyle(3, 0xFF0000);
				pen.graphics.moveTo(stage.stageWidth/2, _outerCircleYPos);
				_penContainer.addChild(pen);
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void{
			var len:int = _circleData.length;
			for (var i:int = 1; i < len; i++){
				var circleVO:CircleVO = _circleData[i];
				var circle:Circle = _dict[circleVO];
				
				circleVO.location.x = Math.cos(circleVO.step) * (_circleData[i-1].radius - circleVO.radius) + _circleData[i-1].location.x;
				circleVO.location.y = Math.sin(circleVO.step) * (_circleData[i-1].radius - circleVO.radius) + _circleData[i-1].location.y;
				circleVO.step += circleVO.speed;
				circle.x = circleVO.location.x;
				circle.y = circleVO.location.y;
				_invertRotation.isSelected() ? circle.rotation -= circleVO.rotationSpeed : circle.rotation += circleVO.rotationSpeed;
				
				var pen:Shape = _penContainer.getChildAt(i-1) as Shape;
				var penX:Number = circleVO.location.x + Math.cos(circle.rotation + STARTING_STEP_VALUE_RADIANS) * circleVO.radius;
				var penY:Number = circleVO.location.y + Math.sin(circle.rotation + STARTING_STEP_VALUE_RADIANS) * circleVO.radius;
				pen.graphics.lineTo(penX, penY);
			}	
		}
		
		private function onSliderChange():void{
			_circleData.length = 0;
			generateCircleData(Math.round(_speedSlider.value), Math.round(_rotationSlider.value));
			_circleContainer.removeChildren();
			createCircles();
			_penContainer.removeChildren();
			createPens();
		}
	}
}