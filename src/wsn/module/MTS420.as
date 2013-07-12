package wsn.module
{
	/**
	 * MTS420クラスには、Crossbow MTS42のための単位変換関数があります。
	 * MTS420クラスのメソッドはすべて静的であり、MTS420.method(parameter)というシンタックスを使用して呼び出す必要があります。
	 */
	public class MTS420
	{
		public function MTS420()
		{
		}
		/**
		 * @param nodeid
		 * @return
		 */
		public static function nodeid(x:int):int
		{
			return x;
		}
		/**
		 * @param x voltage
		 * @return 計算結果です。
		 */
		public static function battery(x:Number):Number
		{
			return 1252352/x;
		}
		/**
		 * @param x humid
		 * @param y humtemp
		 * @return 計算結果
		 */
		public static function humidity(x:int, y:int):Number
		{
			return (-39.6+0.01*y-25.0)*(0.01+0.00008*x)-4.0+0.0405*x-0.0000028*Math.pow(x, 2);
		}
		/**
		 * @param humtemp
		 * @return 計算結果
		 */
		public static function temperature(x:int):Number
		{
			return -39.6+0.01*x;
		}
		/**
		 * @param x prtemp
		 * @param a calibW0
		 * @param b calibW1
		 * @return 計算結果です。
		 */
		public static function prtemperature(x:int, a:int, b:int):Number
		{
			return (200+(x-(8*(((a&1)<<10)|(b>>6))+20224))*((b&63)+50)/1024)/10;
		}
		/**
		 * @param x press
		 * @param y prtemp
		 * @param a calibW0
		 * @param b calibW1
		 * @param c calibW2
		 * @param d calibW3
		 * @return 計算結果です。
		 */
		public static function press(x:int, y:int, a:int, b:int, c:int, d:int):int
		{
			return ((((a>>1)+(d>>6)*(y-(8*(((a&1)<<10)|(b>>6))+20224))/1024+24576)*(x-7168))/16384-((((c&63)<<6)|(d&63))*4+((c>>6)-512)*(y-(8*(((a&1)<<10)|(b>>6))+20224))/1024))/32+250;
		}
		/**
		 * @param x taosch0
		 * @prama y taosch1
		 * @return 計算結果です。
		 */ 
		public static function light(x:int, y:int):Number
		{
			return (16.5((1<<((x&112)>>4))-1)+(x&15)*((1<<((x&112)>>4))-1))*0.46/Math.exp(3.13*((16.5*((1<<((y&112)>>4))-1)+(y&15)*((1<<((y&112)>>4))-1))/(16.5*((1<<((x&112)>>4))-1)+(x&15)*((1<<((x&112)>>4))-1))));
		}
		/**
		 * @param x accel_x
		 * @return 計算結果です。 
		 */
		public static function accelX(x:int):Number
		{
			return 1000*(1-(500-x)/((500-400)/2));
		}
		/**
		 * @param x accel_y
		 * @return 計算結果です。 
		 */
		public static function accelY(x:int):Number
		{
			return 1000*(1-(500-x)/((500-400)/2));
		}
		public static function fix(h:int, m:int, s:int):Date
		{
			var date:Date = new Date();
			date.setHours(h, m, s/1000);
			return date;
		}
		public static function latitude(x:int, y:int):Number
		{
			var m:Number = Math.floor(y/10000)/60;
			var s:Number = (y/10000-Math.floor(y/10000))/360;
			return x+m+s;
		}
		public static function longitude(x:int, y:int):Number
		{
			var m:Number = Math.floor(y/10000)/60;
			var s:Number = (y/10000-Math.floor(y/10000))/360;
			return x+m+s;			
		}
	}
}