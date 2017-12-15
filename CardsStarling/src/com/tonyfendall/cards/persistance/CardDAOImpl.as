package com.tonyfendall.cards.persistance
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.enum.CardType;
	import com.tonyfendall.cards.player.PlayerBase;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	
	public class CardDAOImpl implements CardDAO
	{
		private static const INSERT_SQL:String = "INSERT INTO Deck (type_id, attack, attack_type, pdef, mdef, arrows) VALUES (:type_id, :attack, :attack_type, :pdef, :mdef, :arrows);";
		private static const UPDATE_SQL:String = "UPDATE Deck SET attack_type = :attack_type WHERE id = :id;";
		private static const DELETE_SQL:String = "DELETE FROM Deck WHERE id = :id;";
		private static const SELECT_SQL:String = "SELECT c.id, c.type_id, c.attack, c.attack_type, c.pdef, c.mdef, c.arrows, (h.card_id IS NOT NULL) \"hand\" " +
			"FROM Deck c LEFT OUTER JOIN Hand h ON c.id = h.card_id ORDER BY c.type_id;";
		
		private var insertStatement:SQLStatement;
		private var updateStatement:SQLStatement;
		private var deleteStatement:SQLStatement;
		private var selectStatement:SQLStatement;
		
		private var connection:SQLConnection;
		
		
		public function CardDAOImpl(database:Database)
		{
			this.connection = database.connection;
			
			insertStatement = new SQLStatement();
			insertStatement.sqlConnection = connection;
			insertStatement.text = INSERT_SQL;
			
			updateStatement = new SQLStatement();
			updateStatement.sqlConnection = connection;
			updateStatement.text = UPDATE_SQL;
			
			deleteStatement = new SQLStatement();
			deleteStatement.sqlConnection = connection;
			deleteStatement.text = DELETE_SQL;
			
			selectStatement = new SQLStatement();
			selectStatement.sqlConnection = connection;
			selectStatement.text = SELECT_SQL;
		}
		
		public function insert(card:Card):Boolean
		{
			insertStatement.parameters[":type_id"] = card.cardType.id;
			insertStatement.parameters[":attack"] = card.attack;
			insertStatement.parameters[":attack_type"] = card.type;
			insertStatement.parameters[":pdef"] = card.physDef;
			insertStatement.parameters[":mdef"] = card.magicDef;
			insertStatement.parameters[":arrows"] = card.arrows;
			
			try {
				insertStatement.execute();
			} catch(error:SQLError) {
				return false;
			}
			
			card.id = connection.lastInsertRowID;
			return true;
		}
		
		public function update(card:Card):Boolean
		{
			updateStatement.parameters[":attack_type"] = card.type;
			updateStatement.parameters[":id"] = card.id;
			
			try {
				updateStatement.execute();
			} catch(error:SQLError) {
				return false;
			}
			
			return true;
		}
		
		public function remove(card:Card):Boolean
		{
			deleteStatement.parameters[":id"] = card.id;
			
			try {
				deleteStatement.execute();
			} catch(error:SQLError) {
				return false;
			}
			
			return true;
		}
		
		public function getAll(owner:PlayerBase, cardsOutput:Array, handOutput:Array, groupsOutput:Array):void
		{
			try {
				selectStatement.execute();
			} catch(error:SQLError) {
				return;
			}
			
			var result:SQLResult = selectStatement.getResult();
			if(result == null || result.data == null)
				return; // No cards found
			
			var results:Array = result.data;
			
			for (var i:int = 0; i < results.length; i++) 
			{ 
				var row:Object = results[i];
				var card:Card = new Card();
				
				card.id = row.id;
				card.originalOwner = owner;
				card.currentOwner = owner;
				card.attack = row.attack;
				card.type = row.attack_type;
				card.physDef = row.pdef;
				card.magicDef = row.mdef;
				card.arrows = row.arrows;
				card.cardType = CardType.TYPES[row.type_id];
				
				cardsOutput.push(card);
				
				groupsOutput[row.type_id].children.push(card);
				groupsOutput[row.type_id].known = true;
				
				if(row.hand)
					handOutput.push(card);
			}
		}
	}
}