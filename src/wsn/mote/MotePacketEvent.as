package wsn.mote
{
	import flash.events.Event;
	[Exclude(name="clone",kind="method")]
	public class MotePacketEvent extends Event
	{
		public static const PACKET_IN:String = "PacketIn";
		public static const PACKET_OUT:String = "PacketOut";
		public var data:MotePacket;
		public function MotePacketEvent(type:String, data:MotePacket)
		{
			super(type);
			this.data = data;
		}
		public override function clone():Event
		{
			return new MotePacketEvent(type, data);
		}
	}
}