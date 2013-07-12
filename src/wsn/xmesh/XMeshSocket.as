package wsn.xmesh
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.XMLSocket;
	
	[Event(name="PacketOut", type="PacketDataEvent")]
	[Event(name="PacketIn", type="PacketDataEvent")]

	public class XMeshSocket extends XMLSocket
	{
		private var host:String = null;
		private var port:int = 0;
		private var packetStruct:Array;
		public function XMeshSocket(host:String = null, port:int = 0, pktConfigXml:* = null)	
		{
			this.host = host;
			this.port = port;
			if(pktConfigXml is String) {
				var urlReq:URLRequest = new URLRequest(pktConfigXml);
				var urlLoader:URLLoader = new URLLoader(urlReq);
				urlLoader.addEventListener(Event.COMPLETE, xmlEventCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			}
			if(pktConfigXml is XMLList) {
				start(pktConfigXml);
			}
		}
		private function xmlEventCompleteHandler(e:Event):void
		{
			var xmlList:XMLList = new XMLList(e.target.data);
			start(xmlList);
		}
		private function start(xmlList:XMLList):void
		{
			packetStruct = new Array();
			for(var i:int = 0; i < xmlList.packet.length(); i++) {
				var o:Object = new Object();
				o.key = xmlList.packet[i].@key;
				o.length = xmlList.packet[i].@length;
				o.offset = xmlList.packet[i].@offset;
				packetStruct.push(o);
			}
			this.addEventListener(DataEvent.DATA, dataEventHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
			
			this.connect(this.host, this.port);
		}
		private function ioErrorEventHandler(e:IOErrorEvent):void
		{
			
		}
		private function securityErrorEventHandler(e:SecurityErrorEvent):void
		{
		}
		private var packetCount:int = 0;
		private var groupId:int = 0;
		private var messageLength:int = 0;
		private var amtype:int = 0;
		private var data:Array = new Array();
		private function dataEventHandler(e:DataEvent):void
		{
			var b:int = Number(e.data);
			if(packetCount == 0 && b == 126) {packetCount = 1;}
			else if(packetCount == 1 && b == 66) {packetCount = 2;}
			else if(packetCount == 1 && b != 66) {packetCount = 0;}
			else if(packetCount == 2 && b == 125) {packetCount = 3;}
			else if(packetCount == 2 && b != 125) {packetCount = 0;}
			else if(packetCount == 3 && b == 94) {packetCount = 4;}
			else if(packetCount == 3 && b != 94) {packetCount = 0;}
			else if(packetCount == 4 && b == 0) {packetCount = 5;}
			else if(packetCount == 4 && b != 0) {packetCount = 0;}
			else if(packetCount == 5 && b == 11) {this.amtype = b;packetCount = 6;}
			else if(packetCount == 5 && b != 11) {packetCount = 0;}
			else if(packetCount == 6) {this.groupId = b; packetCount = 7;}
			else if(packetCount == 7) {this.messageLength = b; packetCount = 8;}
			else if(packetCount >= 8 && packetCount < 9 + this.messageLength)
			{
				data[packetCount - 8] = b;
				packetCount++;
			}
			else if(packetCount == 9 + this.messageLength)
			{
				var packet:XMeshPacket = new XMeshPacket();
				for(var i:int = 0; i < packetStruct.length; i++){
					var key:String = packetStruct[i].key;
					var length:int = packetStruct[i].length;
					var offset:int = packetStruct[i].offset;
					var value:String = "";
					for(var j:int = offset; j < offset + length; j++){
						if(data[j].toString(16).length == 1){
							value = "0" + data[j].toString(16) + value;
						}else{
							value = data[j].toString(16) + value;
						}
					}
					packet.setItem(key, parseInt(value, 16));
				}
				packet.amtype = this.amtype;
				packet.groupId = this.groupId;
				packet.messageLenght = this.messageLength;
				packetCount = 0;
				dispatchEvent(new XMeshPacketEvent(XMeshPacketEvent.PACKET_IN, packet));
			}else {
				packetCount ++;
			}
		}
			
	}
}