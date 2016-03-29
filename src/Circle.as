package{
	
	import starling.display.Shape;
	import starling.display.Sprite;
	
	public class Circle extends Sprite{
		
		private var _pen:Shape;
		private var _circleVO:CircleVO;
		
		public function Circle(circleVO:CircleVO){
			super();
			_circleVO = circleVO;
			initAssets();
		}
		
		private function initAssets():void{
			var circle:Shape = new Shape();
			circle.graphics.lineStyle(4);
			circle.graphics.drawCircle(0, 0, _circleVO.radius);
			circle.alignPivot();
			if(_circleVO.index > 0){
				var dot:Shape = new Shape();
				dot.graphics.beginFill(0xFF0000);
				dot.graphics.drawCircle(0,0,8);
				dot.graphics.endFill();
				circle.addChild(dot);
				dot.y -= _circleVO.radius;
			}
			addChild(circle);
		}
	}
}