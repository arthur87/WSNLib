package wsn.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * DateUtilクラスには、日付関数があります。
	 * 
	 * 時分秒の更新タイミングをイベントとして取得できます。
	 * <listing version="3.0">
	 * private var dateUtil:DateUtil = new DateUtil();
	 * private function init(e:Event = null):void
	 * {
	 *   dateUtil.addEventListener(DateUtil.SECONDS_CHANGED, s);
	 * }
 	 * private function s(e:Event):void
	 * {
	 *   trace(dateUtil.format("Y/m/d H:i:s"));
	 * }
	 * </listing>
	 */
	public class DateUtil extends Sprite
	{		

		public function DateUtil()
		{
			this.enterFrameListener(null);
			this.addEventListener(Event.ENTER_FRAME, enterFrameListener);
		}
		
		private var _seconds:int = 0;
		private var date:Date;
		public var weekFullEn:Array = new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
		public var weekJp:Array= new Array("日","月","火","水","木","金","土");
		public var monthFullEn:Array = new Array("January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December");
		public var monthOldJp:Array = new Array("睦月", "如月", "弥生", "卯月", "皐月", "水無月","文月", "葉月", "長月", "神無月", "霜月", "師走");
		public var dateSuffix:Array = new Array("st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th","th", "th", "th", "th", "th", "th", "th", "th", "th", "th","st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "st");
		public static const HOURS_CHANGED:String = "hoursChanged";
		public static const MINUTES_CHANGED:String = "minutesChanged";
		public static const SECONDS_CHANGED:String = "secondsChanged";
		
		private function enterFrameListener(e:Event):void
		{
			date = new Date();
			var year:int = date.getFullYear();
			var month:int = date.getMonth();
			var day:int = date.getDay();
			var hours:int = date.getHours();
			var minutes:int = date.getMinutes();
			var seconds:int = date.getSeconds();
			
			if (seconds != _seconds) {
				dispatchEvent(new Event(SECONDS_CHANGED));
				if (seconds == 0) {
					dispatchEvent(new Event(MINUTES_CHANGED));
					if (minutes == 0) {
						dispatchEvent(new Event(HOURS_CHANGED));
					}
				}
			}
			_seconds = seconds;
		}
		
		/**
		 * 日付文字列の書式を指定して日付を取得します。
		 * 日付文字列の書式は以下のとおりです。
		 * Y 年。4桁の数字。
		 * y 年。2桁の数字。
		 * m 月。数字。先頭にゼロをつける。
		 * n 月。数字。先頭にゼロをつけない。
		 * F 月。フルスペルの文字。
		 * M 月。3文字形式。
		 * O 月。旧暦日本語。
		 * d 日。数字。先頭にゼロをつける。
		 * j 日。数字。先頭にゼロをつけない。
		 * w 曜日。数値。
		 * l 曜日。フルスペルの文字。
		 * D 曜日。3文字形式。
		 * N 曜日。ISO-8601形式の数値。
		 * J 曜日。日本語。
		 * g 時。12時間単位。先頭にゼロをつけない。
		 * G 時。24時間単位。先頭にゼロをつけない。
		 * h 時。12時間単位。先頭にゼロをつける。
		 * H 時。24時間単位。先頭にゼロをつける。
		 * i 分。数字。先頭にゼロをつける。
		 * s 秒。数字。先頭にゼロをつける。
		 * a 午前または午後。（小文字）
		 * A 午前または午後。（大文字）
		 * S 英語形式の序数を表すサフィックス。2文字。
		 * z 年間の通算日。数字。(ゼロから開始)
		 * t 指定した月の日数。
		 * L 閏年であるかどうか。
		 * 
		 * @param 日付文字列の書式
		 * @return 日付
		 */
		public function format(pattern:String):String
		{
			var year:int = date.getFullYear();
			var month:int = date.getMonth();
			var d:int = date.getDate();
			var day:int = date.getDay();
			var hours:int = date.getHours();
			var minutes:int = date.getMinutes();
			var seconds:int = date.getSeconds();
			var res:String = "";
			for(var i:uint = 0; i < pattern.length; i++) {
				var s:String = pattern.charAt(i);
				switch(s) {
					case "#":
						if(i == pattern.length-1) {
							break;
						}
						res += pattern.charAt(++i);
						break;
					case "Y":
						res += year;
						break;
					case "y":
						res += year.toString().substr(2, 2);
						break;
					case "m":
						res += preZero(month+1);
						break;
					case "n":
						res += month+1;
						break;
					case "d":
						res += preZero(d);
						break;
					case "j":
						res += d;
						break;
					case "w":
						res += day;
						break;
					case "N" :
						res += isoDay(day);
						break;
					case "l" :
						res += weekFullEn[day];
						break;
					case "D" :
						res += weekFullEn[day].substr(0, 3);
						break;
					case "J" :
						res += weekJp[day];
						break;
					case "F" :
						res += monthFullEn[month];
						break;
					case "M" :
						res += monthFullEn[month].substr(0, 3);
						break;
					case "O" :
						res += monthOldJp[month];
						break;
					case "a" :
						res += ampm(hours);
						break;
					case "A" :
						res += ampm(hours).toUpperCase();
						break;
					case "H" :
						res += preZero(hours);
						break;
					case "h" :
						res += preZero(from24to12(hours));
						break;
					case "g" :
						res += from24to12(hours);
						break;
					case "G" :
						res += hours;
						break;
					case "i" :
						res += preZero(minutes);
						break;
					case "s" :
						res += preZero(seconds);
						break;
					case "t" :
						res += lastDayOfMonth(date);
						break;
					case "L" :
						res += isLeapYear(year);
						break;
					case "z" :
						res += dateCount(year, month, d);
						break;
					case "S" :
						res += dateSuffix[d - 1];
						break;
					default :
						res += s;
						break;						
				}
			}
			return res;
		}
		
		/**
		 * 10より小さい数値のとき先頭に0をつけた文字列を返します。
		 * 
		 * @param 
		 * @return 
		 */
		private function preZero(v:int):String
		{
			return v < 10 ? "0" + v.toString() : v.toString();
		}
		
		/**
		 * 24時間制を12時間制に変換します。
		 * 
		 * @param
		 * @return
		 */
		private function from24to12(hours:int):int
		{
			return hours > 12 ? hours - 12 : hours;
		}
		
		/**
		 * AMまたはPMを返します。
		 * 
		 * @param
		 * @return
		 */
		private function ampm(hours:int):String
		{
			return hours < 12 ? "am" : "pm";
		}
		
		/**
		 * ISO Dayを返します。
		 * 
		 * @param
		 * @return
		 */		
		private function isoDay(day:int):String
		{
			return day == 0 ? "7" : day.toString();
		}
		
		/**
		 * 指定した年月の月数を返します。
		 * 
		 * @param
		 * @return
		 */
		private function lastDayOfMonth(dateObj:Date):uint
		{
			var tmp:Date = new Date(dateObj.getFullYear(), dateObj.getMonth() + 1, 1);
			tmp.setTime(tmp.getTime() - 1);
			return tmp.getDate();
		}
		
		/**
		 * 指定した年が閏年のとき1を返します。
		 * 
		 * @param
		 * @return
		 */
		private function isLeapYear(year:int):String
		{
			var tmp:Date = new Date(year, 0, 1);
			var sum:uint = 0;
			for (var i:int = 0; i < 12; i++) {
				tmp.setMonth(i);
				sum += lastDayOfMonth(tmp);
			}
			return (sum == 365) ? "0" : "1";
		}
		
		/**
		 * 指定した年月日の年始からの日数を返します。
		 * 
		 * @param
		 * @return
		 */
		private function dateCount(year:int, month:int, date:int):uint
		{
			var tmp :Date= new Date(year, 0, 1);
			var sum:int = -1;
			for (var i:int = 0; i < month; i++) {
				tmp.setMonth(i);
				sum += lastDayOfMonth(tmp);
			}
			return sum + date;
		}
	}
}