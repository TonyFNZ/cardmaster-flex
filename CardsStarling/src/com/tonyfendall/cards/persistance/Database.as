package com.tonyfendall.cards.persistance
{
	import flash.data.SQLConnection;
	import flash.errors.SQLError;
	import flash.filesystem.File;

	public class Database
	{
		private static const FILENAME:String = "Cards.db";
		
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
			
			_file = File.applicationStorageDirectory.resolvePath(FILENAME);
			if(!_file.exists) {
				// Database doesn't exist yet, so copy the seed database into the storage directory
				trace("Create Initial Database");
				var template:File = File.applicationDirectory.resolvePath(FILENAME);
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