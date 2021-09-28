extends Node

const POSE_DEFAULT: String = "default"
const POSE_CHAOS: String = "chaos"
const POSE_ORDER: String = "order"
const POSE_LOVE: String = "love"

const TRY_OVER_REPLY: Array = [
	"""You  don't  give  up,  huh?
	Well,  I  guess  that  means  that  there  is
	one  admirable  thing  about  you.
	""",
	POSE_ORDER
]
const DEFAULT_REPLY: Array = ["Hmpf!", POSE_DEFAULT]
const TIMEOUT_REPLIES: Array = [
	"""I  don't  have  the  whole  day!
	""",
	"""Hurry  up!
	""",
	"""Your time ran out, tough luck.
	"""
]
const INTRO_TEXT: Array = [
	[
	"""What? 
	Were  you  talking  to  me?""",
	POSE_DEFAULT
	],
	[
	"""You  want  to  go  on  a  date  with  me?
	Sorry,  you're  not  my  type.""",
	POSE_DEFAULT
	],
	[
	"""Didn't  you  hear  me  dweeb?
	I  said  BEAT  IT!""",
	POSE_DEFAULT
	],
	[
	"""Oh,  you  wanna  win  me  over?
	Good  luck  with  that.""",
	POSE_DEFAULT
	],
	[
	"""I  feel  so  bad  for  your  chances  that  I'm
	even  gonna  help  you  out  a  bit.""",
	POSE_DEFAULT
	],
	[
	"""So  I  hope  you're  listening.""",
	POSE_DEFAULT
	],
	[
	"""I'm  only  into  chaotic  guys.  The  ones  that 
	don't  play  by  your  average  rules.""",
	POSE_LOVE
	],
	[
	"""If  that  alone  didn't  completely  
	discourage  you,  then  be  my  guest.""",
	POSE_DEFAULT
	],
	[
	"""I'll  set  a  timer  for  you cause  I  don't  have
	much  time  to  waste.""",
	POSE_DEFAULT
	],
	[
	"""Aaaaaand  START!""",
	POSE_DEFAULT
	],
]

const CHAOS_TEXT: Array = [
	[
	"""I  can't  believe  it...
	I  think  I  might  have  fallen  for  you.""",
	POSE_LOVE
	],
	[
	"""Do  you  wanna,  maybe  go  on  a  date
	for  starters?""",
	POSE_CHAOS
	],
	[
	"""Sweet!  What  are  we  waiting  for,
	let's  just  go  now!""",
	POSE_CHAOS
	],
]

const ORDER_TEXT: Array = [
	[
	"""Welp,  your  time  is  up,  buddy.
	""",
	POSE_ORDER
	],
	[
	"""Now  could  you  please  scram,  shorty!
	My  time  is  precious  and  
	you've  taken  up  enough  of  it.  
	""",
	POSE_ORDER
	],
	[
	"""Bye!
	Hope  the  door  hits  you  on  your  way  out! 
	""",
	POSE_ORDER
	]
]

const GAME_REPLY: Dictionary = {
	Manager.SPACESHIP_GAME: {
		"chaos": [
			"""Wow!  I've  never  seen  anyone  else  crash  
			just before  reaching  the  finish  line...
			That's amazing!""",
			"""You  crashed,  huh.  On  purpose?
			Nice!"""
		],
		"order": [
			"""Good  job,  you  reached  the  finish  line,
			so  original.""",
			"""Looks  like  someone  has  to  play   
			by  the  rules  to  have  fun.  Boring!"""
		]
	},
	Manager.PRIZE_WHEEL_GAME: {
		"chaos": [
			"""You  like  skulls!?
			I  like  skulls!""",
			"""Don't  think  about  it.  I  would've
			also  gone  for  that  section  of  the  wheel."""
		],
		"order": [
			"""Am  I  supposed  to  be  impressed  
			by  that  or  something?""",
			"""*YAWN*
			Oh,  did  you  do  something?  
			Sorry,  I  wasn't  looking."""
		]
	},
	Manager.GOLF_GAME: {
		"chaos": [
			"""I  hate  golf,  too!""",
			"""Wow!  You  deliberately  missed  the  hole  on
			the  easy  map.  Now  that's  impressive!'"""
		],
		"order": [
			"""*YAWN*
			Golf...""",
			"""Did  you  actually  think  you  were  gonna
			impress  me  by  getting  such  an  easy  hole?
			""",
			"""Golf?
			Are  you  like  50  years  old  or  something?
			"""
		]
	},
	Manager.ALPHABET_GAME: {
		"chaos": [
			"""You  aren't  good  in  school  either,  huh?
			Same  as  me!""",
			"""Don't  worry  I  don't  know  what
			the  answer  is  either..."""
		],
		"order": [
			"""A  teacher's  pet,  huh?  You  probaly  don't
			wanna  know  what  I  did  to  my  class'
			teacher's  pet.""",
			"""NERD!
			"""
		]
	},
	Manager.TETRIS_GAME: {
		"chaos": [
			"""You  gave  up  the  high-score!?
			Seriously?  That  makes  you  different
	 		from  the  other  dudes  I  know.
			""",
			"""I,  too,  get  tempted  to  misplace  
			the  piece  from  time  to  time.
			"""
		],
		"order": [
			"""Ew,  you're  sweating  after  that!?
			Gross!""",
			"""No  one  plays  this  game  seriosly
			anymore,  dude.
			"""
		]
	},
	Manager.FROG_GAME: {
		"chaos": [
			"""Frogs  are  pretty  gross,  aren't  they!
			""",
			"""Reminds  me  of  the  time  I  dissected  
			frogs  in  school.  In  a  positive  way.
			"""
		],
		"order": [
			"""If  it  were  me,  I  would've  gone
			straight  for  one  of  the  cars.
			Well,  you  can  always  try  next  time.
			""",
			"""I  hope  you're  not  planning  on
			keeping  that  frog  you  saved  as  a
			pet.
			"""
		]
	}
}

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func get_random_reply(game: String, type: String) -> Array:
	if type == "time":
		var rand_index: int = rng.randi_range(0, TIMEOUT_REPLIES.size() - 1)
		var reply: String = TIMEOUT_REPLIES[rand_index]
		return [reply, POSE_ORDER]
		
	if (GAME_REPLY.has(game) and 
		GAME_REPLY[game].has(type) and
		GAME_REPLY[game][type].size() > 0):
		var end_index: int = GAME_REPLY[game][type].size() - 1
		var rand_index: int = rng.randi_range(0, end_index)
		var reply: String = GAME_REPLY[game][type][rand_index]
		var pose: String = POSE_CHAOS if type == "chaos" else POSE_ORDER
		return [reply, pose]
	return DEFAULT_REPLY
