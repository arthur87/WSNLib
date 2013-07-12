package wsn.utils
{
	/**
	 * MathUtilクラスには、数学関数があります。
	 * MathUtilクラスのメソッドはすべて静的であり、MathUtil.method(<i>parameter</i>)というシンタックスを使用して呼び出す必要があります。
	 */
	public class MathUtil
	{		
		/**
		 * 数値を指定した範囲のなかに収めます。
		 * xがa以上b以下のときxがそのまま返ります。またxがaより小さいときはb、bより大きいときはbが返ります。
		 * @param x 計算対象の値です。
		 * @param a 範囲の下限です。
		 * @param b 範囲の上限です。
		 * @return 計算結果です。
		 */
		public static function constrain(x:Number,a:Number,b:Number):Number
		{
			if (a <= x && x <= b) {
				return x;
			}
			return (a > x) ? a : b;
		}
		
		/**
		 * 数値をある範囲から別の範囲に変換します。
		 * @param x 変換したい数値です。
		 * @param in_min 現在の範囲の下限です。
		 * @param in_max 現在の範囲の上限です。
		 * @param out_min 変換後の範囲の下限です。
		 * @param out_max 変換後の範囲の上限です。
		 * @return 計算結果です。
		 */
		public static function map(x:Number, in_min:Number, in_max:Number, out_min:Number, out_max:Number):int
		{
			return Math.floor((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
		}
		
		/**
		 * 擬似乱数を生成します。
		 * @param min 生成する乱数の上限です。
		 * @param max 生成する乱数の下限です。
		 * @return 計算結果です。 
		 */
		public static function random(min:Number = 0,max:Number = 1):Number
		{
			return Math.floor((max - min + 1) * Math.random() + min);
		}
		/**
		 * 数値を指定した小数部の桁数で打ち切ります。
		 * @param x 数値
		 * @param y 小数部の桁数
		 * @return 計算結果
		 * 
		 * <listing version="3.0">
		 * MathUtil.format(3.14159, 3); // 3.141
		 * </listing>
		 */
		public static function format(x:Number, y:int):Number
		{
			return Math.floor(x * Math.pow(10, y)) / Math.pow(10, y);
		}
	}
	
}
