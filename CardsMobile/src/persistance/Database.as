package persistance
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class Database
	{
		
		private var _file:File;
		private var _connection:SQLConnection;
		
		public function Database()
		{
		}
		
		
		/**
		 * Returns true if the database had to be created
		 */
		public function init():Boolean
		{
			var created:Boolean = false;
			
			_file = File.applicationStorageDirectory.resolvePath("Cards.db");
			if(!_file.exists) {
				trace("Create Initial Database");
				var template:File = File.applicationDirectory.resolvePath("assets/Cards.db");
				template.copyTo( _file, false );
				
				created = true;
			}
			
			
			_connection = new SQLConnection();
			try{
				_connection.open(_file);
				trace("DB File OPEN");
			} catch(error:SQLError) {
				trace("DB File ERROR");
				trace(error.message);
				trace(error.details);
			}
			
			return created;
		}
		
		
		public function get connection():SQLConnection
		{
			return this._connection;	
		}
	}
}