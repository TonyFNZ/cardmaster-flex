package persistance
{
	import com.tonyfendall.cards.model.Card;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;

	
	public class HandDAO
	{
		
		private static const INSERT_SQL:String = "INSERT INTO Hand (card_id) VALUES (:card_id);";
		private static const DELETE_ALL_SQL:String = "DELETE FROM Hand";
		
		private var insertStatement:SQLStatement;
		private var deleteAllStatement:SQLStatement;
		
		private var connection:SQLConnection;
		
		
		public function HandDAO(database:Database)
		{
			this.connection = database.connection;
			
			insertStatement = new SQLStatement();
			insertStatement.sqlConnection = connection;
			insertStatement.text = INSERT_SQL;
			
			deleteAllStatement = new SQLStatement();
			deleteAllStatement.sqlConnection = connection;
			deleteAllStatement.text = DELETE_ALL_SQL;
		}
		
		
		
		public function insert(card:Card):Boolean
		{
			insertStatement.parameters[":card_id"] = card.id;
			
			try {
				insertStatement.execute();
			} catch(error:SQLError) {
				return false;
			}
			
			return true;
		}
		
		
		public function removeAll():Boolean
		{
			try {
				deleteAllStatement.execute();
			} catch(error:SQLError) {
				return false;
			}
			
			return true;
		}
	}
}