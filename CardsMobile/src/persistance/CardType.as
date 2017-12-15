package persistance
{
	import com.tonyfendall.cards.controller.util.RandomUtil;
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;
	
	import mx.core.BitmapAsset;

	public class CardType
	{
		
		
		public static const TYPES:Array = [
			new CardType(0, "Goblin", CardImages.IMG01, 0, 0, "P", 0, 0, 0, 0),
			new CardType(1, "Fang", CardImages.IMG02, 0, 0, "P", 0, 0, 0, 0),
			new CardType(2, "Skeleton", CardImages.IMG03, 0, 0, "P", 0, 0, 0, 0),
			new CardType(3, "Flan", CardImages.IMG04, 0, 0, "M", 0, 0, 0, 1),
			new CardType(4, "Zaghnol", CardImages.IMG05, 0, 0, "P", 0, 0, 0, 0),
			new CardType(5, "Lizardman", CardImages.IMG06, 0, 1, "P", 0, 0, 0, 0),
			new CardType(6, "Zombie", CardImages.IMG07, 0, 1, "P", 0, 1, 0, 0),
			new CardType(7, "Bomb", CardImages.IMG08, 0, 1, "M", 0, 0, 0, 1),
			new CardType(8, "Ironite", CardImages.IMG09, 0, 1, "P", 0, 1, 0, 0),
			new CardType(9, "Sahagin", CardImages.IMG10, 0, 1, "P", 0, 1, 0, 0),
			new CardType(10, "Yeti", CardImages.IMG11, 0, 1, "M", 0, 0, 0, 1),
			new CardType(11, "Mimic", CardImages.IMG12, 0, 1, "M", 0, 1, 0, 1),
			new CardType(12, "Wyerd", CardImages.IMG13, 0, 1, "M", 0, 0, 0, 2),
			new CardType(13, "Mandragora", CardImages.IMG14, 0, 2, "M", 0, 0, 0, 2),
			new CardType(14, "Crawler", CardImages.IMG15, 0, 2, "P", 0, 2, 0, 0),
			new CardType(15, "S. Scorpion", CardImages.IMG16, 0, 2, "P", 0, 2, 0, 1),
			new CardType(16, "Nymph", CardImages.IMG17, 0, 2, "M", 0, 0, 0, 2),
			new CardType(17, "Sand Golom", CardImages.IMG18, 0, 2, "P", 0, 2, 0, 1),
			new CardType(18, "Zuu", CardImages.IMG19, 0, 2, "P", 0, 0, 0, 2),
			new CardType(19, "Dragonfly", CardImages.IMG20, 0, 2, "P", 0, 2, 0, 1),
			new CardType(20, "Carrion Worm", CardImages.IMG21, 0, 2, "M", 0, 1, 0, 1),
			new CardType(21, "Cerberus", CardImages.IMG22, 0, 3, "P", 0, 2, 0, 0),
			new CardType(22, "Antlion", CardImages.IMG23, 0, 3, "P", 0, 3, 0, 1),
			new CardType(23, "Cactuar", CardImages.IMG24, 0, 3, "P", 0, 12, 0, 0),
			new CardType(24, "Gimme Cat", CardImages.IMG25, 0, 3, "M", 0, 2, 0, 1),
			new CardType(25, "Ragtimer", CardImages.IMG26, 0, 3, "M", 0, 2, 0, 1),
			new CardType(26, "Hedgehog Pie", CardImages.IMG27, 0, 3, "M", 0, 1, 0, 2),
			new CardType(27, "Raluimahgo", CardImages.IMG28, 0, 3, "P", 0, 4, 0, 0),
			new CardType(28, "Ocho", CardImages.IMG29, 0, 3, "P", 0, 2, 0, 1),
			new CardType(29, "Troll", CardImages.IMG30, 0, 4, "P", 0, 3, 0, 2),
			new CardType(30, "Blazer Beetle", CardImages.IMG31, 0, 4, "P", 0, 5, 0, 1),
			new CardType(31, "Abomination", CardImages.IMG32, 0, 4, "P", 0, 3, 0, 3),
			new CardType(32, "Zemzelett", CardImages.IMG33, 0, 4, "M", 0, 2, 0, 6),
			new CardType(33, "Stroper", CardImages.IMG34, 0, 4, "P", 0, 4, 0, 0),
			new CardType(34, "Tantarian", CardImages.IMG35, 0, 4, "M", 0, 2, 0, 2),
			new CardType(35, "Grand Dragon", CardImages.IMG36, 0, 4, "P", 0, 4, 0, 4),
			new CardType(36, "Feather Circle", CardImages.IMG37, 0, 4, "M", 0, 2, 0, 2),
			new CardType(37, "Hecteyes", CardImages.IMG38, 0, 5, "M", 0, 0, 0, 4),
			new CardType(38, "Ogre", CardImages.IMG39, 0, 5, "P", 0, 4, 0, 1),
			new CardType(39, "Armstrong", CardImages.IMG40, 0, 5, "M", 0, 2, 0, 4),
			new CardType(40, "Ash", CardImages.IMG41, 0, 5, "M", 0, 3, 0, 3),
			new CardType(41, "Wraith", CardImages.IMG42, 0, 5, "M", 0, 5, 0, 1),
			new CardType(42, "Gargoyle", CardImages.IMG43, 0, 5, "M", 0, 3, 0, 2),
			new CardType(43, "Vepal", CardImages.IMG44, 0, 5, "M", 0, 3, 0, 3),
			new CardType(44, "Grimlock", CardImages.IMG45, 0, 5, "M", 0, 2, 0, 3),
			new CardType(45, "Tonberry", CardImages.IMG46, 0, 2, "P", 0, 3, 0, 3),
			new CardType(46, "Veteran", CardImages.IMG47, 0, 5, "M", 0, 1, 0, 9),
			new CardType(47, "Garuda", CardImages.IMG48, 0, 6, "M", 0, 4, 0, 1),
			new CardType(48, "Malboro", CardImages.IMG49, 0, 5, "M", 0, 3, 0, 6),
			new CardType(49, "Mover", CardImages.IMG50, 0, 6, "M", 0, 15, 0, 0),
			new CardType(50, "Abadon", CardImages.IMG51, 0, 7, "M", 0, 6, 0, 2),
			new CardType(51, "Behemoth", CardImages.IMG52, 0, 11, "P", 0, 4, 0, 6),
			new CardType(52, "Iron Man", CardImages.IMG53, 0, 12, "P", 0, 6, 0, 0),
			new CardType(53, "Nova Dragon", CardImages.IMG54, 0, 14, "P", 0, 7, 0, 12),
			new CardType(54, "Ozma", CardImages.IMG55, 0, 13, "M", 0, 0, 0, 12),
			new CardType(55, "Hades", CardImages.IMG56, 0, 15, "M", 0, 12, 0, 1),
			new CardType(56, "Holy", CardImages.IMG57, 0, 8, "M", 0, 2, 0, 3),
			new CardType(57, "Meteor", CardImages.IMG58, 0, 11, "M", 0, 10, 0, 0),
			new CardType(58, "Flare", CardImages.IMG59, 0, 13, "M", 0, 1, 0, 1),
			new CardType(59, "Shiva", CardImages.IMG60, 0, 5, "M", 0, 0, 0, 5),
			new CardType(60, "Ifrit", CardImages.IMG61, 0, 6, "M", 0, 9, 0, 1),
			new CardType(61, "Ramuh", CardImages.IMG62, 0, 4, "M", 0, 1, 0, 6),
			new CardType(62, "Atomos", CardImages.IMG63, 0, 4, "M", 0, 6, 0, 6),
			new CardType(63, "Odin", CardImages.IMG64, 0, 12, "M", 0, 8, 0, 4),
			new CardType(64, "Leviathan", CardImages.IMG65, 0, 11, "M", 0, 6, 0, 1),
			new CardType(65, "Bahamut", CardImages.IMG66, 0, 12, "M", 0, 9, 0, 5),
			new CardType(66, "Ark", CardImages.IMG67, 0, 14, "M", 0, 6, 0, 5),
			new CardType(67, "Fenrir", CardImages.IMG68, 0, 8, "M", 0, 2, 0, 1),
			new CardType(68, "Madeen", CardImages.IMG69, 0, 10, "M", 0, 1, 0, 6),
			new CardType(69, "Alexander", CardImages.IMG70, 0, 14, "M", 0, 11, 0, 5),
			new CardType(70, "Excalibur 2", CardImages.IMG71, 0, 15, "P", 0, 11, 0, 0),
			new CardType(71, "Ultima Weapon", CardImages.IMG72, 0, 15, "P", 0, 1, 0, 6),
			new CardType(72, "Masamune", CardImages.IMG73, 0, 12, "P", 0, 11, 0, 3),
			new CardType(73, "Elixer", CardImages.IMG74, 0, 6, "M", 0, 6, 0, 6),
			new CardType(74, "Dark Matter", CardImages.IMG75, 0, 12, "M", 0, 3, 0, 12),
			new CardType(75, "Ribbon", CardImages.IMG76, 0, 0, "M", 0, 12, 0, 15),
			new CardType(76, "Tiger Paw Racket", CardImages.IMG77, 0, 0, "P", 0, 0, 0, 1),
			new CardType(77, "Save The Queen", CardImages.IMG78, 0, 7, "P", 0, 3, 0, 0),
			new CardType(78, "Genji", CardImages.IMG79, 0, 0, "P", 0, 6, 0, 10),
			new CardType(79, "Mythril Sword", CardImages.IMG80, 0, 2, "P", 0, 0, 0, 0)
		];
		
		
		public var id:uint;
		public var name:String;
		public var image:BitmapAsset;
		
		public var attack_min:int;
		public var attack_max:int;

		public var attack_type:String;

		public var pdef_min:int;
		public var pdef_max:int;
		
		public var mdef_min:int;
		public var mdef_max:int;
		
		
		public function CardType(id:uint, name:String, image:BitmapAsset, attack_min:int, attack_max:int, attack_type:String, pdef_min:int, pdef_max:int, mdef_min:int, mdef_max:int)
		{
			this.id = id;
			this.name = name;
			this.image = image;
			this.attack_min =attack_min;
			this.attack_max = attack_max;
			this.attack_type = attack_type;
			this.pdef_min = pdef_min;
			this.pdef_max = pdef_max;
			this.mdef_min = mdef_min;
			this.mdef_max = mdef_max;
		}
		
		
		public function generateCard(owner:PlayerBase):Card
		{
			var card:Card = new Card();
			
			card.originalOwner = card.currentOwner = owner;
			
			card.attack = RandomUtil.getBellRandom(attack_min, attack_max); // TODO decide how best to ensure the right range of numbers
			card.type = attack_type;
			card.physDef = RandomUtil.getBellRandom(pdef_min, pdef_max);
			card.magicDef = RandomUtil.getBellRandom(mdef_min, mdef_max);
			card.arrows = Math.floor( Math.random() * 0x100 );
			card.cardType = this;
			
			return card;
		}
		
	}
}