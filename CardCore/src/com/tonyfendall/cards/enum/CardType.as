package com.tonyfendall.cards.enum
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.player.PlayerBase;
	import com.tonyfendall.cards.util.RandomUtil;

	public class CardType
	{
		
		
		public static const TYPES:Array = [
			new CardType(0, "Goblin",  0, 0, "P", 0, 0, 0, 0),
			new CardType(1, "Fang",  0, 0, "P", 0, 0, 0, 0),
			new CardType(2, "Skeleton",  0, 0, "P", 0, 0, 0, 0),
			new CardType(3, "Flan",  0, 0, "M", 0, 0, 0, 1),
			new CardType(4, "Zaghnol",  0, 0, "P", 0, 0, 0, 0),
			new CardType(5, "Lizardman",  0, 1, "P", 0, 0, 0, 0),
			new CardType(6, "Zombie",  0, 1, "P", 0, 1, 0, 0),
			new CardType(7, "Bomb",  0, 1, "M", 0, 0, 0, 1),
			new CardType(8, "Ironite",  0, 1, "P", 0, 1, 0, 0),
			new CardType(9, "Sahagin",  0, 1, "P", 0, 1, 0, 0),
			new CardType(10, "Yeti",  0, 1, "M", 0, 0, 0, 1),
			new CardType(11, "Mimic",  0, 1, "M", 0, 1, 0, 1),
			new CardType(12, "Wyerd",  0, 1, "M", 0, 0, 0, 2),
			new CardType(13, "Mandragora",  0, 2, "M", 0, 0, 0, 2),
			new CardType(14, "Crawler",  0, 2, "P", 0, 2, 0, 0),
			new CardType(15, "S. Scorpion",  0, 2, "P", 0, 2, 0, 1),
			new CardType(16, "Nymph",  0, 2, "M", 0, 0, 0, 2),
			new CardType(17, "Sand Golom",  0, 2, "P", 0, 2, 0, 1),
			new CardType(18, "Zuu",  0, 2, "P", 0, 0, 0, 2),
			new CardType(19, "Dragonfly",  0, 2, "P", 0, 2, 0, 1),
			new CardType(20, "Carrion Worm",  0, 2, "M", 0, 1, 0, 1),
			new CardType(21, "Cerberus",  0, 3, "P", 0, 2, 0, 0),
			new CardType(22, "Antlion",  0, 3, "P", 0, 3, 0, 1),
			new CardType(23, "Cactuar",  0, 3, "P", 0, 12, 0, 0),
			new CardType(24, "Gimme Cat",  0, 3, "M", 0, 2, 0, 1),
			new CardType(25, "Ragtimer",  0, 3, "M", 0, 2, 0, 1),
			new CardType(26, "Hedgehog Pie",  0, 3, "M", 0, 1, 0, 2),
			new CardType(27, "Raluimahgo",  0, 3, "P", 0, 4, 0, 0),
			new CardType(28, "Ocho",  0, 3, "P", 0, 2, 0, 1),
			new CardType(29, "Troll",  0, 4, "P", 0, 3, 0, 2),
			new CardType(30, "Blazer Beetle",  0, 4, "P", 0, 5, 0, 1),
			new CardType(31, "Abomination",  0, 4, "P", 0, 3, 0, 3),
			new CardType(32, "Zemzelett",  0, 4, "M", 0, 2, 0, 6),
			new CardType(33, "Stroper",  0, 4, "P", 0, 4, 0, 0),
			new CardType(34, "Tantarian",  0, 4, "M", 0, 2, 0, 2),
			new CardType(35, "Grand Dragon",  0, 4, "P", 0, 4, 0, 4),
			new CardType(36, "Feather Circle",  0, 4, "M", 0, 2, 0, 2),
			new CardType(37, "Hecteyes",  0, 5, "M", 0, 0, 0, 4),
			new CardType(38, "Ogre",  0, 5, "P", 0, 4, 0, 1),
			new CardType(39, "Armstrong",  0, 5, "M", 0, 2, 0, 4),
			new CardType(40, "Ash",  0, 5, "M", 0, 3, 0, 3),
			new CardType(41, "Wraith",  0, 5, "M", 0, 5, 0, 1),
			new CardType(42, "Gargoyle",  0, 5, "M", 0, 3, 0, 2),
			new CardType(43, "Vepal",  0, 5, "M", 0, 3, 0, 3),
			new CardType(44, "Grimlock",  0, 5, "M", 0, 2, 0, 3),
			new CardType(45, "Tonberry",  0, 2, "P", 0, 3, 0, 3),
			new CardType(46, "Veteran",  0, 5, "M", 0, 1, 0, 9),
			new CardType(47, "Garuda",  0, 6, "M", 0, 4, 0, 1),
			new CardType(48, "Malboro",  0, 5, "M", 0, 3, 0, 6),
			new CardType(49, "Mover",  0, 6, "M", 0, 15, 0, 0),
			new CardType(50, "Abadon",  0, 7, "M", 0, 6, 0, 2),
			new CardType(51, "Behemoth",  0, 11, "P", 0, 4, 0, 6),
			new CardType(52, "Iron Man",  0, 12, "P", 0, 6, 0, 0),
			new CardType(53, "Nova Dragon",  0, 14, "P", 0, 7, 0, 12),
			new CardType(54, "Ozma",  0, 13, "M", 0, 0, 0, 12),
			new CardType(55, "Hades",  0, 15, "M", 0, 12, 0, 1),
			new CardType(56, "Holy",  0, 8, "M", 0, 2, 0, 3),
			new CardType(57, "Meteor",  0, 11, "M", 0, 10, 0, 0),
			new CardType(58, "Flare",  0, 13, "M", 0, 1, 0, 1),
			new CardType(59, "Shiva",  0, 5, "M", 0, 0, 0, 5),
			new CardType(60, "Ifrit",  0, 6, "M", 0, 9, 0, 1),
			new CardType(61, "Ramuh",  0, 4, "M", 0, 1, 0, 6),
			new CardType(62, "Atomos",  0, 4, "M", 0, 6, 0, 6),
			new CardType(63, "Odin",  0, 12, "M", 0, 8, 0, 4),
			new CardType(64, "Leviathan",  0, 11, "M", 0, 6, 0, 1),
			new CardType(65, "Bahamut",  0, 12, "M", 0, 9, 0, 5),
			new CardType(66, "Ark",  0, 14, "M", 0, 6, 0, 5),
			new CardType(67, "Fenrir",  0, 8, "M", 0, 2, 0, 1),
			new CardType(68, "Madeen",  0, 10, "M", 0, 1, 0, 6),
			new CardType(69, "Alexander",  0, 14, "M", 0, 11, 0, 5),
			new CardType(70, "Excalibur 2",  0, 15, "P", 0, 11, 0, 0),
			new CardType(71, "Ultima Weapon",  0, 15, "P", 0, 1, 0, 6),
			new CardType(72, "Masamune",  0, 12, "P", 0, 11, 0, 3),
			new CardType(73, "Elixer",  0, 6, "M", 0, 6, 0, 6),
			new CardType(74, "Dark Matter",  0, 12, "M", 0, 3, 0, 12),
			new CardType(75, "Ribbon",  0, 0, "M", 0, 12, 0, 15),
			new CardType(76, "Tiger Paw Racket",  0, 0, "P", 0, 0, 0, 1),
			new CardType(77, "Save The Queen",  0, 7, "P", 0, 3, 0, 0),
			new CardType(78, "Genji",  0, 0, "P", 0, 6, 0, 10),
			new CardType(79, "Mythril Sword",  0, 2, "P", 0, 0, 0, 0)
		];
		
		
		public var id:uint;
		public var name:String;
		
		public var attack_min:int;
		public var attack_max:int;

		public var attack_type:String;

		public var pdef_min:int;
		public var pdef_max:int;
		
		public var mdef_min:int;
		public var mdef_max:int;
		
		
		public function CardType(id:uint, name:String, attack_min:int, attack_max:int, attack_type:String, pdef_min:int, pdef_max:int, mdef_min:int, mdef_max:int)
		{
			this.id = id;
			this.name = name;
			this.attack_min = attack_min;
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