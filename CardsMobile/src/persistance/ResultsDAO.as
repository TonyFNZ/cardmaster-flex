package persistance
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;

	public class ResultsDAO
	{
		
		
		private static const MATCH_INSERT_SQL:String = "INSERT INTO Matches (oponent, result, timestampt) VALUES (:oponent, :result, :timestamp);";
		private static const SUMMARY_UPDATE_WIN_SQL:String = "UPDATE ResultSummary SET wins = wins + 1";
		private static const SUMMARY_UPDATE_LOSE_SQL:String = "UPDATE ResultSummary SET losses = losses + 1";
		private static const SUMMARY_UPDATE_DRAW_SQL:String = "UPDATE ResultSummary SET draws = draws + 1";
		
		private static const SELECT_SUMMARY_SQL:String = "SELECT wins, losses, draws FROM ResultSummary WHERE id = 1;";
		
		private var matchInsertStatement:SQLStatement;
		private var updateWin:SQLStatement;
		private var updateLoss:SQLStatement;
		private var updateDraw:SQLStatement;
		private var selectStatement:SQLStatement;
		
		private var connection:SQLConnection;
		
		
		public function ResultsDAO(database:Database)
		{
			this.connection = database.connection;
			
			matchInsertStatement = new SQLStatement();
			matchInsertStatement.sqlConnection = connection;
			matchInsertStatement.text = MATCH_INSERT_SQL;
			
			updateWin = new SQLStatement();
			updateWin.sqlConnection = connection;
			updateWin.text = SUMMARY_UPDATE_WIN_SQL;
			updateLoss = new SQLStatement();
			updateLoss.sqlConnection = connection;
			updateLoss.text = SUMMARY_UPDATE_LOSE_SQL;
			updateDraw = new SQLStatement();
			updateDraw.sqlConnection = connection;
			updateDraw.text = SUMMARY_UPDATE_DRAW_SQL;
			
			selectStatement = new SQLStatement();
			selectStatement.sqlConnection = connection;
			selectStatement.text = SELECT_SUMMARY_SQL;
		}
		
		
		public function getResultSummary():ResultSummary
		{
			var summary:ResultSummary = new ResultSummary();
			try {
				selectStatement.execute();
			} catch(error:SQLError) {
				return summary;
			}
			
			var result:SQLResult = selectStatement.getResult();
			if(result == null || result.data == null)
				return summary; // No data found
			
			var results:Array = result.data;
			
			var row:Object = results[0];
			
			summary.wins = row.wins;
			summary.losses = row.losses;
			summary.draws = row.draws;
			
			return summary;
		}
		
		public function recordWin(oponent:String):void
		{
			trace("RECORDED WIN");
			insertMatch(oponent, "W");
			try {
				updateWin.execute();
			} catch(error:SQLError) {
				return;
			}
		}
		public function recordLoss(oponent:String):void
		{
			trace("RECORDED LOSS");
			insertMatch(oponent, "L");
			try {
				updateLoss.execute();
			} catch(error:SQLError) {
				return;
			}
		}
		public function recordDraw(oponent:String):void
		{
			trace("RECORDED DRAW");
			insertMatch(oponent, "D");
			try {
				updateDraw.execute();
			} catch(error:SQLError) {
				return;
			}
		}

		private function insertMatch(oponent:String, result:String):void
		{
			try {
				matchInsertStatement.parameters[":oponent"] = oponent;
				matchInsertStatement.parameters[":result"] = result;
				matchInsertStatement.parameters[":timestamp"] = new Date();
				matchInsertStatement.execute();
			} catch(error:SQLError) {
				return;
			}
		}

	}
}