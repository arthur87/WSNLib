package wsn.mote
{
	public class MotePacket
	{
		/**
		 * linkSourceAddressです。
		 */ 
		public var linkSourceAddress:String;
		/**
		 * messageLengthです。
		 */ 
		public var messageLength:int = 0;
		/**
		 * groupIdです。
		 */ 
		public var groupId:int = 0;
		/**
		 * activeMessageHandlerです。
		 */ 
		public var activeMessageHandler:int = 0;
		private var data:Array = new Array();
		/**
		 * 新しいMotePacketを作成します。
		 */ 
		public function MotePacket()
		{
		}
		/**
		 * 指定された値を設定します。
		 * @param key キーです。
		 * @param value 値です。
		 */
		public function setItem(key:String, value:int):void
		{
			this.data[key] = value;
		}
		/**
		 * 指定された値を取得します。
		 * @param key キーです。
		 * @return 値です。
		 */
		public function getItem(key:String):int
		{
			var value:int = 0;
			try {
				value = parseInt(this.data[key].toString(), 10);
			}catch(e:Error){
			}
			return value;
		}
	}
}