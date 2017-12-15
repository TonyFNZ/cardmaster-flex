package persistance
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;

	public class CollectorLevelDAO
	{
		
		
		private static const NUM_TYPES_SQL:String = "SELECT COUNT(DISTINCT type_id) as value FROM Deck;";
		private static const NUM_ARROWS_SQL:String = "SELECT COUNT(DISTINCT arrows) as value FROM Deck;";
		private static const NUM_X_SQL:String = "SELECT COUNT(*) as value FROM (SELECT id FROM Deck WHERE attack_type = 'X');";
		private static const NUM_A_SQL:String = "SELECT COUNT(*) as value FROM (SELECT id FROM Deck WHERE attack_type = 'A');";
		
		private var typesStatement:SQLStatement;
		private var arrowsStatement:SQLStatement;
		private var xStatement:SQLStatement;
		private var aStatement:SQLStatement;
		
		private var connection:SQLConnection;
		
		public function CollectorLevelDAO(database:Database)
		{
			this.connection = database.connection;
			
			typesStatement = new SQLStatement();
			typesStatement.sqlConnection = connection;
			typesStatement.text = NUM_TYPES_SQL;
			
			arrowsStatement = new SQLStatement();
			arrowsStatement.sqlConnection = connection;
			arrowsStatement.text = NUM_ARROWS_SQL;
			
			xStatement = new SQLStatement();
			xStatement.sqlConnection = connection;
			xStatement.text = NUM_X_SQL;
			
			aStatement = new SQLStatement();
			aStatement.sqlConnection = connection;
			aStatement.text = NUM_A_SQL;
		}
		
		
		public function getCollectorLevel():int
		{
			var numTypes:int = 	getInt(typesStatement);
			var numArrows:int = getInt(arrowsStatement);
			var numX:int = 		getInt(xStatement);
			var numA:int = 		getInt(aStatement);
			
			return numTypes*10 + numArrows*5 + numX + numA*2;
		}
		
		
		private function getInt(statement:SQLStatement):int
		{
			try {
				statement.execute();
				var result:SQLResult = statement.getResult();
				return result.data[0].value;
				
			} catch(error:Error) {
				trace("Error getting collector level", error);
			}
			
			return 0;
		}
	}
}