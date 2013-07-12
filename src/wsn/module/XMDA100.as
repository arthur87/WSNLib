package wsn.module
{
	/**
	 * XMDA100クラスには、Crossbow XMDA100のための単位変換関数があります。
	 * XMDA100クラスのメソッドはすべて静的であり、XMDA100.method(parameter)というシンタックスを使用して呼び出す必要があります。
	 */
	public class XMDA100
	{
		public function XMDA100()
		{
		}
		/**
		 * @param x voltage
		 * @return 計算結果です。
		 */
		public static function voltage(x:Number):Number
		{
			return 1252352/x;
		}
		/**
		 * @param x temp
		 * @return 計算結果です。
		 */
		public static function temp(x:Number):Number
		{
			return ((1/(0.001307050+0.000214381*Math.log(10000*(1023-x)/x)+0.000000093*(Math.log(10000*(1023-x)/x)^3)))-273.15);
		}
		/**
		 * @param x voltage
		 * @param y light
		 * @return 計算結果です。
		 */
		public static function lignt(x:Number, y:Number):Number
		{
			return (y*(1252352/x)/1023);
		}
		/**
		 * @param x adc2
		 * @param y voltage
		 * @return 計算結果です。
		 */
		public static function adc2(x:Number, y:Number):Number
		{
			return (y*(1252352/x)/1023);
		}
		/**
		 * @param x adc3
		 * @param y voltage
		 * @return 計算結果です。
		 */
		public static function adc3(x:Number, y:Number):Number
		{
			return (y*(1252352/x)/1023);
		}
		/**
		 * @param x adc4
		 * @param y voltage
		 * @return 計算結果です。
		 */
		public static function adc4(x:Number, y:Number):Number
		{
			return (y*(1252352/x)/1023);
		}
		/**
		 * @param x adc5
		 * @param y voltage
		 * @return 計算結果です。
		 */
		public static function adc5(x:Number, y:Number):Number
		{
			return (y*(1252352/x)/1023);
		}
		/**
		 * @param x adc6
		 * @param y voltage
		 * @return 計算結果です。
		 */
		public static function adc6(x:Number, y:Number):Number
		{
			return (y*(1252352/x)/1023);
		}
	}
}