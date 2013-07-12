package wsn.xmesh
{
	public class XMeshPacket
	{
		/**
		 * groupIdです。
		 */ 
		public var groupId:int = 0;
		/**
		 * messageLengthです。
		 */ 
		public var messageLenght:int = 0;
		/**
		 * amtypeです。
		 */ 
		public var amtype:int = 0;
		private var data:Array = new Array();
		/**
		 * 新しいXMeshPacketを作成します。
		 */ 
		public function XMeshPacket()
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