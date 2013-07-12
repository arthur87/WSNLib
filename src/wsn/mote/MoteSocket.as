package wsn.mote
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
	
	/**
	 * MoteSocketはXMLSocketを継承しており、Flash PlayerまたはAIRアプリケーションはこのソケットを利用して、
	 * IPアドレスまたはドメイン名で識別されるサーバーコンピュータと通信できます。
	 * @example 次の例では、MoteSocketでデータを受信します。
	 * <listing version="3.0">
	 * import wsn.mote.*;
	 * private function init():void
	 * {
	 * 	var socket:MoteSocket = new MoteSocket("127.0.0.1", 9000, "demo-pkt.xml");
	 * 	socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	 * 	socket.addEventListener(MotePacketEvent.PACKET_IN, dataEventHandler);
	 * }
	 * private function dataEventHandler(e:MotePacketEvent):void
	 * {
	 * 	var packet:MotePacket = e.data;
	 * }
	 * private function ioErrorHandler(e:IOErrorEvent):void
	 * {
	 *	trace(e);
	 * }
	 * </listing>
	 */		
	public class MoteSocket extends XMLSocket
	{
		private var host:String = null;
		private var port:int = 0;
		private var packetStruct:Array;
		/**
		 * 新しいMoteSocketオブジェクトを作成します。
		 * @param host FQDN（完全修飾ドメイン名）、つまり111.222.333.444という形式のIPアドレスです。
		 * @param port 接続の確立に使用するターゲットホスト上のTCPポート番号です。
		 * @param pktConfigXml パケットの構造を記述したXMLファイルです。
		 */
		public function MoteSocket(host:String = null, port:int = 0, pktConfigXml:* = null)
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
		private var linkSourceAddress:String = "";
		private var messageLength:int = 0;
		private var groupId:int = 0;
		private var activeMessageHandler:int = 0;
		private var data:Array = new Array();

		private function dataEventHandler(e:DataEvent):void
		{
			var b:int = Number(e.data);
			if(packetCount == 0 && b == 0) {packetCount = 1;}
			else if(packetCount == 1 && b == 255) {packetCount = 2;}
			else if(packetCount == 1 && b != 255) {packetCount = 0;}
			else if(packetCount == 2 && b == 255) {packetCount = 3;}
			else if(packetCount == 2 && b != 255) {packetCount = 0;}
			else if(packetCount == 3 || packetCount == 4) {this.linkSourceAddress += b.toString(16); packetCount++;}
			else if(packetCount == 5) {this.messageLength = b; packetCount = 6;}
			else if(packetCount == 6) {this.groupId = b; packetCount = 7;}
			else if(packetCount == 7) {this.activeMessageHandler = b; packetCount = 8;}
			else if(packetCount >= 8 && packetCount < 8 + this.messageLength)
			{
				data[packetCount - 8] = b;
				packetCount++;
			}
			else if(packetCount == 8 + this.messageLength)
			{
				var packet:MotePacket = new MotePacket();
				for(var i:int = 0; i < packetStruct.length; i++) {
					var key:String = packetStruct[i].key;
					var length:int = packetStruct[i].length;
					var offset:int = packetStruct[i].offset;
					var value:String = "";
					for(var j:int = offset; j < offset + length; j++) {
						if(data[j].toString(16).length == 1){
							value = "0" + data[j].toString(16) + value;
						}else{
							value = data[j].toString(16) + value;
						}
					}
					packet.setItem(key, parseInt(value, 16));
				}
				packet.linkSourceAddress = this.linkSourceAddress;
				packet.groupId = this.groupId;
				packet.activeMessageHandler = this.activeMessageHandler;
				packet.messageLength = this.messageLength;
				this.linkSourceAddress = "";
				this.packetCount = 0;
				dispatchEvent(new MotePacketEvent(MotePacketEvent.PACKET_IN, packet));
			}
		}
	}
}
