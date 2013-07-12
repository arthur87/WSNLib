package wsn.xmesh
{
	import flash.events.Event;
	[Exclude(name="clone",kind="method")]
	public class XMeshPacketEvent extends Event
	{
		public static const PACKET_IN:String = "PacketIn";
		public static const PACKET_OUT:String = "PacketOut";
		public var data:XMeshPacket;
		public function XMeshPacketEvent(type:String, data:XMeshPacket)
		{
			super(type);
			this.data = data;
		}
		public override function clone():Event
		{
			return new XMeshPacketEvent(type, data);
		}
	}
}