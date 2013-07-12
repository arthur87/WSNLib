package wsn.data
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class ADB
	{
		private var connection:SQLConnection = new SQLConnection();
		private var statement:SQLStatement = new SQLStatement;
		
		public function ADB(name:String, config:* = null)
		{
			var path:String = "app-storage:/";
			var sync:Boolean = false;
			var clear:Boolean = false;
			var autoCompact:Boolean = false;
			var pageSize:int = 1024;
			var encryptionKey:ByteArray = null;
			for(var key:String in config){
				switch(key){
					case "path": path = config[key]; break;
					case "sync": sync = config[key];break;
					case "clear": clear = config[key];break;
					case "autoCompact": autoCompact = config[key];break;
					case "pageSize": pageSize = config[key];break;
					case "encryptionKey": encryptionKey.writeUTFBytes(config[key]);break;
				}
			}
			var file:File = new File(path + name + ".db");
			if(clear && file.exists){
				file.deleteFile();
			}
			if(sync){
				connection.openAsync(file, SQLMode.CREATE, null,autoCompact, pageSize, encryptionKey);
			}else{
				connection.open(file, SQLMode.CREATE, autoCompact, pageSize, encryptionKey);
			}
			connection.addEventListener(SQLEvent.OPEN, sqlEventHandler);
			connection.addEventListener(SQLErrorEvent.ERROR, sqlErrorEventHandler);
			statement.addEventListener(SQLEvent.RESULT, sqlEventHandler);
			statement.addEventListener(SQLErrorEvent.ERROR, sqlErrorEventHandler);
		}
		public function query(query:String):SQLResult
		{
			statement.sqlConnection = connection;
			statement.text = query;
			statement.execute();
			return statement.getResult();
		}
		public function insert(table:String, data:Object):SQLResult
		{
			var query:String = "INSERT INTO " + table + " (";
			var key:String;
			var fields:Array = [];
			var values:Array = [];
			for(key in data){
				fields.push(key);
			}
			query = query + fields.join(",") + ") VALUES(";
			for(key in data){
				values.push(createCondition(data[key]));
			}
			query = query + values.join(",") + ");";
			trace(query);
			return this.query(query);
		}
		public function update(table:String, data:Object, condition:* = null):SQLResult
		{
			var query:String = "UPDATE " + table + " SET ";
			var fields:Array = [];
			var key:String;
			for(key in data){
				fields.push(key + "=" + createCondition(data[key]));
			}
			query = query + fields.join(",") + " WHERE " + parseCondition(condition)　+ ";";
			return this.query(query);
		}
		public function del(table:String, condition:* = null):SQLResult
		{
			var query:String = "DELETE FROM " + table + " WHERE " + parseCondition(condition) + ";";
			return this.query(query);
		}
		public function find(table:String, condition:* = null, group:String = "", order:String="", limit:String = ""):SQLResult
		{
			var query:String = "SELECT * FROM " + table;
			var fields:Array = [];
			if(condition) query = query + " WHERE " + parseCondition(condition);
			if(group) query = query + " GROUP BY " + group;
			if(order) query = query + " ORDER BY " + order;
			if(limit) query = query + " limit " + limit;
			query = query + ";";
			return this.query(query);
		}
		public function create(table:String, data:Object, exist:Boolean = false):SQLResult
		{
			var query:String = "CREATE TABLE ";
			if(exist){
				query += "IF NOT EXISTS ";
			}
			var fields:Array = [];
			var key:String;
			for(key in data){
				fields.push(key + " " + data[key]);
			}
			query = query + table + "(" + fields.join(" ") + ");";
			return this.query(query);
		}
		public function drop(table:String):SQLResult
		{
			var query:String = "DROP TABLE " + table + ";";
			return this.query(query);
		}
		public function close():void
		{
			connection.close();
		}
		private function parseCondition(data:*):String
		{
			if(data == null) return "";
			if(data is String) return data;
			var query:String;
			var fields:Array = [];
			var key:String;
			for(key in data){
				fields.push(key + "=" + createCondition(data[key]));
			}
			return fields.join(" AND ");
			
		}
		private function createCondition(data:*):String
		{
			if(data == null) return "";
			if(data is String){
				var reg:RegExp = new RegExp("'", "g");
				data = data.replace(reg, "''");
				return "'" + data + "'";
			}
			return data;
		}
		private function sqlEventHandler(event:SQLEvent):void
		{
		}
		private function sqlErrorEventHandler(event:SQLErrorEvent):void
		{
		}
	}
}