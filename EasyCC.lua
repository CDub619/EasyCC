local addonName, L = ...
local CreateFrame = CreateFrame
local SetTexture = SetTexture
local SetNormalTexture = SetNormalTexture
local SetSwipeTexture = SetSwipeTexture
local SetCooldown = SetCooldown
local SetAlpha, SetPoint, SetParent, SetFrameLevel, SetDrawSwipe, SetSwipeColor, SetScale, SetHeight, SetWidth, SetDesaturated, SetVertexColor = SetAlpha, SetPoint, SetParent, SetFrameLevel, SetDrawSwipe, SetSwipeColor,  SetScale, SetHeight, SetWidth, SetDesaturated, SetVertexColor
local ClearAllPoints = ClearAllPoints
local GetParent = GetParent
local GetFrameLevel = GetFrameLevel
local GetDrawSwipe = GetDrawSwipe
local GetDrawLayer = GetDrawLayer
local GetAlpha = GetAlpha
local tblinsert = table.insert
local strfind = string.find
local strmatch = string.match
local strformat = string.format
local strlen = string.len
local tblinsert = table.insert
local tblremove= table.remove
local mathfloor = math.floor
local mathabs = math.abs
local bit_band = bit.band
local tblsort = table.sort
local Ctimer = C_Timer.After
local substring = string.sub
local su = string.sub
local CLocData = C_LossOfControl.GetActiveLossOfControlData
local f, x, y
local _G = _G
local EasyCCDB
local hieght = 48
local width = 48
local fadeTime = 2-- Fade Timer

local spellsTable = {
{"Hunter", --TAB
  {24394  , "CC"},				-- Intimidation (talent)
  {19410  , "CC"},				-- Improved Concussive Shot (talent)
  {28445  , "CC"},				-- Improved Concussive Shot (talent)
  {1513   , "CC"},				-- Scare Beast (rank 1)
  {14326  , "CC"},				-- Scare Beast (rank 2)
  {14327  , "CC"},				-- Scare Beast (rank 3)
  {3355   , "CC"},				-- Freezing Trap (rank 1)
  {14308  , "CC"},				-- Freezing Trap (rank 2)
  {14309  , "CC"},				-- Freezing Trap (rank 3)
  {19386  , "CC"},				-- Wyvern Sting (talent) (rank 1)
  {24132  , "CC"},				-- Wyvern Sting (talent) (rank 2)
  {24133  , "CC"},				-- Wyvern Sting (talent) (rank 3)
  {27068  , "CC"},				-- Wyvern Sting (talent) (rank 4)
  {19503  , "CC"},				-- Scatter Shot (talent)

  {34490  , "Silence"},		-- Silencing Shot

  {19306  , "Root"},				-- Counterattack (talent) (rank 1)
  {20909  , "Root"},				-- Counterattack (talent) (rank 2)
  {20910  , "Root"},				-- Counterattack (talent) (rank 3)
  {27067  , "Root"},				-- Counterattack (talent) (rank 4)
  {19229  , "Root"},				-- Improved Wing Clip (talent)
  {19185  , "Root"},				-- Entrapment (talent)

  {4167   , "Root"},				-- Web
  {4168   , "Root"},				-- Web II
  {4169   , "Root"},				-- Web III
  {25999  , "Root"},				-- Boar Charge
},
{"Shaman",
  {39796  , "CC"},				-- Stoneclaw Stun (Stoneclaw Totem)

  {25454  , "Interrupt"},		-- Earth Shock (rank 8) (Shaman)
  {10414  , "Interrupt"},		-- Earth Shock (rank 7) (Shaman)
  {10413  , "Interrupt"},		-- Earth Shock (rank 6) (Shaman)
  {10412  , "Interrupt"},		-- Earth Shock (rank 5) (Shaman)
  {8046   , "Interrupt"},		-- Earth Shock (rank 4) (Shaman)
  {8045   , "Interrupt"},		-- Earth Shock (rank 3) (Shaman)
  {8044   , "Interrupt"},		-- Earth Shock (rank 2) (Shaman)
  {8042   , "Interrupt"},		-- Earth Shock (rank 1) (Shaman)
},
{"Druid",
  {9005   , "CC"},				-- Pounce (rank 1)
  {9823   , "CC"},				-- Pounce (rank 2)
  {9827   , "CC"},				-- Pounce (rank 3)
  {27006  , "CC"},				-- Pounce (rank 4)
  {5211   , "CC"},				-- Bash (rank 1)
  {6798   , "CC"},				-- Bash (rank 2)
  {8983   , "CC"},				-- Bash (rank 3)
  {22570  , "CC"},				-- Maim (rank 1)
  {2637   , "CC"},				-- Hibernate (rank 1)
  {18657  , "CC"},				-- Hibernate (rank 2)
  {18658  , "CC"},				-- Hibernate (rank 3)
  {33786  , "CC"},				-- Cyclone
  {16922  , "CC"},				-- Starfire Stun (Improved Starfire talent)

  {19675  , "Interrupt"},		-- Feral Charge (Druid)
  {22570  , "Interrupt"},		-- Maim (Gladiator's Dragonhide Gloves) (rank 1) (Druid)

  {339    , "Root"},				-- Entangling Roots (rank 1)
  {1062   , "Root"},				-- Entangling Roots (rank 2)
  {5195   , "Root"},				-- Entangling Roots (rank 3)
  {5196   , "Root"},				-- Entangling Roots (rank 4)
  {9852   , "Root"},				-- Entangling Roots (rank 5)
  {9853   , "Root"},				-- Entangling Roots (rank 6)
  {26989  , "Root"},				-- Entangling Roots (rank 7)
  {19975  , "Root"},				-- Entangling Roots (rank 1) (Nature's Grasp talent)
  {19974  , "Root"},				-- Entangling Roots (rank 2) (Nature's Grasp talent)
  {19973  , "Root"},				-- Entangling Roots (rank 3) (Nature's Grasp talent)
  {19972  , "Root"},				-- Entangling Roots (rank 4) (Nature's Grasp talent)
  {19971  , "Root"},				-- Entangling Roots (rank 5) (Nature's Grasp talent)
  {19970  , "Root"},				-- Entangling Roots (rank 6) (Nature's Grasp talent)
  {27010  , "Root"},				-- Entangling Roots (rank 6) (Nature's Grasp talent)
  {19675  , "Root"},				-- Feral Charge Effect (Feral Charge talent)
  {45334  , "Root"},				-- Feral Charge Effect (Feral Charge talent)
},
{"Mage",
  {118    , "CC"},				-- Polymorph (rank 1)
  {12824  , "CC"},				-- Polymorph (rank 2)
  {12825  , "CC"},				-- Polymorph (rank 3)
  {12826  , "CC"},				-- Polymorph (rank 4)
  {28271  , "CC"},				-- Polymorph: Turtle
  {28272  , "CC"},				-- Polymorph: Pig
  {12355  , "CC"},				-- Impact (talent)
  {31661  , "CC"},				-- Dragon's Breath (rank 1) (talent)
  {33041  , "CC"},				-- Dragon's Breath (rank 2) (talent)
  {33042  , "CC"},				-- Dragon's Breath (rank 3) (talent)
  {33043  , "CC"},				-- Dragon's Breath (rank 4) (talent)

  {2139   , "Interrupt"},		-- Counterspell (Mage)

  {18469  , "Silence"},		-- Counterspell - Silenced (Improved Counterspell talent)

  {122    , "Root"},				-- Frost Nova (rank 1)
  {865    , "Root"},				-- Frost Nova (rank 2)
  {6131   , "Root"},				-- Frost Nova (rank 3)
  {10230  , "Root"},				-- Frost Nova (rank 4)
  {27088  , "Root"},				-- Frost Nova (rank 5)
  {12494  , "Root"},				-- Frostbite (talent)
  {33395  , "Root"},				-- Freeze

},
{"Palladin",
  {853    , "CC"},				-- Hammer of Justice (rank 1)
  {5588   , "CC"},				-- Hammer of Justice (rank 2)
  {5589   , "CC"},				-- Hammer of Justice (rank 3)
  {10308  , "CC"},				-- Hammer of Justice (rank 4)
  {20170  , "CC"},				-- Stun (Seal of Justice)
  {2878   , "CC"},				-- Turn Undead (rank 1)
  {5627   , "CC"},				-- Turn Undead (rank 2)
  {10326  , "CC"},				-- Turn Evil (rank 1)
  {20066  , "CC"},				-- Repentance (talent)

  {18498  , "Silence"},		-- Shield Bash - Silenced (Improved Shield Bash talent)
},
{"Priest",
  {605    , "CC"},				-- Mind Control (rank 1)
  {10911  , "CC"},				-- Mind Control (rank 2)
  {10912  , "CC"},				-- Mind Control (rank 3)
  {8122   , "CC"},				-- Psychic Scream (rank 1)
  {8124   , "CC"},				-- Psychic Scream (rank 2)
  {10888  , "CC"},				-- Psychic Scream (rank 3)
  {10890  , "CC"},				-- Psychic Scream (rank 4)
  {9484   , "CC"},				-- Shackle Undead (rank 1)
  {9485   , "CC"},				-- Shackle Undead (rank 2)
  {10955  , "CC"},				-- Shackle Undead (rank 3)
  {15269  , "CC"},				-- Blackout (talent)

  {15487  , "Silence"},		-- Silence (talent)

  {44041  , "Root"},				-- Chastise (rank 1)
  {44043  , "Root"},				-- Chastise (rank 2)
  {44044  , "Root"},				-- Chastise (rank 3)
  {44045  , "Root"},				-- Chastise (rank 4)
  {44046  , "Root"},				-- Chastise (rank 5)
  {44047  , "Root"},				-- Chastise (rank 6)
},
{"Rogue",
  {2094   , "CC"},				-- Blind
  {408    , "CC"},				-- Kidney Shot (rank 1)
  {8643   , "CC"},				-- Kidney Shot (rank 2)
  {1833   , "CC"},				-- Cheap Shot
  {6770   , "CC"},				-- Sap (rank 1)
  {2070   , "CC"},				-- Sap (rank 2)
  {11297  , "CC"},				-- Sap (rank 3)
  {1776   , "CC"},				-- Gouge (rank 1)
  {1777   , "CC"},				-- Gouge (rank 2)
  {8629   , "CC"},				-- Gouge (rank 3)
  {11285  , "CC"},				-- Gouge (rank 4)
  {11286  , "CC"},				-- Gouge (rank 5)
  {38764  , "CC"},				-- Gouge (rank 6)
  {5530   , "CC"},				-- Mace Stun (talent)

  {1330   , "Silence"},		-- Garrote - Silence

  {26679, "Interrupt"},		-- Deadly Throw (Gladiator's Leather Gloves) (rank 1) (Rogue)
  {38768, "Interrupt"},		-- Kick (rank 5) (Rogue)
  {1769, "Interrupt"},		-- Kick (rank 4) (Rogue)
  {1768, "Interrupt"},		-- Kick (rank 3) (Rogue)
  {1767, "Interrupt"},		-- Kick (rank 2) (Rogue)
  {1766, "Interrupt"},		-- Kick (rank 1) (Rogue)

  {14251  , "Disarm"},			-- Riposte (talent)
},
{"Warlock",
  {710    , "CC"},				-- Banish (rank 1)
  {18647  , "CC"},				-- Banish (rank 2)
  {5782   , "CC"},				-- Fear (rank 1)
  {6213   , "CC"},				-- Fear (rank 2)
  {6215   , "CC"},				-- Fear (rank 3)
  {5484   , "CC"},				-- Howl of Terror (rank 1)
  {17928  , "CC"},				-- Howl of Terror (rank 2)
  {6789   , "CC"},				-- Death Coil (rank 1)
  {17925  , "CC"},				-- Death Coil (rank 2)
  {17926  , "CC"},				-- Death Coil (rank 3)
  {27223  , "CC"},				-- Death Coil (rank 4)
  {22703  , "CC"},				-- Inferno Effect
  {18093  , "CC"},				-- Pyroclasm (talent)
  {30283  , "CC"},				-- Shadowfury (rank 1) (talent)
  {30413  , "CC"},				-- Shadowfury (rank 2) (talent)
  {30414  , "CC"},				-- Shadowfury (rank 3) (talent)

  {32752  , "CC"},			-- Summoning Disorientation
  {6358   , "CC"},			-- Seduction (Succubus)
  {19482  , "CC"},			-- War Stomp (Doomguard)
  {30153  , "CC"},			-- Intercept Stun (rank 1) (Felguard)
  {30195  , "CC"},			-- Intercept Stun (rank 2) (Felguard)
  {30197  , "CC"},			-- Intercept Stun (rank 3) (Felguard)

  {43523  , "Silence"},		-- Unstable Affliction
  {24259  , "Silence"},		-- Spell Lock (Felhunter)

  {19647, "Interrupt"},		-- Spell Lock (felhunter) (rank 2) (Warlock)
  {19244, "Interrupt"},		-- Spell Lock (felhunter) (rank 1) (Warlock)
},
{"Warrior",
  {7922   , "CC"},				-- Charge (rank 1/2/3)
  {20253  , "CC"},				-- Intercept (rank 1)
  {20614  , "CC"},				-- Intercept (rank 2)
  {20615  , "CC"},				-- Intercept (rank 3)
  {25273  , "CC"},				-- Intercept (rank 4)
  {25274  , "CC"},				-- Intercept (rank 5)
  {5246   , "CC"},				-- Intimidating Shout
  {20511  , "CC"},				-- Intimidating Shout
  {12798  , "CC"},				-- Revenge Stun (Improved Revenge talent)
  {12809  , "CC"},				-- Concussion Blow (talent)

  {29704 , "Interrupt"},		-- Shield Bash (rank 4) (Warrior)
  {1672  , "Interrupt"},		-- Shield Bash (rank 3) (Warrior)
  {1671  , "Interrupt"},		-- Shield Bash (rank 2) (Warrior)
  {72    , "Interrupt"},	 	-- Shield Bash (rank 1) (Warrior)
  {6554  , "Interrupt"},		-- Pummel (rank 2) (Warrior)
  {6552  , "Interrupt"},		-- Pummel (rank 1) (Warrior)
  {19647 , "Interrupt"},		-- Spell Lock (felhunter) (rank 2) (Warlock)
  {19244 , "Interrupt"},		-- Spell Lock (felhunter) (rank 1) (Warlock)

  {23694  , "Root"},				-- Improved Hamstring (talent)

  {676    , "Disarm"},			-- Improved Hamstring (talent)
},
{"Racials",
  {20549  , "CC"},				-- War Stomp (tauren racial)

  {25046  , "Silence"},		-- Arcane Torrent (blood elf racial)
  {28730  , "Silence"},		-- Arcane Torrent (blood elf racial)
},

	----------------
	-- Other
	----------------
{"Other", --TAB
  {56     , "CC"},				-- Stun (some weapons proc)
  {835    , "CC"},				-- Tidal Charm (trinket)
  {4159   , "CC"},				-- Tight Pinch
  {8312   , "Root"},				-- Trap (Hunting Net trinket)
  {17308  , "CC"},				-- Stun (Hurd Smasher fist weapon)
  {23454  , "CC"},				-- Stun (The Unstoppable Force weapon)
  {9179   , "CC"},				-- Stun (Tigule and Foror's Strawberry Ice Cream item)
  {13327  , "CC"},				-- Reckless Charge (Goblin Rocket Helmet)
  {13181  , "CC"},				-- Gnomish Mind Control Cap (Gnomish Mind Control Cap helmet)
  {26740  , "CC"},				-- Gnomish Mind Control Cap (Gnomish Mind Control Cap helmet)
  {8345   , "CC"},				-- Control Machine (Gnomish Universal Remote trinket)
  {13235  , "CC"},				-- Forcefield Collapse (Gnomish Harm Prevention belt)
  {13158  , "CC"},				-- Rocket Boots Malfunction (Engineering Rocket Boots)
  {8893   , "CC"},				-- Rocket Boots Malfunction (Engineering Rocket Boots)
  {13466  , "CC"},				-- Goblin Dragon Gun (engineering trinket malfunction)
  {8224   , "CC"},				-- Cowardice (Savory Deviate Delight effect)
  {8225   , "CC"},				-- Run Away! (Savory Deviate Delight effect)
  {23444  , "CC"},				-- Transporter Malfunction
  {23447  , "CC"},				-- Transporter Malfunction
  {23456  , "CC"},				-- Transporter Malfunction
  {23457  , "CC"},				-- Transporter Malfunction
  {8510   , "CC"},				-- Large Seaforium Backfire
  {8511   , "CC"},				-- Small Seaforium Backfire
  {13237  , "CC"},				-- Goblin Mortar
  {13238  , "CC"},				-- Goblin Mortar
  {5134   , "CC"},				-- Flash Bomb
  {4064   , "CC"},				-- Rough Copper Bomb
  {4065   , "CC"},				-- Large Copper Bomb
  {4066   , "CC"},				-- Small Bronze Bomb
  {4067   , "CC"},				-- Big Bronze Bomb
  {4068   , "CC"},				-- Iron Grenade
  {4069   , "CC"},				-- Big Iron Bomb
  {12543  , "CC"},				-- Hi-Explosive Bomb
  {12562  , "CC"},				-- The Big One
  {12421  , "CC"},				-- Mithril Frag Bomb
  {19784  , "CC"},				-- Dark Iron Bomb
  {19769  , "CC"},				-- Thorium Grenade
  {13808  , "CC"},				-- M73 Frag Grenade
  {21188  , "CC"},				-- Stun Bomb Attack
  {9159   , "CC"},				-- Sleep (Green Whelp Armor chest)
  {19821  , "Silence"},			-- Arcane Bomb
  {18278  , "Silence"},			-- Silence (Silent Fang sword)
  {8346   , "Root"},				-- Mobility Malfunction (trinket)
  {13099  , "Root"},				-- Net-o-Matic (trinket)
  {13119  , "Root"},				-- Net-o-Matic (trinket)
  {13138  , "Root"},				-- Net-o-Matic (trinket)
  {16566  , "Root"},				-- Net-o-Matic (trinket)
  {15752  , "Disarm"},			-- Linken's Boomerang (trinket)
  {15753  , "CC"},				-- Linken's Boomerang (trinket)
  {15535  , "CC"},				-- Enveloping Winds (Six Demon Bag trinket)
  {23103  , "CC"},				-- Enveloping Winds (Six Demon Bag trinket)
  {15534  , "CC"},				-- Polymorph (Six Demon Bag trinket)
  {16470  , "CC"},				-- Gift of Stone
  {700    , "CC"},				-- Sleep (Slumber Sand item)
  {1090   , "CC"},				-- Sleep
  {12098  , "CC"},				-- Sleep
  {20663  , "CC"},				-- Sleep
  {20669  , "CC"},				-- Sleep
  {20989  , "CC"},				-- Sleep
  {24004  , "CC"},				-- Sleep
  {8064   , "CC"},				-- Sleepy
  {17446  , "CC"},				-- The Black Sleep
  {29124  , "CC"},				-- Polymorph
  {14621  , "CC"},				-- Polymorph
  {27760  , "CC"},				-- Polymorph
  {28406  , "CC"},				-- Polymorph Backfire
  {851    , "CC"},				-- Polymorph: Sheep
  {16707  , "CC"},				-- Hex
  {16708  , "CC"},				-- Hex
  {16709  , "CC"},				-- Hex
  {18503  , "CC"},				-- Hex
  {20683  , "CC"},				-- Highlord's Justice
  {17286  , "CC"},				-- Crusader's Hammer
  {12096  , "CC"},				-- Fear
  {27641  , "CC"},				-- Fear
  {29168  , "CC"},				-- Fear
  {30002  , "CC"},				-- Fear
  {15398  , "CC"},				-- Psychic Scream
  {26042  , "CC"},				-- Psychic Scream
  {27610  , "CC"},				-- Psychic Scream
  {10794  , "CC"},				-- Spirit Shock
  {9915   , "Root"},				-- Frost Nova
  {14907  , "Root"},				-- Frost Nova
  {22645  , "Root"},				-- Frost Nova
  --------------------------------------------------------
  --[[{2676, "Interrupt"},		-- Pulverize
  {5133, "Interrupt"},		-- Interrupt (PT)
  {8714, "Interrupt"},		-- Overwhelming Musk
  {10887, "Interrupt"},		-- Crowd Pummel
  {11972, "Interrupt"},		-- Shield Bash
  {11978, "Interrupt"},		-- Kick
  {12555, "Interrupt"},		-- Pummel
  {13281, "Interrupt"},		-- Earth Shock
  {13728, "Interrupt"},		-- Earth Shock
  {15122, "Interrupt"},		-- Counterspell
  {15501, "Interrupt"},		-- Earth Shock
  {15610, "Interrupt"},		-- Kick
  {15614, "Interrupt"},		-- Kick
  {15615, "Interrupt"},		-- Pummel
  {19129, "Interrupt"},		-- Massive Tremor
  {19639, "Interrupt"},		-- Pummel
  {19715, "Interrupt"},		-- Counterspell
  {20537, "Interrupt"},		-- Counterspell
  {20788, "Interrupt"},	-- Counterspell
  {21832, "Interrupt"},		-- Boulder
  {22885, "Interrupt"},		-- Earth Shock
  {23114, "Interrupt"},		-- Earth Shock
  {24685, "Interrupt"},		-- Earth Shock
  {25025, "Interrupt"},		-- Earth Shock
  {25788, "Interrupt"},		-- Head Butt
  {26194, "Interrupt"},		-- Earth Shock
  {27613, "Interrupt"},		-- Kick
  {27620, "Interrupt"},		-- Snap Kick
  {27814, "Interrupt"},		-- Kick
  {27880, "Interrupt"},		-- Stun
  {29298, "Interrupt"},		-- Dark Shriek
  {29560, "Interrupt"},		-- Kick
  {29586, "Interrupt"},		-- Kick
  {29961, "Interrupt"},		-- Counterspell
  {30849, "Interrupt"},		-- Spell Lock
  {31596, "Interrupt"},		-- Counterspell
  {31999, "Interrupt"},		-- Counterspell
  {32322, "Interrupt"},		-- Dark Shriek
  {32691, "Interrupt"},		-- Spell Shock
  {32747, "Interrupt"},		-- Deadly Interrupt Effect
  {32846, "Interrupt"},		-- Counter Kick
  {32938, "Interrupt"},		-- Cry of the Dead
  {33871, "Interrupt"},		-- Shield Bash
  {34797, "Interrupt"},		-- Nature Shock
  {34802, "Interrupt"},		-- Kick
  {35039, "Interrupt"},		-- Countercharge
  {35178, "Interrupt"},		-- Shield Bash
  {35856, "Interrupt"},		-- Stun
  {35920, "Interrupt"},		-- Electroshock
  {36033, "Interrupt"},		-- Kick
  {36138, "Interrupt"},		-- Hammer Stun
  {36254, "Interrupt"},		-- Judgement of the Flame
  {36841, "Interrupt"},		-- Sonic Boom
  {36988, "Interrupt"},		-- Shield Bash
  {37359, "Interrupt"},		-- Rush
  {37470, "Interrupt"},		-- Counterspell
  {38052, "Interrupt"},		-- Sonic Boom
  {38233, "Interrupt"},		-- Shield Bash
  {38313, "Interrupt"},		-- Pummel
  {38625, "Interrupt"},		-- Kick
  {38750, "Interrupt"},		-- War Stomp
  {38897, "Interrupt"},		-- Sonic Boom
  {39076, "Interrupt"},		-- Spell Shock
  {39120, "Interrupt"},		-- Nature Shock
  {40305, "Interrupt"},		-- Power Burn
  {40547, "Interrupt"},		-- Interrupt Unholy Growth
  {40751, "Interrupt"},		-- Disrupt Magic
  {40864, "Interrupt"},		-- Throbbing Stun
  {41180, "Interrupt"},		-- Shield Bash
  {41197, "Interrupt"},		-- Shield Bash
  {41395, "Interrupt"},		-- Kick
  {43305, "Interrupt"},		-- Earth Shock
  {43518, "Interrupt"},		-- Kick
  {44418, "Interrupt"},		-- Massive Tremor
  {44644, "Interrupt"},		-- Arcane Nova
  {45214, "Interrupt"},		-- Ron's Test Spell #4
  {45356, "Interrupt"},		-- Kick
  {46036, "Interrupt"},		-- Arcane Nova
  {46182, "Interrupt"},		-- Snap Kick
  {47071, "Interrupt"},		-- Earth Shock
  {47081, "Interrupt"},		-- Pummel
  {11978, "Interrupt"},		-- Pummel (Iron Knuckles Item)
  {13491, "Interrupt"},		-- Pummel (Iron Knuckles Item)
  {29443, "Interrupt"},	]]	-- Counterspell (Clutch of Foresight)
  {20654  , "Root"},				-- Entangling Roots
  {22800  , "Root"},				-- Entangling Roots
  {20699  , "Root"},				-- Entangling Roots
  {18546  , "Root"},				-- Overdrive
  {22935  , "Root"},				-- Planted
  {12520  , "Root"},				-- Teleport from Azshara Tower
  {12521  , "Root"},				-- Teleport from Azshara Tower
  {12509  , "Root"},				-- Teleport from Azshara Tower
  {12023  , "Root"},				-- Web
  {13608  , "Root"},				-- Hooked Net
  {10017  , "Root"},				-- Frost Hold
  {23279  , "Root"},				-- Crippling Clip
  {3542   , "Root"},				-- Naraxis Web
  {5567   , "Root"},				-- Miring Mud
  {5424   , "Root"},				-- Claw Grasp
  {4246   , "Root"},				-- Clenched Pinchers
  {5219   , "Root"},				-- Draw of Thistlenettle
  {9576   , "Root"},				-- Lock Down
  {7950   , "Root"},				-- Pause
  {7761   , "Root"},				-- Shared Bonds
  {6714   , "Root"},				-- Test of Faith
  {6716   , "Root"},				-- Test of Faith
  {25     , "CC"},				-- Stun
  {101    , "CC"},				-- Trip
  {2880   , "CC"},				-- Stun
  {5648   , "CC"},				-- Stunning Blast
  {5649   , "CC"},				-- Stunning Blast
  {5726   , "CC"},				-- Stunning Blow
  {5727   , "CC"},				-- Stunning Blow
  {5703   , "CC"},				-- Stunning Strike
  {5918   , "CC"},				-- Shadowstalker Stab
  {3446   , "CC"},				-- Ravage
  {3109   , "CC"},				-- Presence of Death
  {3143   , "CC"},				-- Glacial Roar
  {5403   , "CC"},				-- Crash of Waves
  {3260   , "CC"},				-- Violent Shield Effect
  {3263   , "CC"},				-- Touch of Ravenclaw
  {3271   , "CC"},				-- Fatigued
  {5106   , "CC"},				-- Crystal Flash
  {6266   , "CC"},				-- Kodo Stomp
  {6730   , "CC"},				-- Head Butt
  {6982   , "CC"},				-- Gust of Wind
  {6749   , "CC"},				-- Wide Swipe
  {6754   , "CC"},				-- Slap!
  {6927   , "CC"},				-- Shadowstalker Slash
  {7961   , "CC"},				-- Azrethoc's Stomp
  {8151   , "CC"},				-- Surprise Attack
  {3635   , "CC"},				-- Crystal Gaze
  {9992   , "CC"},				-- Dizzy
  {6614   , "CC"},				-- Cowardly Flight
  {5543   , "CC"},				-- Fade Out
  {6664   , "CC"},				-- Survival Instinct
  {6669   , "CC"},				-- Survival Instinct
  {5951   , "CC"},				-- Knockdown
  {4538   , "CC"},				-- Extract Essence
  {6580   , "CC"},				-- Pierce Ankle
  {6894   , "CC"},				-- Death Bed
  {7184   , "CC"},				-- Lost Control
  {8901   , "CC"},				-- Gas Bomb
  {8902   , "CC"},				-- Gas Bomb
  {9454   , "CC"},				-- Freeze
  {7082   , "CC"},				-- Barrel Explode
  {6537   , "CC"},				-- Call of the Forest
  {8672   , "CC"},				-- Challenger is Dazed
  {6409   , "CC"},				-- Cheap Shot
  {14902  , "CC"},				-- Cheap Shot
  {8338   , "CC"},				-- Defibrillated!
  {23055  , "CC"},				-- Defibrillated!
  {8646   , "CC"},				-- Snap Kick
  {27620  , "Silence"},			-- Snap Kick
  {27814  , "Silence"},			-- Kick
  {11650  , "CC"},				-- Head Butt
  {21990  , "CC"},				-- Tornado
  {19725  , "CC"},				-- Turn Undead
  {19469  , "CC"},				-- Poison Mind
  {10134  , "CC"},				-- Sand Storm
  {12613  , "CC"},				-- Dark Iron Taskmaster Death
  {13488  , "CC"},				-- Firegut Fear Storm
  {17738  , "CC"},				-- Curse of the Plague Rat
  {20019  , "CC"},				-- Engulfing Flames
  {19136  , "CC"},				-- Stormbolt
  {20685  , "CC"},				-- Storm Bolt
  {16803  , "CC"},				-- Flash Freeze
  {14100  , "CC"},				-- Terrifying Roar
  {17276  , "CC"},				-- Scald
  {13360  , "CC"},				-- Knockdown
  {11430  , "CC"},				-- Slam
  {28335  , "CC"},				-- Whirlwind
  {16451  , "CC"},				-- Judge's Gavel
  {25260  , "CC"},				-- Wings of Despair
  {23275  , "CC"},				-- Dreadful Fright
  {24919  , "CC"},				-- Nauseous
  {21167  , "CC"},				-- Snowball
  {26641  , "CC"},				-- Aura of Fear
  {28315  , "CC"},				-- Aura of Fear
  {21898  , "CC"},				-- Warlock Terror
  {20672  , "CC"},				-- Fade
  {31365  , "CC"},				-- Self Fear
  {25815  , "CC"},				-- Frightening Shriek
  {12134  , "CC"},				-- Atal'ai Corpse Eat
  {22427  , "CC"},				-- Concussion Blow
  {16096  , "CC"},				-- Cowering Roar
  {27177  , "CC"},				-- Defile
  {18395  , "CC"},				-- Dismounting Shot
  {28323  , "CC"},				-- Flameshocker's Revenge
  {28314  , "CC"},				-- Flameshocker's Touch
  {28127  , "CC"},				-- Flash
  {17011  , "CC"},				-- Freezing Claw
  {14102  , "CC"},				-- Head Smash
  {15652  , "CC"},				-- Head Smash
  {23269  , "CC"},				-- Holy Blast
  {22357  , "CC"},				-- Icebolt
  {10451  , "CC"},				-- Implosion
  {15252  , "CC"},				-- Keg Trap
  {27615  , "CC"},				-- Kidney Shot
  {24213  , "CC"},				-- Ravage
  {21936  , "CC"},				-- Reindeer
  {11444  , "CC"},				-- Shackle Undead
  {14871  , "CC"},				-- Shadow Bolt Misfire
  {25056  , "CC"},				-- Stomp
  {24647  , "CC"},				-- Stun
  {17691  , "CC"},				-- Time Out
  {11481  , "CC"},				-- TWEEP
  {20310  , "CC"},				-- Stun
  {23775  , "CC"},				-- Stun Forever
  {23676  , "CC"},				-- Minigun (chance to hit reduced by 50%)
  {11983  , "CC"},				-- Steam Jet (chance to hit reduced by 30%)
  {9612   , "CC"},				-- Ink Spray (chance to hit reduced by 50%)
  {4150   , "CC"},				-- Eye Peck (chance to hit reduced by 47%)
  {6530   , "CC"},				-- Sling Dirt (chance to hit reduced by 40%)
  {5101   , "CC"},				-- Dazed
  {4320   , "Silence"},			-- Trelane's Freezing Touch
  {4243   , "Silence"},			-- Pester Effect
  {6942   , "Silence"},			-- Overwhelming Stench
  {9552   , "Silence"},			-- Searing Flames
  {10576  , "Silence"},			-- Piercing Howl
  {12943  , "Silence"},			-- Fell Curse Effect
  {23417  , "Silence"},			-- Smother
  {10851  , "Disarm"},			-- Grab Weapon
  {27581  , "Disarm"},			-- Disarm
  {25057  , "Disarm"},			-- Dropped Weapon
  {25655  , "Disarm"},			-- Dropped Weapon
  {14180  , "Disarm"},			-- Sticky Tar
  {5376   , "Disarm"},			-- Hand Snap
  {6576   , "CC"},				-- Intimidating Growl
  {7093   , "CC"},				-- Intimidation
  {8715   , "CC"},				-- Terrifying Howl
  {8817   , "CC"},				-- Smoke Bomb
  {9458   , "CC"},				-- Smoke Cloud
  {3442   , "CC"},				-- Enslave
  {25772  , "CC"},				-- Mental Domination
  {16053  , "CC"},				-- Dominion of Soul (Orb of Draconic Energy)
  {15859  , "CC"},				-- Dominate Mind
  {20740  , "CC"},				-- Dominate Mind
  {11446  , "CC"},				-- Mind Control
  {20668  , "CC"},				-- Sleepwalk
  {21330  , "CC"},				-- Corrupted Fear (Deathmist Raiment set)
  {27868  , "Root"},				-- Freeze (Magister's and Sorcerer's Regalia sets)
  {17333  , "Root"},				-- Spider's Kiss (Spider's Kiss set)
  {26108  , "CC"},				-- Glimpse of Madness (Dark Edge of Insanity axe)
  {24753  , "CC"},				-- Trick
  {21847  , "CC"},				-- Snowman
  {21848  , "CC"},				-- Snowman
  {21980  , "CC"},				-- Snowman
  {27880  , "CC"},				-- Stun
  {23010  , "CC"},				-- Tendrils of Air
  {24360  , "CC"},				-- Greater Dreamless Sleep Potion
  {15822  , "CC"},				-- Dreamless Sleep Potion
  {15283  , "CC"},				-- Stunning Blow (Dark Iron Pulverizer weapon)
  {21152  , "CC"},				-- Earthshaker (Earthshaker weapon)
  {16600  , "CC"},				-- Might of Shahram (Blackblade of Shahram sword)
  {26198  , "CC"},				-- Whisperings of C'Thun
  {26195  , "CC"},				-- Whisperings of C'Thun
  {26197  , "CC"},				-- Whisperings of C'Thun
  {26258  , "CC"},				-- Whisperings of C'Thun
  {26259  , "CC"},				-- Whisperings of C'Thun
  {13534  , "Disarm"},			-- Disarm (The Shatterer weapon)
  {11879  , "Disarm"},			-- Disarm (Shoni's Disarming Tool weapon)
  {27559  , "Silence"},			-- Silence (Jagged Obsidian Shield)
  {13907  , "CC"},				-- Smite Demon (Enchant Weapon - Demonslaying)
  {18798  , "CC"},				-- Freeze (Freezing Band)
  {17500  , "CC"},				-- Malown's Slam (Malown's Slam weapon)
  --{16927  , "Snare"},				-- Chilled (Frostguard weapon)
  --{20005  , "Snare"},				-- Chilled (Enchant Weapon - Icy Chill)
  {34510  , "CC"},				-- Stun (Stormherald and Deep Thunder weapons)
  {46567  , "CC"},				-- Rocket Launch (Goblin Rocket Launcher trinket)
  {30501  , "Silence"},			-- Poultryized! (Gnomish Poultryizer trinket)
  {30504  , "Silence"},			-- Poultryized! (Gnomish Poultryizer trinket)
  {30506  , "Silence"},			-- Poultryized! (Gnomish Poultryizer trinket)
  {35474  , "CC"},				-- Drums of Panic (Drums of Panic item)
  {351357 , "CC"},				-- Greater Drums of Panic (Greater Drums of Panic item)
  {28504  , "CC"},				-- Major Dreamless Sleep (Major Dreamless Sleep Potion)
  {30216  , "CC"},				-- Fel Iron Bomb
  {30217  , "CC"},				-- Adamantite Grenade
  {30461  , "CC"},				-- The Bigger One
  {31367  , "Root"},				-- Netherweave Net (tailoring item)
  {31368  , "Root"},				-- Heavy Netherweave Net (tailoring item)
  {39965  , "Root"},				-- Frost Grenade
  {36940  , "CC"},				-- Transporter Malfunction
  {51581  , "CC"},				-- Rocket Boots Malfunction
  {12565  , "CC"},				-- Wyatt Test
  {35182  , "CC"},				-- Banish
  {40307  , "CC"},				-- Stasis Field
  {35236  , "CC"},				-- Heat Wave (chance to hit reduced by 35%)
  {29117  , "CC"},				-- Feather Burst (chance to hit reduced by 50%)
  {34088  , "CC"},				-- Feeble Weapons (chance to hit reduced by 75%)
  {32904  , "CC"},				-- Pacifying Dust
  {37748  , "CC"},				-- Teron Gorefiend
  {38177  , "CC"},				-- Blackwhelp Net
  {39810  , "CC"},				-- Sparrowhawk Net
  {41621  , "CC"},				-- Wolpertinger Net
  {43906  , "CC"},				-- Feeling Froggy
  {32913  , "CC"},				-- Dazzling Dust
  {33810  , "CC"},				-- Rock Shell
  {37450  , "CC"},				-- Dimensius Feeding
  {38318  , "CC"},				-- Transformation - Blackwhelp
  {33390  , "Silence"},			-- Arcane Torrent
  {30849  , "Silence"},			-- Spell Lock
  {35892  , "Silence"},			-- Suppression
  {34087  , "Silence"},			-- Chilling Words
  {35334  , "Silence"},			-- Nether Shock
  {38913  , "Silence"},			-- Silence
  {38915  , "CC"},				-- Mental Interference
  {41128  , "CC"},				-- Through the Eyes of Toranaku
  {22901  , "CC"},				-- Body Switch
  {31988  , "CC"},				-- Enslave Humanoid
  {37323  , "CC"},				-- Crystal Control
  {37221  , "CC"},				-- Crystal Control
  {38774  , "CC"},				-- Incite Rage
  {43550  , "CC"},				-- Mind Control
  {33384  , "CC"},				-- Mass Charm
  {36145  , "CC"},				-- Chains of Naberius
  {42185  , "CC"},				-- Brewfest Control Piece
  {44881  , "CC"},				-- Charm Ravager
  {37216  , "CC"},				-- Crystal Control
  {29909  , "CC"},				-- Elven Manacles
  {28516  , "Silence"},			-- Sunwell Torrent (Sunwell Blade & Sunwell Orb items)
  {33913  , "Silence"},			-- Soul Burn
  {37031  , "Silence"},			-- Chaotic Temperament
  {39052  , "Silence"},			-- Sonic Burst
  {41247  , "Silence"},			-- Shared Suffering
  {44957  , "Silence"},			-- Nether Shock
  {31955  , "Disarm"},			-- Disarm
  {34097  , "Disarm"},			-- Riposte
  {34099  , "Disarm"},			-- Riposte
  {36208  , "Disarm"},			-- Steal Weapon
  {36510  , "Disarm"},			-- Enchanted Weapons
  {39489  , "Disarm"},			-- Enchanted Weapons
  {41053  , "Disarm"},			-- Whirling Blade
  {41392  , "Disarm"},			-- Riposte
  {47310  , "Disarm"},			-- Direbrew's Disarm
  {30298  , "CC"},				-- Tree Disguise
  {42695  , "CC"},				-- Holiday - Brewfest - Dark Iron Knock-down Power-up
  {49750  , "CC"},				-- Honey Touched
  {42380  , "CC"},				-- Conflagration
  {42408  , "CC"},				-- Headless Horseman Climax - Head Stun
  {42435  , "CC"},				-- Brewfest - Stun
  {47718  , "CC"},				-- Direbrew Charge
  {47340  , "CC"},				-- Dark Brewmaiden's Stun
  {50093  , "CC"},				-- Chilled
  {29044  , "CC"},				-- Hex
  {30838  , "CC"},				-- Polymorph
  {34654  , "CC"},				-- Blind
  {35840  , "CC"},				-- Conflagration
  {37289  , "CC"},				-- Dragon's Breath
  {39293  , "CC"},				-- Conflagration
  {40400  , "CC"},				-- Hex
  {41397  , "CC"},				-- Confusion
  {42805  , "CC"},				-- Dirty Trick
  {43433  , "CC"},				-- Blind
  {45665  , "CC"},				-- Encapsulate
  {47442  , "CC"},				-- Barreled!
  {51413  , "CC"},				-- Barreled!
  {26661  , "CC"},				-- Fear
  {31358  , "CC"},				-- Fear
  {31404  , "CC"},				-- Shrill Cry
  {32040  , "CC"},				-- Scare Daggerfen
  {32241  , "CC"},				-- Fear
  {32709  , "CC"},				-- Death Coil
  {33829  , "CC"},				-- Fleeing in Terror
  {33924  , "CC"},				-- Fear
  {34259  , "CC"},				-- Fear
  {35198  , "CC"},				-- Terrify
  {35954  , "CC"},				-- Death Coil
  {36629  , "CC"},				-- Terrifying Roar
  {36950  , "CC"},				-- Blinding Light
  {37939  , "CC"},				-- Terrifying Roar
  {38065  , "CC"},				-- Death Coil
  {38154  , "CC"},				-- Fear
  {39048  , "CC"},				-- Howl of Terror
  {39119  , "CC"},				-- Fear
  {39176  , "CC"},				-- Fear
  {39210  , "CC"},				-- Fear
  {39661  , "CC"},				-- Death Coil
  {39914  , "CC"},				-- Scare Soulgrinder Ghost
  {40221  , "CC"},				-- Terrifying Roar
  {40259  , "CC"},				-- Boar Charge
  {40636  , "CC"},				-- Bellowing Roar
  {40669  , "CC"},				-- Egbert
  {41070  , "CC"},				-- Death Coil
  {41436  , "CC"},				-- Panic
  {42690  , "CC"},				-- Terrifying Roar
  {42869  , "CC"},				-- Conflagration
  {43432  , "CC"},				-- Psychic Scream
  {44142  , "CC"},				-- Death Coil
  {46283  , "CC"},				-- Death Coil
  {50368  , "CC"},				-- Ethereal Liqueur Mutation
  {27983  , "CC"},				-- Lightning Strike
  {29516  , "CC"},				-- Dance Trance
  {29903  , "CC"},				-- Dive
  {30657  , "CC"},				-- Quake
  {30688  , "CC"},				-- Shield Slam
  {30790  , "CC"},				-- Arcane Domination
  {30832  , "CC"},				-- Kidney Shot
  {30850  , "CC"},				-- Seduction
  {30857  , "CC"},				-- Wield Axes
  {31274  , "CC"},				-- Knockdown
  {31292  , "CC"},				-- Sleep
  {31390  , "CC"},				-- Knockdown
  {31408  , "CC"},				-- War Stomp
  {31539  , "CC"},				-- Self Stun Forever
  {31541  , "CC"},				-- Sleep
  {31548  , "CC"},				-- Sleep
  {31733  , "CC"},				-- Charge
  {31819  , "CC"},				-- Cheap Shot
  {31843  , "CC"},				-- Cheap Shot
  {31864  , "CC"},				-- Shield Charge Stun
  {31964  , "CC"},				-- Thundershock
  {31994  , "CC"},				-- Shoulder Charge
  {32015  , "CC"},				-- Knockdown
  {32021  , "CC"},				-- Rushing Charge
  {32023  , "CC"},				-- Hoof Stomp
  {32104  , "CC"},				-- Backhand
  {32105  , "CC"},				-- Kick
  {32150  , "CC"},				-- Infernal
  {32416  , "CC"},				-- Hammer of Justice
  {32588  , "CC"},				-- Concussion Blow
  {32779  , "CC"},				-- Repentance
  {32905  , "CC"},				-- Glare
  {33128  , "CC"},				-- Stone Gaze
  {33241  , "CC"},				-- Infernal
  {33422  , "CC"},				-- Phase In
  {33463  , "CC"},				-- Icebolt
  {33487  , "CC"},				-- Addle Humanoid
  {33542  , "CC"},				-- Staff Strike
  {33637  , "CC"},				-- Infernal
  {33781  , "CC"},				-- Ravage
  {33792  , "CC"},				-- Exploding Shot
  {33965  , "CC"},				-- Look Around
  {33937  , "CC"},				-- Stun Phase 2 Units
  {34016  , "CC"},				-- Stun Phase 3 Units
  {34023  , "CC"},				-- Stun Phase 4 Units
  {34024  , "CC"},				-- Stun Phase 5 Units
  {34108  , "CC"},				-- Spine Break
  {34243  , "CC"},				-- Cheap Shot
  {34357  , "CC"},				-- Vial of Petrification
  {34620  , "CC"},				-- Slam
  {34815  , "CC"},				-- Teleport Effect
  {34885  , "CC"},				-- Petrify
  {35202  , "CC"},				-- Paralysis
  {35313  , "CC"},				-- Hypnotic Gaze
  {35382  , "CC"},				-- Rushing Charge
  {35424  , "CC"},				-- Soul Shadows
  {35492  , "CC"},				-- Exhaustion
  {35570  , "CC"},				-- Charge
  {35614  , "CC"},				-- Kaylan's Wrath
  {35856  , "CC"},				-- Stun
  {35957  , "CC"},				-- Mana Bomb Explosion
  {36138  , "CC"},				-- Hammer Stun
  {36254  , "CC"},				-- Judgement of the Flame
  {36402  , "CC"},				-- Sleep
  {36449  , "CC"},				-- Debris
  {36474  , "CC"},				-- Flayer Flu
  {36509  , "CC"},				-- Charge
  {36575  , "CC"},				-- T'chali the Head Freeze State
  {36642  , "CC"},				-- Banished from Shattrath City
  {36671  , "CC"},				-- Banished from Shattrath City
  {36732  , "CC"},				-- Scatter Shot
  {36809  , "CC"},				-- Overpowering Sickness
  {36824  , "CC"},				-- Overwhelming Odor
  {36877  , "CC"},				-- Stun Forever
  {37012  , "CC"},				-- Swoop
  {37073  , "CC"},				-- Drink Eye Potion
  {37103  , "CC"},				-- Smash
  {37417  , "CC"},				-- Warp Charge
  {37493  , "CC"},				-- Feign Death
  {37527  , "CC"},				-- Banish
  {37592  , "CC"},				-- Knockdown
  {37768  , "CC"},				-- Metamorphosis
  {37833  , "CC"},				-- Banish
  {37919  , "CC"},				-- Arcano-dismantle
  {38006  , "CC"},				-- World Breaker
  {38009  , "CC"},				-- Banish
  {38169  , "CC"},				-- Subservience
  {38235  , "CC"},				-- Water Tomb
  {38357  , "CC"},				-- Tidal Surge
  {38461  , "CC"},				-- Charge
  {38510  , "CC"},				-- Sablemane's Sleeping Powder
  {38554  , "CC"},				-- Absorb Eye of Grillok
  {38757  , "CC"},				-- Fel Reaver Freeze
  {38863  , "CC"},				-- Gouge
  {39229  , "CC"},				-- Talon of Justice
  {39568  , "CC"},				-- Stun
  {39594  , "CC"},				-- Cyclone
  {39622  , "CC"},				-- Banish
  {39668  , "CC"},				-- Ambush
  {40135  , "CC"},				-- Shackle Undead
  {40262  , "CC"},				-- Super Jump
  {40358  , "CC"},				-- Death Hammer
  {40370  , "CC"},				-- Banish
  {40380  , "CC"},				-- Legion Ring - Shield Defense Beam
  {40511  , "CC"},				-- Demon Transform 1
  {40398  , "CC"},				-- Demon Transform 2
  {40510  , "CC"},				-- Demon Transform 3
  {40409  , "CC"},				-- Maiev Down
  {40447  , "CC"},				-- Akama Soul Channel
  {40490  , "CC"},				-- Resonant Feedback
  {40497  , "CC"},				-- Chaos Charge
  {40503  , "CC"},				-- Possession Transfer
  {40563  , "CC"},				-- Throw Axe
  {40578  , "CC"},				-- Cyclone
  {40774  , "CC"},				-- Stun Pulse
  {40835  , "CC"},				-- Stasis Field
  {40846  , "CC"},				-- Crystal Prison
  {40858  , "CC"},				-- Ethereal Ring}, Cannon Visual
  {40951  , "CC"},				-- Stasis Field
  {41182  , "CC"},				-- Concussive Throw
  {41186  , "CC"},				-- Wyvern Sting
  {41358  , "CC"},				-- Rizzle's Blackjack
  {41421  , "CC"},				-- Brief Stun
  {41528  , "CC"},				-- Mark of Stormrage
  {41534  , "CC"},				-- War Stomp
  {41592  , "CC"},				-- Spirit Channelling
  {41962  , "CC"},				-- Possession Transfer
  {42386  , "CC"},				-- Sleeping Sleep
  {42621  , "CC"},				-- Fire Bomb
  {42648  , "CC"},				-- Sleeping Sleep
  {43448  , "CC"},				-- Freezing Trap
  {43519  , "CC"},				-- Charge
  {43528  , "CC"},				-- Cyclone
  {44031  , "CC"},				-- Tackled!
  {44138  , "CC"},				-- Rocket Launch
  {44415  , "CC"},				-- Blackout
  {44432  , "CC"},				-- Cube Ground State
  {44836  , "CC"},				-- Banish
  {44994  , "CC"},				-- Self Repair
  {45270  , "CC"},				-- Shadowfury
  {45574  , "CC"},				-- Water Tomb
  {45676  , "CC"},				-- Juggle Torch (Quest}, Missed)
  {45889  , "CC"},				-- Scorchling Blast
  {45947  , "CC"},				-- Slip
  {46188  , "CC"},				-- Rocket Launch
  {46590  , "CC"},				-- Ninja Grenade {PH
  {48342  , "CC"},				-- Stun Self
  {50876  , "CC"},				-- Mounted Charge
  {47407  , "Root"},				-- Direbrew's Disarm (precast)
  {47411  , "Root"},				-- Direbrew's Disarm (spin)
  {43207  , "Root"},				-- Headless Horseman Climax - Head's Breath
  {43049  , "Root"},				-- Upset Tummy
  {31287  , "Root"},				-- Entangling Roots
  {31290  , "Root"},				-- Net
  {31409  , "Root"},				-- Wild Roots
  {33356  , "Root"},				-- Self Root Forever
  {33844  , "Root"},				-- Entangling Roots
  {34080  , "Root"},				-- Riposte Stance
  {34569  , "Root"},				-- Chilled Earth
  {34779  , "Root"},				-- Freezing Circle
  {35234  , "Root"},				-- Strangling Roots
  {35247  , "Root"},				-- Choking Wound
  {35327  , "Root"},				-- Jackhammer
  {39194  , "Root"},				-- Jackhammer
  {36252  , "Root"},				-- Felforge Flames
  {36734  , "Root"},				-- Test Whelp Net
  {37823  , "Root"},				-- Entangling Roots
  {38033  , "Root"},				-- Frost Nova
  {38035  , "Root"},				-- Freeze
  {38051  , "Root"},				-- Fel Shackles
  {38338  , "Root"},				-- Net
  {38505  , "Root"},				-- Shackle
  {39268  , "Root"},				-- Chains of Ice
  {40363  , "Root"},				-- Entangling Roots
  {40525  , "Root"},				-- Rizzle's Frost Grenade
  {40590  , "Root"},				-- Rizzle's Frost Grenade (Self
  {40727  , "Root"},				-- Icy Leap
  {40875  , "Root"},				-- Freeze
  {41981  , "Root"},				-- Dust Field
  {42716  , "Root"},				-- Self Root Forever (No Visual)
  {43130  , "Root"},				-- Creeping Vines
  {43150  , "Root"},				-- Claw Rage
  {43426  , "Root"},				-- Frost Nova
  {43585  , "Root"},				-- Entangle
  {45255  , "Root"},				-- Rocket Chicken
  {45905  , "Root"},				-- Frost Nova
},

	-- PvE

  -- PvE
  	--{123456 , "PvE"},				-- This is just an example}, not a real spell
  	------------------------
  	---- PVE TBC
  	------------------------
  {"Karazhan Raid",
  	-- -- Trash
  	{18812  , "CC"},				-- Knockdown
  	{29684  , "CC"},				-- Shield Slam
  	{29679  , "CC"},				-- Bad Poetry
  	{29676  , "CC"},				-- Rolling Pin
  	{29490  , "CC"},				-- Seduction
  	{29300  , "CC"},				-- Sonic Blast
  	{29321  , "CC"},				-- Fear
  	{29546  , "CC"},				-- Oath of Fealty
  	{29670  , "CC"},				-- Ice Tomb
  	{29690  , "CC"},				-- Drunken Skull Crack
  	{29486  , "CC"},				-- Bewitching Aura (spell damage done reduced by 50%)
  	{29485  , "CC"},				-- Alluring Aura (physical damage done reduced by 50%)
  	{37498  , "CC"},				-- Stomp (physical damage done reduced by 50%)
  	{41580  , "Root"},				-- Net
  	{29505  , "Silence"},			-- Banshee Shriek
  	{30013  , "Disarm"},			-- Disarm
  	--{30019  , "CC"},				-- Control Piece
  	--{39331  , "Silence"},			-- Game In Session

  	-- -- Servant Quarters
  	{29896  , "CC"},				-- Hyakiss' Web
  	{29904  , "Silence"},			-- Sonic Burst
  	-- -- Attumen the Huntsman
  	{29711  , "CC"},				-- Knockdown
  	{29833  , "CC"},				-- Intangible Presence (chance to hit with spells and melee attacks reduced by 50%)
  	-- -- Moroes
  	{29425  , "CC"},				-- Gouge
  	{34694  , "CC"},				-- Blind
  	-- -- Maiden of Virtue
  	{29511  , "CC"},				-- Repentance
  	{29512  , "Silence"},			-- Holy Ground
  	-- -- Opera Event
  	{31046  , "CC"},				-- Brain Bash
  	{30889  , "CC"},				-- Powerful Attraction
  	{30761  , "CC"},				-- Wide Swipe
  	{31013  , "CC"},				-- Frightened Scream
  	{30752  , "CC"},				-- Terrifying Howl
  	{31075  , "CC"},				-- Burning Straw
  	{30753  , "CC"},				-- Red Riding Hood
  	{30756  , "CC"},				-- Little Red Riding Hood
  	{31015  , "CC"},				-- Annoying Yipping
  	{31069  , "Silence"},			-- Brain Wipe
  	-- -- The Curator
  	{30254  , "CC"},				-- Evocation
  	-- -- Terestian Illhoof
  	{30115  , "CC"},				-- Sacrifice
  	-- -- Shade of Aran
  	{29964  , "CC"},				-- Dragon's Breath
  	{29963  , "CC"},				-- Mass Polymorph
  	{29991  , "Root"},				-- Chains of Ice

  	-- -- Nightbane
  	{36922  , "CC"},				-- Bellowing Roar
  	{30130  , "CC"},				-- Distracting Ash (chance to hit with attacks}, spells and abilities reduced by 30%)
  	-- -- Prince Malchezaar
    },
  	------------------------
  {"Gruul's Lair Raid",
  	-- -- Trash
  	{33709  , "CC"},				-- Charge
  	-- -- High King Maulgar & Council
  	{33173  , "CC"},				-- Greater Polymorph
  	{33130  , "CC"},				-- Death Coil
  	{33175  , "Disarm"},			-- Arcane Shock
  	-- -- Gruul the Dragonkiller
  	{33652  , "CC"},				-- Stoned
  	{36297  , "Silence"},			-- Reverberation
  	------------------------
  	-- -- Magtheridon’s Lair Raid
  	-- -- Trash
  	{34437  , "CC"},				-- Death Coil
  	{31117  , "Silence"},			-- Unstable Affliction
  	-- -- Magtheridon
  	{30530  , "CC"},				-- Fear
  	{30168  , "CC"},				-- Shadow Cage
  	{30205  , "CC"},				-- Shadow Cage
    },
  	------------------------
  {"Serpentshrine Cavern Raid",
  	-- -- Trash
  	{38945  , "CC"},				-- Frightening Shout
  	{38946  , "CC"},				-- Frightening Shout
  	{38626  , "CC"},				-- Domination
  	{39002  , "CC"},				-- Spore Quake Knockdown
  	{38661  , "Root"},				-- Net
  	{39035  , "Root"},				-- Frost Nova
  	{39063  , "Root"},				-- Frost Nova
  	{38634  , "Silence"},			-- Arcane Lightning
  	{38491  , "Silence"},			-- Silence

  	-- -- Hydross the Unstable
  	{38246  , "CC"},				-- Vile Sludge (damage and healing dealt is reduced by 50%)
  	-- -- Leotheras the Blind
  	{37749  , "CC"},				-- Consuming Madness
  	-- -- Fathom-Lord Karathress
  	{38441  , "CC"},				-- Cataclysmic Bolt
  	-- -- Morogrim Tidewalker
  	{37871  , "CC"},				-- Freeze
  	{37850  , "CC"},				-- Watery Grave
  	{38023  , "CC"},				-- Watery Grave
  	{38024  , "CC"},				-- Watery Grave
  	{38025  , "CC"},				-- Watery Grave
  	{38049  , "CC"},				-- Watery Grave
  	-- -- Lady Vashj
  	{38509  , "CC"},				-- Shock Blast
  	{38511  , "CC"},				-- Persuasion
  	{38258  , "CC"},				-- Panic
  	{38316  , "Root"},				-- Entangle
  	{38132  , "Root"},				-- Paralyze (Tainted Core item)
    },
  	------------------------
  {"The Eye (Tempest Keep) Raid",
  	-- -- Trash
  	{34937  , "CC"},				-- Powered Down
  	{37122  , "CC"},				-- Domination
  	{37135  , "CC"},				-- Domination
  	{37118  , "CC"},				-- Shell Shock
  	{39077  , "CC"},				-- Hammer of Justice
  	{37160  , "Silence"},			-- Silence

  	-- -- Void Reaver
  	{34190  , "Silence"},			-- Arcane Orb
  	-- -- Kael'thas
  	{36834  , "CC"},				-- Arcane Disruption
  	{37018  , "CC"},				-- Conflagration
  	{44863  , "CC"},				-- Bellowing Roar
  	{36797  , "CC"},				-- Mind Control
  	{37029  , "CC"},				-- Remote Toy
  	{36989  , "Root"},				-- Frost Nova

    },
  	------------------------
  {"Black Temple Raid",
  	-- -- Trash
  	{41345  , "CC"},				-- Infatuation
  	{39645  , "CC"},				-- Shadow Inferno
  	{41150  , "CC"},				-- Fear
  	{39574  , "CC"},				-- Charge
  	{39674  , "CC"},				-- Banish
  	{40936  , "CC"},				-- War Stomp
  	{41197  , "CC"},				-- Shield Bash
  	{41272  , "CC"},				-- Behemoth Charge
  	{41274  , "CC"},				-- Fel Stomp
  	{41338  , "CC"},				-- Love Tap
  	{41396  , "CC"},				-- Sleep
  	{41356  , "CC"},				-- Chest Pains
  	{41213  , "CC"},				-- Throw Shield
  	{40864  , "CC"},				-- Throbbing Stun
  	{41334  , "CC"},				-- Polymorph
  	{40099  , "CC"},				-- Vile Slime (damage and healing dealt reduced by 50%)
  	{40079  , "CC"},				-- Debilitating Spray (damage and healing dealt reduced by 50%)
  	{39584  , "Root"},				-- Sweeping Wing Clip
  	{40082  , "Root"},				-- Hooked Net
  	{41086  , "Root"},				-- Ice Trap

  	{41062  , "Disarm"},			-- Disarm
  	{36139  , "Disarm"},			-- Disarm
  	{41084  , "Silence"},			-- Silencing Shot
  	{41168  , "Silence"},			-- Sonic Strike
  	-- -- High Warlord Naj'entus
  	{39837  , "CC"},				-- Impaling Spine
  	-- -- Supremus
  	-- -- Shade of Akama
  	{41179  , "CC"},				-- Debilitating Strike (physical damage done reduced by 75%)
  	-- -- Teron Gorefiend
  	{40175  , "CC"},				-- Spirit Chains
  	-- -- Gurtogg Bloodboil
  	{40597  , "CC"},				-- Eject
  	{40491  , "CC"},				-- Bewildering Strike
  	{40569  , "Root"},				-- Fel Geyser
  	{40591  , "CC"},				-- Fel Geyser
  	-- -- Reliquary of the Lost
  	{41426  , "CC"},				-- Spirit Shock
  	-- -- Mother Shahraz
  	{40823  , "Silence"},			-- Silencing Shriek
  	-- -- The Illidari Council
  	{41468  , "CC"},				-- Hammer of Justice
  	{41479  , "CC"},				-- Vanish
  	-- -- Illidan
  	{40647  , "CC"},				-- Shadow Prison
  	{41083  , "CC"},				-- Paralyze
  	{40620  , "CC"},				-- Eyebeam
  	{40695  , "CC"},				-- Caged
  	{40760  , "CC"},				-- Cage Trap
  	{41218  , "CC"},				-- Death
  	{41220  , "CC"},				-- Death
  	{41221  , "CC"},				-- Teleport Maiev
    },
  	------------------------
  {"Hyjal Summit Raid",
  	-- -- Trash
  	{31755  , "CC"},				-- War Stomp
  	{31610  , "CC"},				-- Knockdown
  	{31537  , "CC"},				-- Cannibalize
  	{31302  , "CC"},				-- Inferno Effect
  	{31651  , "CC"},				-- Banshee Curse (chance to hit reduced by 66%)
  	{42201  , "Silence"},			-- Eternal Silence
  	{42205  , "Silence"},			-- Residue of Eternity

  	-- -- Rage Winterchill
  	{31249  , "CC"},				-- Icebolt
  	{31250  , "Root"},				-- Frost Nova
  	-- -- Anetheron
  	{31298  , "CC"},				-- Sleep
  	-- -- Kaz'rogal
  	{31480  , "CC"},				-- War Stomp
  	-- -- Azgalor
  	{31344  , "Silence"},			-- Howl of Azgalor
  	-- -- Archimonde
  	{31970  , "CC"},				-- Fear
  	{32053  , "Silence"},			-- Soul Charge
    },
  	------------------------
  	{"Zul'Aman Raid",
  	-- -- Trash
  	{43356  , "CC"},				-- Pounce
  	{43361  , "CC"},				-- Domesticate
  	{42220  , "CC"},				-- Conflagration
  	{35011  , "CC"},				-- Knockdown
  	{43362  , "Root"},				-- Electrified Net

  	-- -- Akil'zon
  	{43648  , "CC"},				-- Electrical Storm
  	-- -- Nalorakk
  	{42398  , "Silence"},			-- Deafening Roar
  	-- -- Hex Lord Malacrass
  	{43590  , "CC"},				-- Psychic Wail
  	-- -- Daakara
  	{43437  , "CC"},				-- Paralyzed
    },
  	------------------------
  {"Sunwell Plateau Raid",
  	-- -- Trash
  	{46762  , "CC"},				-- Shield Slam
  	{46288  , "CC"},				-- Petrify
  	{46239  , "CC"},				-- Bear Down
  	{46561  , "CC"},				-- Fear
  	{46427  , "CC"},				-- Domination
  	{46280  , "CC"},				-- Polymorph
  	{46295  , "CC"},				-- Hex
  	{46681  , "CC"},				-- Scatter Shot
  	{45029  , "CC"},				-- Corrupting Strike
  	{44872  , "CC"},				-- Frost Blast
  	{45201  , "CC"},				-- Frost Blast
  	{45203  , "CC"},				-- Frost Blast
  	{46555  , "Root"},				-- Frost Nova

  	-- -- Kalecgos & Sathrovarr
  	{45066  , "CC"},				-- Self Stun
  	{45002  , "CC"},				-- Wild Magic (chance to hit with melee and ranged attacks reduced by 50%)
  	{45122  , "CC"},				-- Tail Lash
  	-- -- Felmyst
  	{46411  , "CC"},				-- Fog of Corruption
  	{45717  , "CC"},				-- Fog of Corruption
  	-- -- Grand Warlock Alythess & Lady Sacrolash
  	{45256  , "CC"},				-- Confounding Blow
  	{45342  , "CC"},				-- Conflagration
  	-- -- M'uru
  	{46102  , "Root"},				-- Spell Fury

  	-- -- Kil'jaeden
  	{37369  , "CC"},				-- Hammer of Justice
    },
  	------------------------
  	------------------------
  	-- TBC Dungeons
  {"Hellfire Ramparts",
  	{39427  , "CC"},				-- Bellowing Roar
  	{30615  , "CC"},				-- Fear
  	{30621  , "CC"},				-- Kidney Shot

    },
  {"The Blood Furnace",
  	{30923  , "CC"},				-- Domination
  	{31865  , "CC"},				-- Seduction

    },
  {"The Shattered Halls",
  	{30500  , "CC"},				-- Death Coil
  	{30741  , "CC"},				-- Death Coil
  	{30584  , "CC"},				-- Fear
  	{37511  , "CC"},				-- Charge
  	{23601  , "CC"},				-- Scatter Shot
  	{30980  , "CC"},				-- Sap
  	{30986  , "CC"},				-- Cheap Shot
    },
  {"The Slave Pens",
  	{34984  , "CC"},				-- Psychic Horror
  	{32173  , "Root"},				-- Entangling Roots
  	{31983  , "Root"},				-- Earthgrab
  	{32192  , "Root"},				-- Frost Nova
    },
  {"The Underbog",
  	{31428  , "CC"},				-- Sneeze
  	{31932  , "CC"},				-- Freezing Trap Effect
  	{35229  , "CC"},				-- Sporeskin (chance to hit with attacks}, spells and abilities reduced by 35%)
  	{31673  , "Root"},				-- Foul Spores
    },
  {"The Steamvault",
  	{31718  , "CC"},				-- Enveloping Winds
  	{38660  , "CC"},				-- Fear
  	{35107  , "Root"},				-- Electrified Net
    },
  {"Mana-Tombs",
  	{32361  , "CC"},				-- Crystal Prison
  	{34322  , "CC"},				-- Psychic Scream
  	{33919  , "CC"},				-- Earthquake
  	{34940  , "CC"},				-- Gouge
  	{32365  , "Root"},				-- Frost Nova
  	{34922  , "Silence"},			-- Shadows Embrace
    },
  {"Auchenai Crypts",
  	{32421  , "CC"},				-- Soul Scream
  	{32830  , "CC"},				-- Possess
  	{32859  , "Root"},				-- Falter
  	{33401  , "Root"},				-- Possess
  	{32346  , "CC"},				-- Stolen Soul (damage and healing done reduced by 50%)
    },
  {"Sethekk Halls",
  	{40305  , "CC"},				-- Power Burn
  	{40184  , "CC"},				-- Paralyzing Screech
  	{43309  , "CC"},				-- Polymorph
  	{38245  , "CC"},				-- Polymorph
  	{40321  , "CC"},				-- Cyclone of Feathers
  	{35120  , "CC"},				-- Charm
  	{32654  , "CC"},				-- Talon of Justice
  	{32690  , "Silence"},			-- Arcane Lightning
  	{38146  , "Silence"},			-- Arcane Lightning
    },
  {"Shadow Labyrinth",
  	{33547  , "CC"},				-- Fear
  	{38791  , "CC"},				-- Banish
  	{33563  , "CC"},				-- Draw Shadows
  	{33684  , "CC"},				-- Incite Chaos
  	{33502  , "CC"},				-- Brain Wash
  	{33332  , "CC"},				-- Suppression Blast
  	{33686  , "Silence"},			-- Shockwave
  	{33499  , "Silence"},			-- Shape of the Beast
    },
  {"Old Hillsbrad Foothills",
  	{33789  , "CC"},				-- Frightening Shout
  	{50733  , "CC"},				-- Scatter Shot
  	{32890  , "CC"},				-- Knockout
  	{32864  , "CC"},				-- Kidney Shot
  	{41389  , "CC"},				-- Kidney Shot
  	{50762  , "Root"},				-- Net
  	{12024  , "Root"},				-- Net
    },
  {"The Black Morass",
  	{31422  , "CC"},				-- Time Stop
    },
  {"The Mechanar",
  	{35250  , "CC"},				-- Dragon's Breath
  	{35326  , "CC"},				-- Hammer Punch
  	{35280  , "CC"},				-- Domination
  	{35049  , "CC"},				-- Pound
  	{35783  , "CC"},				-- Knockdown
  	{36333  , "CC"},				-- Anesthetic
  	{35268  , "CC"},				-- Inferno
  	{36022  , "Silence"},			-- Arcane Torrent
  	{35055  , "Disarm"},			-- The Claw
    },
  {"The Arcatraz",
  	{36924  , "CC"},				-- Mind Rend
  	{39017  , "CC"},				-- Mind Rend
  	{39415  , "CC"},				-- Fear
  	{37162  , "CC"},				-- Domination
  	{36866  , "CC"},				-- Domination
  	{39019  , "CC"},				-- Complete Domination
  	{38850  , "CC"},				-- Deafening Roar
  	{36887  , "CC"},				-- Deafening Roar
  	{36700  , "CC"},				-- Hex
  	{36840  , "CC"},				-- Polymorph
  	{38896  , "CC"},				-- Polymorph
  	{36634  , "CC"},				-- Emergence
  	{36719  , "CC"},				-- Explode
  	{38830  , "CC"},				-- Explode
  	{36835  , "CC"},				-- War Stomp
  	{38911  , "CC"},				-- War Stomp
  	{36862  , "CC"},				-- Gouge
  	{36778  , "CC"},				-- Soul Steal (physical damage done reduced by 45%)
  	{35963  , "Root"},				-- Improved Wing Clip
  	{36512  , "Root"},				-- Knock Away
  	{36827  , "Root"},				-- Hooked Net
  	{38912  , "Root"},				-- Hooked Net
  	{37480  , "Root"},				-- Bind
  	{38900  , "Root"},				-- Bind
    },
  {"The Botanica",
  	{34716  , "CC"},				-- Stomp
  	{34661  , "CC"},				-- Sacrifice
  	{32323  , "CC"},				-- Charge
  	{34639  , "CC"},				-- Polymorph
  	{34752  , "CC"},				-- Freezing Touch
  	{34770  , "CC"},				-- Plant Spawn Effect
  	{34801  , "CC"},				-- Sleep
  	{22127  , "Root"},				-- Entangling Roots
    },
  {"Magisters' Terrace",
  	{47109  , "CC"},				-- Power Feedback
  	{44233  , "CC"},				-- Power Feedback
  	{46183  , "CC"},				-- Knockdown
  	{46026  , "CC"},				-- War Stomp
  	{46024  , "CC"},				-- Fel Iron Bomb
  	{46184  , "CC"},				-- Fel Iron Bomb
  	{44352  , "CC"},				-- Overload
  	{38595  , "CC"},				-- Fear
  	{44320  , "CC"},				-- Mana Rage
  	{44547  , "CC"},				-- Deadly Embrace
  	{44765  , "CC"},				-- Banish
  	{44177  , "Root"},				-- Frost Nova
  	{47168  , "Root"},				-- Improved Wing Clip
  	{46182  , "Silence"},			-- Snap Kick
    },
  	------------------------
  	---- PVE CLASSIC
  	------------------------
  {"Molten Core Raid",
  	-- -- Trash
  	{19364  , "CC"},				-- Ground Stomp
  	{19369  , "CC"},				-- Ancient Despair
  	{19641  , "CC"},				-- Pyroclast Barrage
  	{20276  , "CC"},				-- Knockdown
  	{19393  , "Silence"},			-- Soul Burn
  	{19636  , "Root"},				-- Fire Blossom
  	-- -- Lucifron
  	{20604  , "CC"},				-- Dominate Mind
  	-- -- Magmadar
  	{19408  , "CC"},				-- Panic
  	-- -- Gehennas
  	{20277  , "CC"},				-- Fist of Ragnaros
  	-- -- Garr
  	-- -- Shazzrah
  	-- -- Baron Geddon
  	{19695  , "CC"},				-- Inferno
  	{20478  , "CC"},				-- Armageddon
  	-- -- Golemagg the Incinerator
  	-- -- Sulfuron Harbinger
  	{19780  , "CC"},				-- Hand of Ragnaros
  	-- -- Majordomo Executus
    },
  	------------------------
  {"Onyxia's Lair Raid",
  	-- -- Onyxia
  	{18431  , "CC"},				-- Bellowing Roar
  	------------------------
  	-- Blackwing Lair Raid
  	-- -- Trash
  	{24375  , "CC"},				-- War Stomp
  	{22289  , "CC"},				-- Brood Power: Green
  	{22291  , "CC"},				-- Brood Power: Bronze
  	{22561  , "CC"},				-- Brood Power: Green
  	-- -- Razorgore the Untamed
  	{19872  , "CC"},				-- Calm Dragonkin
  	{23023  , "CC"},				-- Conflagration
  	{15593  , "CC"},				-- War Stomp
  	{16740  , "CC"},				-- War Stomp
  	{28725  , "CC"},				-- War Stomp
  	{14515  , "CC"},				-- Dominate Mind
  	{22274  , "CC"},				-- Greater Polymorph
  	-- -- Broodlord Lashlayer
  	-- -- Chromaggus
  	{23310  , "CC"},				-- Time Lapse
  	{23312  , "CC"},				-- Time Lapse
  	{23174  , "CC"},				-- Chromatic Mutation
  	{23171  , "CC"},				-- Time Stop (Brood Affliction: Bronze)
  	-- -- Nefarian
  	{22666  , "Silence"},			-- Silence
  	{22667  , "CC"},				-- Shadow Command
  	{22686  , "CC"},				-- Bellowing Roar
  	{22678  , "CC"},				-- Fear
  	{23603  , "CC"},				-- Wild Polymorph
  	{23364  , "CC"},				-- Tail Lash
  	{23365  , "Disarm"},			-- Dropped Weapon
  	{23414  , "Root"},				-- Paralyze
    },
  	------------------------
  {"Zul'Gurub Raid",
  	-- -- Trash
  	{24619  , "Silence"},			-- Soul Tap
  	{24048  , "CC"},				-- Whirling Trip
  	{24600  , "CC"},				-- Web Spin
  	{24335  , "CC"},				-- Wyvern Sting
  	{24020  , "CC"},				-- Axe Flurry
  	{24671  , "CC"},				-- Snap Kick
  	{24333  , "CC"},				-- Ravage
  	{6869   , "CC"},				-- Fall down
  	{24053  , "CC"},				-- Hex
  	-- -- High Priestess Jeklik
  	{23918  , "Silence"},			-- Sonic Burst
  	{22884  , "CC"},				-- Psychic Scream
  	{22911  , "CC"},				-- Charge
  	{23919  , "CC"},				-- Swoop
  	{26044  , "CC"},				-- Mind Flay
  	-- -- High Priestess Mar'li
  	{24110  , "Silence"},			-- Enveloping Webs
  	-- -- High Priest Thekal
  	{21060  , "CC"},				-- Blind
  	{12540  , "CC"},				-- Gouge
  	{24193  , "CC"},				-- Charge
  	-- -- Bloodlord Mandokir & Ohgan
  	{24408  , "CC"},				-- Charge
  	-- -- Gahz'ranka
  	-- -- Jin'do the Hexxer
  	{17172  , "CC"},				-- Hex
  	{24261  , "CC"},				-- Brain Wash
  	-- -- Edge of Madness: Gri'lek}, Hazza'rah}, Renataki}, Wushoolay
  	{24648  , "Root"},				-- Entangling Roots
  	{24664  , "CC"},				-- Sleep
  	-- -- Hakkar
  	{24687  , "Silence"},			-- Aspect of Jeklik
  	{24686  , "CC"},				-- Aspect of Mar'li
  	{24690  , "CC"},				-- Aspect of Arlokk
  	{24327  , "CC"},				-- Cause Insanity
  	{24178  , "CC"},				-- Will of Hakkar
  	{24322  , "CC"},				-- Blood Siphon
  	{24323  , "CC"},				-- Blood Siphon
  	{24324  , "CC"},				-- Blood Siphon
    },
  	------------------------
  {"Ruins of Ahn'Qiraj Raid",
  	-- -- Trash
  	{25371  , "CC"},				-- Consume
  	{26196  , "CC"},				-- Consume
  	{25654  , "CC"},				-- Tail Lash
  	{25515  , "CC"},				-- Bash
  	{25756  , "CC"},				-- Purge
  	-- -- Kurinnaxx
  	{25656  , "CC"},				-- Sand Trap
  	-- -- General Rajaxx
  	{19134  , "CC"},				-- Frightening Shout
  	{29544  , "CC"},				-- Frightening Shout
  	{25425  , "CC"},				-- Shockwave
  	-- -- Moam
  	{25685  , "CC"},				-- Energize
  	{28450  , "CC"},				-- Arcane Explosion
  	-- -- Ayamiss the Hunter
  	{25852  , "CC"},				-- Lash
  	{6608   , "Disarm"},			-- Dropped Weapon
  	{25725  , "CC"},				-- Paralyze
  	-- -- Ossirian the Unscarred
  	{25189  , "CC"},				-- Enveloping Winds
    },
  	------------------------
  {"Temple of Ahn'Qiraj Raid",
  	-- -- Trash
  	{7670   , "CC"},				-- Explode
  	{18327  , "Silence"},			-- Silence
  	{26069  , "Silence"},			-- Silence
  	{26070  , "CC"},				-- Fear
  	{26072  , "CC"},				-- Dust Cloud
  	{25698  , "CC"},				-- Explode
  	{26079  , "CC"},				-- Cause Insanity
  	{26049  , "CC"},				-- Mana Burn
  	{26552  , "CC"},				-- Nullify
  	{26071  , "Root"},				-- Entangling Roots
  	-- -- The Prophet Skeram
  	{785    , "CC"},				-- True Fulfillment
  	-- -- Bug Trio: Yauj}, Vem}, Kri
  	{3242   , "CC"},				-- Ravage
  	{26580  , "CC"},				-- Fear
  	{19128  , "CC"},				-- Knockdown
  	-- -- Fankriss the Unyielding
  	{720    , "CC"},				-- Entangle
  	{731    , "CC"},				-- Entangle
  	{1121   , "CC"},				-- Entangle
  	-- -- Viscidus
  	{25937  , "CC"},				-- Viscidus Freeze
  	-- -- Princess Huhuran
  	{26180  , "CC"},				-- Wyvern Sting
  	{26053  , "Silence"},			-- Noxious Poison
  	-- -- Twin Emperors: Vek'lor & Vek'nilash
  	{800    , "CC"},				-- Twin Teleport
  	{804    , "Root"},				-- Explode Bug
  	{12241  , "Root"},				-- Twin Colossals Teleport
  	{12242  , "Root"},				-- Twin Colossals Teleport
  	-- -- Ouro
  	{26102  , "CC"},				-- Sand Blast
  	-- -- C'Thun
    },
  	------------------------
  {"Naxxramas (Classic) Raid",
  	-- -- Trash
  	{6605   , "CC"},				-- Terrifying Screech
  	{27758  , "CC"},				-- War Stomp
  	{27990  , "CC"},				-- Fear
  	{28412  , "CC"},				-- Death Coil
  	{29848  , "CC"},				-- Polymorph
  	{29849  , "Root"},				-- Frost Nova
  	{30094  , "Root"},				-- Frost Nova
  	-- -- Anub'Rekhan
  	{28786  , "CC"},				-- Locust Swarm
  	{25821  , "CC"},				-- Charge
  	{28991  , "Root"},				-- Web
  	-- -- Grand Widow Faerlina
  	{30225  , "Silence"},			-- Silence
  	-- -- Maexxna
  	{28622  , "CC"},				-- Web Wrap
  	{29484  , "CC"},				-- Web Spray
  	-- -- Noth the Plaguebringer
  	-- -- Heigan the Unclean
  	{30112  , "CC"},				-- Frenzied Dive
  	-- -- Instructor Razuvious
  	-- -- Gothik the Harvester
  	{11428  , "CC"},				-- Knockdown
  	-- -- Gluth
  	{29685  , "CC"},				-- Terrifying Roar
  	-- -- Sapphiron
  	{28522  , "CC"},				-- Icebolt
  	-- -- Kel'Thuzad
  	{28410  , "CC"},				-- Chains of Kel'Thuzad
  	{27808  , "CC"},				-- Frost Blast
    },
  	------------------------
  {"Classic World Bosses",
  	-- -- Azuregos
  	{23186  , "CC"},				-- Aura of Frost
  	{21099  , "CC"},				-- Frost Breath
  	-- -- Doom Lord Kazzak & Highlord Kruul
  	-- -- Dragons of Nightmare
  	{25043  , "CC"},				-- Aura of Nature
  	{24778  , "CC"},				-- Sleep (Dream Fog)
  	{24811  , "CC"},				-- Draw Spirit
  	{25806  , "CC"},				-- Creature of Nightmare
  	{12528  , "Silence"},			-- Silence
  	{23207  , "Silence"},			-- Silence
  	{29943  , "Silence"},			-- Silence
    },
  	------------------------
  	-- Classic Dungeons
  {"Ragefire Chasm",
  	{8242   , "CC"},				-- Shield Slam
    },
  {"The Deadmines",
  	{6304   , "CC"},				-- Rhahk'Zor Slam
  	{6713   , "Disarm"},			-- Disarm
  	{7399   , "CC"},				-- Terrify
  	{6435   , "CC"},				-- Smite Slam
  	{6432   , "CC"},				-- Smite Stomp
  	{113    , "Root"},				-- Chains of Ice
  	{512    , "Root"},				-- Chains of Ice
  	{228    , "CC"},				-- Polymorph: Chicken
  	{6466   , "CC"},				-- Axe Toss
    },
  {"Wailing Caverns",
  	{8040   , "CC"},				-- Druid's Slumber
  	{8142   , "Root"},				-- Grasping Vines
  	{5164   , "CC"},				-- Knockdown
  	{7967   , "CC"},				-- Naralex's Nightmare
  	{6271   , "CC"},				-- Naralex's Awakening
  	{8150   , "CC"},				-- Thundercrack
    },
  {"Shadowfang Keep",
  	{7295   , "Root"},				-- Soul Drain
  	{7587   , "Root"},				-- Shadow Port
  	{7136   , "Root"},				-- Shadow Port
  	{7586   , "Root"},				-- Shadow Port
  	{7139   , "CC"},				-- Fel Stomp
  	{13005  , "CC"},				-- Hammer of Justice
  	{7621   , "CC"},				-- Arugal's Curse
  	{7803   , "CC"},				-- Thundershock
  	{7074   , "Silence"},			-- Screams of the Past
    },
  {"Blackfathom Deeps",
  	{15531  , "Root"},				-- Frost Nova
  	{6533   , "Root"},				-- Net
  	{8399   , "CC"},				-- Sleep
  	{8379   , "Disarm"},			-- Disarm
  	{8391   , "CC"},				-- Ravage
  	{7645   , "CC"},				-- Dominate Mind
    },
  {"The Stockade",
  	{7964   , "CC"},				-- Smoke Bomb
  	{6253   , "CC"},				-- Backhand
    },
  {"Gnomeregan",
  	{10737  , "CC"},				-- Hail Storm
  	{15878  , "CC"},				-- Ice Blast
  	{10856  , "CC"},				-- Link Dead
  	{11820  , "Root"},				-- Electrified Net
  	{10852  , "Root"},				-- Battle Net
  	{11264  , "Root"},				-- Ice Blast
  	{10730  , "CC"},				-- Pacify
    },
  {"Razorfen Kraul",
  	{8281   , "Silence"},			-- Sonic Burst
  	{8359   , "CC"},				-- Left for Dead
  	{8285   , "CC"},				-- Rampage
  	{8377   , "Root"},				-- Earthgrab
  	{6728   , "CC"},				-- Enveloping Winds
  	{6524   , "CC"},				-- Ground Tremor
    },
  {"Scarlet Monastery",
  	{13323  , "CC"},				-- Polymorph
  	{8988   , "Silence"},			-- Silence
  	{9256   , "CC"},				-- Deep Sleep
    },
  {"Razorfen Downs",
  	{12252  , "Root"},				-- Web Spray
  	{12946  , "Silence"},			-- Putrid Stench
  	{745    , "Root"},				-- Web
  	{12748  , "Root"},				-- Frost Nova
    },
  {"Uldaman",
  	{11876  , "CC"},				-- War Stomp
  	{3636   , "CC"},				-- Crystalline Slumber
  	{6726   , "Silence"},			-- Silence
  	{10093  , "Silence"},			-- Harsh Winds
  	{25161  , "Silence"},			-- Harsh Winds
    },
  {"Maraudon",
  	{12747  , "Root"},				-- Entangling Roots
  	{21331  , "Root"},				-- Entangling Roots
  	{21909  , "Root"},				-- Dust Field
  	{21808  , "CC"},				-- Summon Shardlings
  	{29419  , "CC"},				-- Flash Bomb
  	{22592  , "CC"},				-- Knockdown
  	{21869  , "CC"},				-- Repulsive Gaze
  	{16790  , "CC"},				-- Knockdown
  	{21748  , "CC"},				-- Thorn Volley
  	{21749  , "CC"},				-- Thorn Volley
  	{11922  , "Root"},				-- Entangling Roots
    },
  {"Zul'Farrak",
  	{11020  , "CC"},				-- Petrify
  	{22692  , "CC"},				-- Petrify
  	{13704  , "CC"},				-- Psychic Scream
  	{11836  , "CC"},				-- Freeze Solid
  	{11641  , "CC"},				-- Hex
    },
  {"The Temple of Atal'Hakkar (Sunken Temple)",
  	{12888  , "CC"},				-- Cause Insanity
  	{12480  , "CC"},				-- Hex of Jammal'an
  	{12890  , "CC"},				-- Deep Slumber
  	{6607   , "CC"},				-- Lash
  	{33126  , "Disarm"},			-- Dropped Weapon
  	{25774  , "CC"},				-- Mind Shatter
    },
  {"Blackrock Depths",
  	{8994   , "CC"},				-- Banish
  	{12674  , "Root"},				-- Frost Nova
  	{15471  , "Silence"},			-- Enveloping Web
  	{3609   , "CC"},				-- Paralyzing Poison
  	{15474  , "Root"},				-- Web Explosion
  	{17492  , "CC"},				-- Hand of Thaurissan
  	{14030  , "Root"},				-- Hooked Net
  	{14870  , "CC"},				-- Drunken Stupor
  	{13902  , "CC"},				-- Fist of Ragnaros
  	{15063  , "Root"},				-- Frost Nova
  	{6945   , "CC"},				-- Chest Pains
  	{3551   , "CC"},				-- Skull Crack
  	{15621  , "CC"},				-- Skull Crack
  	{11831  , "Root"},				-- Frost Nova
    },
  {"Blackrock Spire",
  	{16097  , "CC"},				-- Hex
  	{22566  , "CC"},				-- Hex
  	{15618  , "CC"},				-- Snap Kick
  	{16075  , "CC"},				-- Throw Axe
  	{16045  , "CC"},				-- Encage
  	{16104  , "CC"},				-- Crystallize
  	{16508  , "CC"},				-- Intimidating Roar
  	{15609  , "Root"},				-- Hooked Net
  	{16497  , "CC"},				-- Stun Bomb
  	{5276   , "CC"},				-- Freeze
  	{18763  , "CC"},				-- Freeze
  	{16805  , "CC"},				-- Conflagration
  	{13579  , "CC"},				-- Gouge
  	{24698  , "CC"},				-- Gouge
  	{28456  , "CC"},				-- Gouge
  	{16469  , "Root"},				-- Web Explosion
  	{15532  , "Root"},				-- Frost Nova
    },
  {"Stratholme",
  	{17398  , "CC"},				-- Balnazzar Transform Stun
  	{17405  , "CC"},				-- Domination
  	{17246  , "CC"},				-- Possessed
  	{19832  , "CC"},				-- Possess
  	{15655  , "CC"},				-- Shield Slam
  	{16798  , "CC"},				-- Enchanting Lullaby
  	{12542  , "CC"},				-- Fear
  	{12734  , "CC"},				-- Ground Smash
  	{17293  , "CC"},				-- Burning Winds
  	{4962   , "Root"},				-- Encasing Webs
  	{16869  , "CC"},				-- Ice Tomb
  	{17244  , "CC"},				-- Possess
  	{17307  , "CC"},				-- Knockout
  	{15970  , "CC"},				-- Sleep
  	{3589   , "Silence"},			-- Deafening Screech
    },
  {"Dire Maul",
  	{27553  , "CC"},				-- Maul
  	{22651  , "CC"},				-- Sacrifice
  	{22419  , "Disarm"},			-- Riptide
  	{22691  , "Disarm"},			-- Disarm
  	{22833  , "CC"},				-- Booze Spit (chance to hit reduced by 75%)
  	{22856  , "CC"},				-- Ice Lock
  	{16727  , "CC"},				-- War Stomp
  	{22994  , "Root"},				-- Entangle
  	{22924  , "Root"},				-- Grasping Vines
  	{22915  , "CC"},				-- Improved Concussive Shot
  	{28858  , "Root"},				-- Entangling Roots
  	{22415  , "Root"},				-- Entangling Roots
  	{22744  , "Root"},				-- Chains of Ice
  	{16838  , "Silence"},			-- Banshee Shriek
  	{22519  , "CC"},				-- Ice Nova
    },
  {"Scholomance",
  	{5708   , "CC"},				-- Swoop
  	{18144  , "CC"},				-- Swoop
  	{18103  , "CC"},				-- Backhand
  	{8208   , "CC"},				-- Backhand
  	{12461  , "CC"},				-- Backhand
  	{27565  , "CC"},				-- Banish
  	{16350  , "CC"},				-- Freeze

    --{139 , "CC", "Renew"},

  },
  {"Discovered Spells"
  },
}


local spellIds = { }
local string = { } -- used for default text storage

local defaultString = {
  ["CC"] = "Crowd Controlled",
  ["Silence"] = "Silenced",
  ["Interrupt"] = "Interrupted",
  ["Disarm"] = "Disarmed",
  ["Root"] ="Rooted",
  ["Immune"] = "Immune",
  ["Other"] = "Other",
  ["Warning"] = "Warning",
  ["Snare"] = "Snared"
}

local tabs = {
  "CC",
	"Silence",
	"Interrupt",
	"Disarm",
	"Root",
  "Immune",
  "Other",
  "Warning",
  "Snare",
}

L.spellsTable = spellsTable

local tabsIndex = {}
for i = 1, #tabs do
	tabsIndex[tabs[i]] = i
end

local DBdefaults = {
 version = 2.08,
 Scale = 1,
 xOfs = 0,
 yOfs = -30,
 point = "CENTER",
 relativePoint = "CENTER",
 LossOfControl = true,
 spellDisabled = { },
 customSpellIds = { },
 customString = { },
 priority = {		-- higher numbers have more priority; 0 = disabled
   CC = 100,
   Interrupt = 90,
   Silence = 80,
   Disarm = 60,
   Root = 50,
   Immune = 40,
   Other = 30,
   Warning = 20,
   Snare = 0,
  },
durationTime = {
  CC = 2,
  Interrupt = 2,
  Silence = 2,
  Root = 2,
  Disarm = 2,
  Immune = 2,
  Other = 2,
  Warning = 2,
  Snare = 2,
  },
}

local EasyCC = CreateFrame('Frame')
EasyCC:SetScript("OnEvent", function(frame, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		--EasyCC:cleu()
  elseif event == "LOSS_OF_CONTROL_ADDED" then
      local Index = ...
      local data = C_LossOfControl.GetActiveLossOfControlData(Index)
    	EasyCC:LossOfControl(data, Index)
  elseif event == "LOSS_OF_CONTROL_UPDATE" then
      local data = C_LossOfControl.GetActiveLossOfControlData(1)
    	EasyCC:LossOfControl(data)
  elseif event == "UNIT_AURA" and ... == "player" then
      EasyCC:PlayerAura(...)
	elseif event == "PLAYER_ENTERING_WORLD" then
		  EasyCC:OnLoad()
	elseif event == "ADDON_LOADED" and ... == addonName then
		  EasyCC:ADDON_LOADED(...)
	end
end)

 -- this is a custom function
---EasyCC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EasyCC:RegisterUnitEvent('UNIT_AURA', "player")
EasyCC:RegisterEvent("PLAYER_ENTERING_WORLD")
EasyCC:RegisterEvent("ADDON_LOADED")
EasyCC:RegisterEvent("LOSS_OF_CONTROL_ADDED")
EasyCC:RegisterEvent("LOSS_OF_CONTROL_UPDATE")


function EasyCC:LossOfControl(data, Index)
 	if not data then f:Hide(); f.priority = nil; f.startTime = nil; return end

  local customString = EasyCCDB.customString

  local locType = data.locType;
 	local spellID = data.spellID;
 	local text = data.displayText;
 	local iconTexture = data.iconTexture;
 	local startTime = data.startTime;
 	local timeRemaining = data.timeRemaining;
 	local duration = data.duration;
 	local lockoutSchool = data.lockoutSchool;
 	local priority = data.priority;
 	local displayType = data.displayType;

  string[spellID] = customString[spellID] or text

	if not spellIds[spellID] then EasyCC:NewSpell(spellID, locType) end --Need to filter out deleted spells fron DB or will keep finding same spell thats been deleted
  if locType == "SCHOOL_INTERRUPT" then

  text = strformat("%s Locked", GetSchoolString(lockoutSchool));

  if spellID then f.InterruptspellID = spellID else f.InterruptspellID = nil end
  if iconTexture then f.InterrupticonTexture = iconTexture else f.InterrupticonTexture = nil end
  if startTime then f.InterruptstartTime = startTime; else f.InterruptstartTime = nil end
  if text then f.Interrupttext = customString[spellID] or text else f.Interrupttext = nil end
  if duration then f.Interruptduration = duration else f.Interruptduration = nil end

  Ctimer(duration, function() f.InterruptspellID = nil; f.InterrupticonTexture = nil; f.InterruptstartTime = nil; f.Interruptduration = nil; f.Interrupttext = nil end)

  EasyCC:PlayerAura("player")
	end
end


function EasyCC:NewSpell(spellID, locType)
  local name, instanceType, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
  local ZoneName = GetZoneText(); local spell = GetSpellInfo(spellID); local Type
  if (locType == "STUN_MECHANIC") or (locType =="PACIFY") or (locType =="STUN") or (locType =="FEAR") or (locType =="CHARM") or (locType =="CONFUSE") or (locType =="POSSESS") or (locType =="FEAR_MECHANIC") or (locType =="FEAR") then
   Type = "CC"; print("EasyCC Discovered New CC " ..spell);
  elseif locType == "DISARM" then
   Type = "Disarm"; print("EasyCC Discovered New Disarm " ..spell);
  elseif (locType == "PACIFYSILENCE") or (locType =="SILENCE") then
   Type = "Silence"; print("EasyCC Discovered New Silence " ..spell);
  elseif locType == "SCHOOL_INTERRUPT" then
    Type = "Interrupt"; print("EasyCC Discovered New Interrupt " ..spell);
  elseif locType == "ROOT" then
    Type = "Root"; print("EasyCC Discovered New Root " ..spell);
  else
    Type = "Other"; print("EasyCC Discovered New Other " ..spell); --May Not Want to Include this based on Retail Interactions
  end
  spellIds[spellID] = Type; -- _G.EasyCCDB.spellDisabled[spell] = nil --If already delted then this will disable it
  tblinsert(EasyCCDB.customSpellIds, {spellID, Type, instanceType, nil, name.."\n"..ZoneName, "Discovered", #L.spells})
  tblinsert(L.spells[#L.spells][tabsIndex[Type]], {spellID, Type, nil, instanceType, name.."\n"..ZoneName, "Discovered", #L.spells})
  L.Spells:UpdateTab(#L.spells)
end


function EasyCC:PlayerAura(unit)
	if not EasyCCDB.LossOfControl then return end

  local priority = EasyCCDB.priority
  local disabled = EasyCCDB.spellDisabled
  local durationTime = EasyCCDB.durationTime
  local customString = EasyCCDB.customString
  local maxPriority = 1
  local maxExpirationTime = 0
  local Unique = 0
  local Icon, Duration, DurationTime, Text, Spell

  for i = 1, 40 do
    local name, icon, count, _, duration, expirationTime, source, _, _, spellId = UnitAura(unit, i, "HARMFUL")
    if not spellId then break end

    if duration == 0 and expirationTime == 0 then
    	expirationTime = GetTime() + 1 -- normal expirationTime = 0
    end

    local spellCategory = spellIds[spellId] or spellIds[name]
    local Priority = priority[spellCategory]
    local durationShow = durationTime[spellCategory]
    if ((not disabled[spellId]) and (not disabled[name])) and durationShow and durationShow > 0 then
      if Priority == maxPriority and expirationTime > maxExpirationTime then
  			maxExpirationTime = expirationTime
  			Duration = duration
        DurationTime = durationShow
  			Icon = icon
        if duration == 0 then Unique = spellId..0 else Unique = spellId..expirationTime end
        Text = customString[spellId] or customString[name] or string[spellId] or defaultString[spellCategory]
  		elseif Priority > maxPriority then
  			maxPriority = Priority
  			maxExpirationTime = expirationTime
  			Duration = duration
        DurationTime = durationShow
  			Icon = icon
        if duration == 0 then Unique = spellId..0 else Unique = spellId..expirationTime end
        Text = customString[spellId] or customString[name] or string[spellId] or defaultString[spellCategory]
  		end
    end
  end

  for i = 1, 40 do
    local name, icon, count, _, duration, expirationTime, source, _, _, spellId = UnitAura(unit, i, "HELPFULL")
    if not spellId then break end

    if duration == 0 and expirationTime == 0 then
      expirationTime = GetTime() + 1 -- normal expirationTime = 0
    end

    local spellCategory = spellIds[spellId] or spellIds[name]
    local Priority = priority[spellCategory]
    local durationShow = durationTime[spellCategory]
    if ((not disabled[spellId]) and (not disabled[name])) and durationShow and durationShow > 0 then
      if Priority == maxPriority and expirationTime > maxExpirationTime then
        maxExpirationTime = expirationTime
        Duration = duration
        DurationTime = durationShow
        Icon = icon
        if duration == 0 then Unique = spellId..0 else Unique = spellId..expirationTime end
        Text = customString[spellId] or customString[name] or string[spellId] or defaultString[spellCategory]
      elseif Priority > maxPriority then
        maxPriority = Priority
        maxExpirationTime = expirationTime
        Duration = duration
        DurationTime = durationShow
        Icon = icon
        if duration == 0 then Unique = spellId..0 else Unique = spellId..expirationTime end
        Text = customString[spellId] or customString[name] or string[spellId] or defaultString[spellCategory]
      end
    end
  end

  if f.InterruptspellID and not disabled[f.InterruptspellID] then
    local spellCategory = spellIds[f.InterruptspellID]
    local Priority = priority[spellCategory]
    local expirationTime = f.InterruptstartTime + f.Interruptduration
    local durationShow = durationTime[spellCategory]
    if Priority == maxPriority and expirationTime > maxExpirationTime and durationShow and durationShow > 0 then
      maxExpirationTime = expirationTime
      Duration = f.Interruptduration
      DurationTime = durationShow
      Icon = f.InterrupticonTexture
      Text = f.Interrupttext
      if duration == 0 then Unique = f.InterruptspellID..0 else Unique = f.InterruptspellID..expirationTime end
    elseif Priority > maxPriority and durationShow and durationShow > 0 then
      maxPriority = Priority
      maxExpirationTime = expirationTime
      Duration = f.Interruptduration
      DurationTime = durationShow
      Icon = f.InterrupticonTexture
      Text = f.Interrupttext
      if duration == 0 then Unique = f.InterruptspellID..0 else Unique = f.InterruptspellID..expirationTime end
      end
  end

  if DurationTime == 2 then DurationTime = true elseif DurationTime == 1 then DurationTime = false end

	if (maxExpirationTime == 0) then -- no (de)buffs found
    self.maxExpirationTime = 0; self.Unique = 0
    if f:IsShown() then
			f:Hide()
		end
  elseif maxExpirationTime ~= self.maxExpirationTime and Unique ~= self.Unique then -- new debuff found
    self.maxExpirationTime = maxExpirationTime; self.Unique = Unique
    local StartTime = maxExpirationTime - Duration
    EasyCC:Display(Icon, StartTime, Duration, Text, DurationTime)
  end
end

function EasyCC:Display(icon, startTime, duration, string, durationDisplay)
	if self.test then
    f.displayTime = duration; f.startTime = GetTime()
  elseif durationDisplay then
    f.displayTime = duration; f.startTime = startTime
  else
    f.displayTime = fadeTime; f.startTime = startTime
  end
	if string then
		f.Ltext:SetText(string)
	end
	if icon then --icon control here
		f.Icon.texture:SetTexture(icon)
	else
		f.Icon.texture:SetTexture(136235)
	end
	if duration and duration ~= 0 then --duration control here
    f.TimeSinceLastUpdate = 0
		f.Icon.cooldown:SetCooldown(startTime, duration)
		f.Icon.cooldown:SetSwipeColor(0, 0, 0, 1)
		f.Ltext:ClearAllPoints()
		f.timer:ClearAllPoints()
		f.Ltext:SetPoint("LEFT", f.Icon, "RIGHT", 5, 9)
	  f.timer:SetPoint("LEFT", f.Icon, "RIGHT", 5, -14)
		f.timer:Show()
	else -- no druation
    f.TimeSinceLastUpdate = 0
    if not durationDisplay then f.displayTime = fadeTime else f.displayTime = GetTime() + 1 end
		f.Icon.cooldown:SetCooldown(GetTime(), 0)
		f.Icon.cooldown:SetSwipeColor(0, 0, 0, 0)
		f.Ltext:ClearAllPoints()
		f.Ltext:SetPoint("LEFT", f.Icon, "RIGHT", 7.5, 0)
		f.timer:Hide()
	end
  if IsAddOnLoaded("BambiUI") then
		point, relativeTo, relativePoint, xOfs, yOfs = PartyAnchor5:GetPoint()
		EasyCCDB.point = "CENTER"; EasyCCDB.relativePoint = "CENTER"; EasyCCDB.yOfs = yOfs; EasyCCDB.xOfs = 0;
  end
	f.barB.texture:SetWidth(f.Icon:GetWidth() + (strlen(f.Ltext:GetText()) * 21))
	f.barU.texture:SetWidth(f.Icon:GetWidth() + (strlen(f.Ltext:GetText()) * 21))
	f.barU.texture:ClearAllPoints()
	f.barB.texture:ClearAllPoints()
	f.barU.texture:SetPoint("BOTTOM", f, "TOP", 0, 4)
	f.barB.texture:SetPoint("TOP", f, "BOTTOM", 0, -4)
	f:SetWidth(f.Icon:GetWidth() + (strlen(f.Ltext:GetText()) * 16))
  f.backgroundTexture:SetWidth(f.Icon:GetWidth() + (strlen(f.Ltext:GetText()) * 16))
	f:ClearAllPoints()
  f:SetPoint(
    EasyCCDB.point or "CENTER",
    UIParent,
    EasyCCDB.relativePoint or "CENTER",
    EasyCCDB.xOfs or 0,
    EasyCCDB.yOfs or 0
  )
	f:Show()
end

function EasyCC:StopMoving()
	f.point, f.anchor, f.relativePoint, f.x, f.y = f:GetPoint()
	if not f.anchor then
	f:ClearAllPoints()
	f:SetPoint(
		f.point or "CENTER",
		UIParent,
		f.relativePoint or "CENTER",
		f.x or 0,
		f.y or 0
	)
  end
  EasyCCDB.point = f.point; EasyCCDB.relativePoint = f.relativePoint; EasyCCDB.yOfs = f.y; EasyCCDB.xOfs = f.x
	self:StopMovingOrSizing()
end

function EasyCC:OnLoad()
	if not f then --create the frame
		f = CreateFrame("Frame")
		f:SetScale(EasyCCDB.Scale)
		f:SetParent(UIParent)
		f:SetFrameStrata("HIGH")
		f:SetHeight(hieght)

    f.backgroundTexture = f:CreateTexture(nil, "BACKGROUND")
    f.backgroundTexture:SetTexture("Interface\\Cooldown\\LoC-ShadowBG")
    f.backgroundTexture:SetPoint("CENTER", f, "CENTER", 0, 0)
    f.backgroundTexture:SetHeight(hieght + 8)
    f.backgroundTexture:SetVertexColor(1, 1, 1, 0.5)

		f.Icon = CreateFrame("Frame", "f.Icon")
		f.Icon:SetHeight(hieght)
		f.Icon:SetWidth(width)
		f.Icon:SetParent(f)
		f.Icon:ClearAllPoints()
		f.Icon:SetPoint("LEFT", f, "LEFT", 0, 0)

		f.Icon.texture = f.Icon:CreateTexture(f.Icon, 'BACKGROUND')
		f.Icon.texture:SetAllPoints(f.Icon)

		f.Icon.cooldown = CreateFrame("Cooldown", "BambiUIInterrupt", f.Icon, 'CooldownFrameTemplate')
		f.Icon.cooldown:SetAllPoints(f.Icon)
		f.Icon.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")    --("Interface\\Cooldown\\edge-LoC") Blizz CD
		f.Icon.cooldown:SetDrawSwipe(true)
		f.Icon.cooldown:SetDrawEdge(true)
		f.Icon.cooldown:SetSwipeColor(0, 0, 0, 1)
		f.Icon.cooldown:SetReverse(false) --will reverse the swipe if actionbars or debuff, by default bliz sets the swipe to actionbars if this = true it will be set to debuffs
		f.Icon.cooldown:SetDrawBling(true)
		f.Icon.cooldown:SetHideCountdownNumbers(true)

		f.Ltext = f.Icon:CreateFontString(nil, "ARTWORK")
		f.Ltext:SetFont(STANDARD_TEXT_FONT, 24, "THICKOUTLINE")
		f.Ltext:SetTextColor(1, .75, 0, 1)
		f.Ltext:SetJustifyH("LEFT")
		f.Ltext:SetParent(f.Icon)
		f.Ltext:SetJustifyH("LEFT")

		f.timer = f.Icon:CreateFontString(nil, "ARTWORK")
		f.timer:SetParent(f.Icon)
		f.timer:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")

		local ONUPDATE_INTERVAL = 1;

		f.barU = CreateFrame("Frame", "f.barU")
		f.barU.texture = f.barU:CreateTexture(f.barU, 'BACKGROUND')
		f.barU.texture:SetTexture("Interface\\Cooldown\\Loc-RedLine")

		f.barU.texture:SetHeight(17)
		f.barU.texture:SetParent(f)

		f.barB = CreateFrame("Frame", "f.barU")
		f.barB.texture = f.barB:CreateTexture(f.barB, 'BACKGROUND')
		f.barB.texture:SetTexture("Interface\\Cooldown\\Loc-RedLine")
    --f.barB.texture:SetDesaturated(1) --sets the border green
    --f.barB.texture:SetVertexColor(0, 1, 0, 1) --sets the border green
		f.barB.texture:SetHeight(17)
		f.barB.texture:SetParent(f)
		f.barB.texture:SetRotation(math.rad(180))

    f.displayTime = fadeTime -- Default Timer Display
    f.TimeSinceLastUpdate = 0
		-- The number of seconds since the last update, script to set the duration to show before fading
		f.Icon:SetScript("OnUpdate", function(self, elapsed)
			if f.startTime then
        local timeRemaining = f.startTime - GetTime() + (f.Icon.cooldown:GetCooldownDuration()/1000)
        if ( timeRemaining >= 60 ) then
           local number = strformat("%.1f", timeRemaining/60)
           f.timer:SetText(number .." minutes")
        elseif ( timeRemaining >= 10 ) then
          local number = strformat("%d", timeRemaining)
          f.timer:SetText(number .." seconds")
        elseif (timeRemaining < 9.95) then -- From 9.95 to 9.99 it will print 10.0 instead of 9.9
          local number = strformat("%.1F", timeRemaining);
          f.timer:SetText(number .." seconds")
        end
      end
			--text:SetText(string.format("%.1f", start - GetTime() + (f.Icon.cooldown:GetCooldownDuration()/1000)) .." seconds")
			f.TimeSinceLastUpdate = f.TimeSinceLastUpdate + elapsed
			if f.TimeSinceLastUpdate >= f.displayTime then
				f.TimeSinceLastUpdate = 0
				if f and f:IsShown() then f:Hide() end
	      if EasyCC.test then EasyCC:toggletest() end
			end
		end)
		-- When the frame is shown, reset the update f.timer
		f.Icon:SetScript("OnShow", function(self)
			f.TimeSinceLastUpdate = 0
		end)
		f:SetScript("OnEvent", self.OnEvent)
		f:SetScript("OnDragStart", self.StartMoving) -- this function is already built into the Frame class
		f:SetScript("OnDragStop", self.StopMoving)
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Type \"/ecc\"")
	end
end


function EasyCC:ADDON_LOADED(arg1)
	if arg1 == addonName then
		if (_G.EasyCCDB == nil) or (_G.EasyCCDB.version == nil) then
			_G.EasyCCDB = CopyTable(DBdefaults)
			print("EasyCC Defaults Loaded.")
	  elseif _G.EasyCCDB.version < DBdefaults.version then
			print("EasyCC Version ".._G.EasyCCDB.version.." Updated to "..DBdefaults.version)
			for j, u in pairs(DBdefaults) do
				if _G.EasyCCDB[j] == nil then
					_G.EasyCCDB[j] = u
        elseif type(u) == "table" then
          for k, v in pairs(u) do
            if _G.EasyCCDB[j][k] == nil then
              _G.EasyCCDB[j][k] = v
            end
          end
        end
			end
		end
    EasyCCDB = _G.EasyCCDB
    self:CompileSpells()
    L.Spells:Addon_Load()
	end
end


function EasyCC:CompileSpells(typeUpdate)
		spellIds = {}
    local	spells = {}
    local spellList = {}
    local hash = {}
    local customSpells = {}
    local toremove = {}

    for i = 1, (#spellsTable) do
   		for l = 2, #spellsTable[i] do
        local spellID, prio, string = unpack(spellsTable[i][l])
        if string and not _G.EasyCCDB.customString[spellID] then
          _G.EasyCCDB.customString[spellID] = string
        end
      end
    end

		--Build Custom Table for Check
		for k, v in ipairs(_G.EasyCCDB.customSpellIds) do
			local spellID, prio, _, _, _, _, tabId  = unpack(v)
			customSpells[spellID] = {spellID, prio, tabId, k}
		end
		--Build the Spells Table
		for i = 1, (#spellsTable) do
			if spells[i] == nil then
		    spells[i] = {}
			end
	    for l = 1, (#tabs) do
				if spells[i][l] == nil then
					spells[i][l] = {}
	    	end
			end
		end
		--Sort the spells
		for i = 1, (#spellsTable) do
   		for l = 2, #spellsTable[i] do
				local spellID, prio = unpack(spellsTable[i][l])
        if prio == "CC" or prio == "Interrupt" or prio == "Silence" or prio == "Root" or prio == "Disarm" or prio == "Immune" or prio == "Other"  or prio == "Warning"  or prio == "Snare" then
          tblinsert(spells[i][tabsIndex[prio]], ({spellID, prio}))
  				spellList[spellID] = true
        end
			end
		end

  	L.spellList = spellList
    --Cleans Up All Spells
    for i = 1, (#spells) do
      for l = 1, (#spells[i]) do
        local removed = 0
        for x = 1, (#spells[i][l]) do
          local spellID, prio = unpack(spells[i][l][x])
          if (not hash[spellID]) and (not customSpells[spellID]) then
            hash[spellID] = {spellID, prio}
          else
            if customSpells[spellID] then
              local CspellID, Cprio, CtabId, Ck = unpack(customSpells[spellID])
              if CspellID == spellID and Cprio == prio and CtabId == i then
              tblremove(_G.EasyCCDB.customSpellIds, Ck)
              print("|cff00ccffEasyCC|r : "..spellID.." : "..prio.." |cff009900Restored to Orginal Value|r")
              elseif CspellID == spellID and CtabId == #spells then
              tblremove(_G.EasyCCDB.customSpellIds, Ck)
              print("|cff00ccffEasyCC|r : "..spellID.." : "..prio.." |cff009900Added from Discovered Spells to Database (Reconfigure if Needed)|r")
              else
                if type(spellID) == "number" then
                  if GetSpellInfo(spellID) then
                    local name = GetSpellInfo(spellID) or "Unknnown"
                    --print("|cff00ccffEasyCC|r : "..CspellID.." : "..Cprio.." ("..name..") Modified Spell ".."|cff009900Removed |r"  ..spellID.." |cff009900: |r"..prio)
                  end
                else
                    --print("|cff00ccffEasyCC|r : "..CspellID.." : "..Cprio.." (not spellId) Modified Spell ".."|cff009900Removed |r"  ..spellID.." |cff009900: |r"..prio)
                end
                tblinsert(toremove, {i , l, x, removed, spellID})
                removed = removed + 1
              end
            else
              local HspellID, Hprio = unpack(hash[spellID])
              if type(spellID) == "number" then
                  local name = GetSpellInfo(spellID) or "Unknnown"
                  --print("|cff00ccffEasyCC|r : "..HspellID.." : "..Hprio.." ("..name..") ".."|cffff0000Duplicate Spell in Lua |r".."|cff009900Removed |r"  ..spellID.." |cff009900: |r"..prio)
              else
                  --print("|cff00ccffEasyCC|r : "..HspellID.." : "..Hprio.." (not spellId) ".."|cff009900Duplicate Spell in Lua |r".."|cff009900Removed |r"  ..spellID.." |cff009900: |r"..prio)
              end
              tblinsert(toremove, {i , l, x, removed, spellID})
              removed = removed + 1
            end
          end
        end
      end
    end
    --Now Remove all the Duplicates and Custom Spells
    for k, v in ipairs(toremove) do
    local i, l, x, r, s = unpack(v)
    tblremove(spells[i][l], x - r)
    end
	  	--ReAdd all dbCustom Spells to spells
			for k, v in ipairs(_G.EasyCCDB.customSpellIds) do
				local spellID, prio, string, instanceType, zone, customname, tab = unpack(v)
				if prio ~= "Delete" then
          if customname == "Discovered" then tab = #spells end
					if position then
          	tblinsert(spells[tab][position], 1, v)
					else
            tblinsert(spells[tab][tabsIndex[prio]], 1, v) --v[7]: Category to enter spell / v[8]: Tab to update / v[9]: Table
					end
				end
			end
  	--Make spellIds from Spells for AuraFilter to check
		for i = 1, #spells do
			for l = 1, #spells[i] do
				for x = 1, #spells[i][l] do
					spellIds[spells[i][l][x][1]] = spells[i][l][x][2]
				end
			end
		end
		L.spells = spells
		L.spellIds = spellIds
		--check for any 1st time spells being added and set to On

    if EasyCCDB.LossOfControl then SetCVar("lossOfControl", 1) else SetCVar("lossOfControl", 0) end
    if EasyCCDB.durationTime["CC"] == 2 then SetCVar("lossOfControlFull", 2) elseif EasyCCDB.durationTime["CC"] == 1 then SetCVar("lossOfControlFull", 1) else SetCVar("lossOfControlFull", 0) end
    if EasyCCDB.durationTime["Silence"] == 2 then SetCVar("lossOfControlSilence", 2) elseif EasyCCDB.durationTime["Silence"] == 1 then SetCVar("lossOfControlSilence", 1) else SetCVar("lossOfControlSilence", 0) end
    if EasyCCDB.durationTime["Interrupt"] == 2 then SetCVar("lossOfControlInterrupt", 2) elseif EasyCCDB.durationTime["Interrupt"] == 1 then SetCVar("lossOfControlInterrupt", 1) else SetCVar("lossOfControlInterrupt", 0) end
    if EasyCCDB.durationTime["Disarm"] == 2 then SetCVar("lossOfControlDisarm", 2) elseif EasyCCDB.durationTime["Disarm"] == 1 then SetCVar("lossOfControlDisarm", 1) else SetCVar("lossOfControlDisarm", 0) end
    if EasyCCDB.durationTime["Root"] == 2 then SetCVar("lossOfControlRoot", 2) elseif EasyCCDB.durationTime["Root"]  == 1 then SetCVar("lossOfControlRoot", 1) else SetCVar("lossOfControlRoot", 0) end
end


local teststring = {"Holy Locked", "Polymorph", "Shadow Locked", "Stunned", "Feared"}
local mytime = {30, 25, 30, 15, 25, 20, 30}


function EasyCC:toggletest()
	if not self.test then
		self.test = true
		local string = teststring[ math.random( #teststring )]
    local keys = {} -- for random icon sillyness
    for k in pairs(spellIds) do
      tinsert(keys, k)
    end
    local _, _, icon = GetSpellInfo(keys[random(#keys)])
		EasyCC:Display(icon, GetTime(), mytime[ math.random( #mytime ) ], string )
		f:SetMovable(true)
		f:RegisterForDrag("LeftButton")
		f:EnableMouse(true)
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Test Mode On")
	else
		self.test = nil
		f:EnableMouse(false)
		f:RegisterForDrag()
		f:SetMovable(false)
    f.TimeSinceLastUpdate = 0
    if f and f:IsShown() then f:Hide() end
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Test Mode Off")
	end
end

---------------------------------------------------------------------------------------------------------------

local O = addonName .. "OptionsPanel"

local function CreateSlider(text, parent, low, high, step, globalName)
	local name = globalName or (parent:GetName() .. text)
	local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
	slider:SetHeight(8)
	slider:SetWidth(150)
	slider:SetScale(.9)
	slider:SetMinMaxValues(low, high)
	slider:SetValueStep(step)
	slider:SetObeyStepOnDrag(obeyStep)
	--_G[name .. "Text"]:SetText(text)
	_G[name .. "Low"]:SetText("")
	_G[name .. "High"]:SetText("")
	return slider
end

local OptionsPanel = CreateFrame("Frame", O)
OptionsPanel.name = addonName

local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetFont("Fonts\\FRIZQT__.TTF", 30 )
title:SetText(addonName)
title:SetPoint("TOPLEFT", 15, -15)

local BambiText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
BambiText:SetFont("Fonts\\MORPHEUS.ttf", 16 )
BambiText:SetText("By ".."|cff00ccffBambi|r")
BambiText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 65, 1)

local Spells = CreateFrame("Button", O.."Spells", OptionsPanel, "OptionsButtonTemplate")
_G[O.."Spells"]:SetText("Customize Any Spells")
Spells:SetHeight(28)
Spells:SetWidth(200)
Spells:SetScale(1)
Spells:SetScript("OnClick", function(self) L.Spells:Toggle() end)
Spells:SetPoint("LEFT", title, "RIGHT", 90, 3)

local SpellText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
SpellText:SetFont("Fonts\\FRIZQT__.TTF", 11 )
SpellText:SetText("Fully Customize Any Default Spell or Add Any Spell by Name or SpellId \n\n1: Add spells with Custom Text and Priority \n2: Delete or hide any spell in game \n3: Check out the discovered tab for spells found while playing\n \n ")
SpellText:SetJustifyH("LEFT")
SpellText:SetPoint("TOPLEFT", Spells, "BOTTOMRIGHT", -197, -5)

local unlocknewline = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
unlocknewline:SetFont("Fonts\\FRIZQT__.TTF", 16 )
unlocknewline:SetText(" (drag to move)")

-- "Unlock" checkbox - allow the frames to be moved
local Unlock = CreateFrame("CheckButton", O.."Unlock", OptionsPanel, "OptionsCheckButtonTemplate")
function Unlock:OnClick()
	if self:GetChecked() then
		unlocknewline:SetPoint("LEFT", Unlock, "RIGHT", 40, 0)
		unlocknewline:Show()
		EasyCC:toggletest()
	else
		unlocknewline:Hide()
    EasyCC:toggletest()
	end
end
Unlock:SetScript("OnClick", Unlock.OnClick)
Unlock:SetPoint("TOPLEFT",  title, "BOTTOMLEFT", 0, -22)

local unlock = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
unlock:SetFont("Fonts\\FRIZQT__.TTF", 18 )
unlock:SetText("Test")
unlock:SetPoint("LEFT", Unlock, "RIGHT", 6, 0)

local Scale
Scale = CreateSlider("EasyCC Scale", OptionsPanel, .5, 1.5, .01, "EasyCC Scale")
Scale:SetScript("OnValueChanged", function(self, value)
Scale:SetScale(1)
Scale:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("EasyCC Scale" .. " (" .. ("%.2f"):format(value) .. ")")
	f:SetScale(EasyCCDB.Scale)
	EasyCCDB.Scale = ("%.2f"):format(value)-- the real alpha value
end)

local LossOfControlFull
LossOfControlFull = CreateSlider("LossOfControlFull", OptionsPanel, 0, 2, 1, "LossOfControlFull")
LossOfControlFull:SetScript("OnValueChanged", function(self, value)
LossOfControlFull:SetScale(1)
LossOfControlFull:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType Full CC".. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.durationTime["CC"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
	SetCVar("lossOfControlFull", mathfloor(tonumber(("%.0f"):format(value))))
end)

local LossOfControlSilence
LossOfControlSilence = CreateSlider("LossOfControlSilence", OptionsPanel, 0, 2, 1, "LossOfControlSilence")
LossOfControlSilence:SetScript("OnValueChanged", function(self, value)
LossOfControlSilence:SetScale(1)
LossOfControlSilence:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Silence" .. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.durationTime["Silence"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
	SetCVar("lossOfControlSilence", mathfloor(tonumber(("%.0f"):format(value))))
end)

local LossOfControlInterrupt
LossOfControlInterrupt = CreateSlider("LossOfControlInterrupt", OptionsPanel, 0, 2, 1, "LossOfControlInterrupt")
LossOfControlInterrupt:SetScript("OnValueChanged", function(self, value)
LossOfControlInterrupt:SetScale(1)
LossOfControlInterrupt:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Interrupt" .. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.durationTime["Interrupt"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
	SetCVar("lossOfControlInterrupt", mathfloor(tonumber(("%.0f"):format(value))))
end)

local LossOfControlDisarm
LossOfControlDisarm = CreateSlider("LossOfControlDisarm", OptionsPanel, 0, 2, 1, "LossOfControlDisarm")
LossOfControlDisarm:SetScript("OnValueChanged", function(self, value)
LossOfControlDisarm:SetScale(1)
LossOfControlDisarm:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Disarm" .. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.durationTime["Disarm"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
	SetCVar("lossOfControlDisarm", mathfloor(tonumber(("%.0f"):format(value))))
end)

local LossOfControlRoot
LossOfControlRoot = CreateSlider("LossOfControlRoot", OptionsPanel, 0, 2, 1, "LossOfControlRoot")
LossOfControlRoot:SetScript("OnValueChanged", function(self, value)
LossOfControlRoot:SetScale(1)
LossOfControlRoot:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Root" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.durationTime["Root"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
	SetCVar("lossOfControlRoot", mathfloor(tonumber(("%.0f"):format(value))))
end)

local LossOfControlImmune
LossOfControlImmune = CreateSlider("LossOfControlImmune", OptionsPanel, 0, 2, 1, "LossOfControlImmune")
LossOfControlImmune:SetScript("OnValueChanged", function(self, value)
LossOfControlImmune:SetScale(1)
LossOfControlImmune:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Immune" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.durationTime["Immune"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local LossOfControlOther
LossOfControlOther = CreateSlider("LossOfControlOther", OptionsPanel, 0, 2, 1, "LossOfControlOther")
LossOfControlOther:SetScript("OnValueChanged", function(self, value)
LossOfControlOther:SetScale(1)
LossOfControlOther:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Other" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.durationTime["Other"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local LossOfControlWarning
LossOfControlWarning = CreateSlider("LossOfControlWarning", OptionsPanel, 0, 2, 1, "LossOfControlWarning")
LossOfControlWarning:SetScript("OnValueChanged", function(self, value)
LossOfControlWarning:SetScale(1)
LossOfControlWarning:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType  Warning" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.durationTime["Warning"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local LossOfControlSnare
LossOfControlSnare = CreateSlider("LossOfControlSnare", OptionsPanel, 0, 2, 1, "LossOfControlSnare")
LossOfControlSnare:SetScript("OnValueChanged", function(self, value)
LossOfControlSnare:SetScale(1)
LossOfControlSnare:SetWidth(175)
	_G[self:GetName() .. "Text"]:SetText("DisplayType Snare" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.durationTime["Snare"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityFull
PriorityFull = CreateSlider("PriorityFull", OptionsPanel, 0, 100, 1, "PriorityFull")
PriorityFull:SetScript("OnValueChanged", function(self, value)
PriorityFull:SetScale(1)
PriorityFull:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority Full CC".. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.priority["CC"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PrioritySilence
PrioritySilence = CreateSlider("PrioritySilence", OptionsPanel, 0, 100, 1, "PrioritySilence")
PrioritySilence:SetScript("OnValueChanged", function(self, value)
PrioritySilence:SetScale(1)
PrioritySilence:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Silence" .. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.priority["Silence"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityInterrupt
PriorityInterrupt = CreateSlider("PriorityInterrupt", OptionsPanel, 0, 100, 1, "PriorityInterrupt")
PriorityInterrupt:SetScript("OnValueChanged", function(self, value)
PriorityInterrupt:SetScale(1)
PriorityInterrupt:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Interrupt" .. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.priority["Interrupt"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityDisarm
PriorityDisarm = CreateSlider("PriorityDisarm", OptionsPanel, 0, 100, 1, "PriorityDisarm")
PriorityDisarm:SetScript("OnValueChanged", function(self, value)
PriorityDisarm:SetScale(1)
PriorityDisarm:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Disarm" .. " (" .. ("%.0f"):format(value) .. ")")
  EasyCCDB.priority["Disarm"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityRoot
PriorityRoot = CreateSlider("PriorityRoot", OptionsPanel, 0, 100, 1, "PriorityRoot")
PriorityRoot:SetScript("OnValueChanged", function(self, value)
PriorityRoot:SetScale(1)
PriorityRoot:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Root" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.priority["Root"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityImmune
PriorityImmune = CreateSlider("PriorityImmune", OptionsPanel, 0, 100, 1, "PriorityImmune")
PriorityImmune:SetScript("OnValueChanged", function(self, value)
PriorityImmune:SetScale(1)
PriorityImmune:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Immune" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.priority["Immune"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityOther
PriorityOther = CreateSlider("PriorityOther", OptionsPanel, 0, 100, 1, "PriorityOther")
PriorityOther:SetScript("OnValueChanged", function(self, value)
PriorityOther:SetScale(1)
PriorityOther:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Other" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.priority["Other"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PriorityWarning
PriorityWarning = CreateSlider("PriorityWarning", OptionsPanel, 0, 100, 1, "PriorityWarning")
PriorityWarning:SetScript("OnValueChanged", function(self, value)
PriorityWarning:SetScale(1)
PriorityWarning:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority  Warning" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.priority["Warning"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local PrioritySnare
PrioritySnare = CreateSlider("PrioritySnare", OptionsPanel, 0, 100, 1, "PrioritySnare")
PrioritySnare:SetScript("OnValueChanged", function(self, value)
PrioritySnare:SetScale(1)
PrioritySnare:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("Priority Snare" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.priority["Snare"] = mathfloor(tonumber(("%.0f"):format(value)))-- the real alpha value
end)

local LossOfControl
LossOfControl = CreateFrame("CheckButton", O.."LossOfControl", OptionsPanel, "OptionsCheckButtonTemplate")
LossOfControl:SetScale(1)
LossOfControl:SetHitRectInsets(0, 0, 0, 0)
_G[O.."LossOfControlText"]:SetText("LossOfControl")
LossOfControl:SetScript("OnClick", function(self)
	EasyCCDB.LossOfControl = self:GetChecked()
	if (self:GetChecked()) then
		SetCVar("LossOfControl", 1)
		BlizzardOptionsPanel_Slider_Enable(LossOfControlInterrupt)
		BlizzardOptionsPanel_Slider_Enable(LossOfControlFull)
		BlizzardOptionsPanel_Slider_Enable(LossOfControlSilence)
		BlizzardOptionsPanel_Slider_Enable(LossOfControlDisarm)
		BlizzardOptionsPanel_Slider_Enable(LossOfControlRoot)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlImmune)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlOther)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlWarning)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlSnare)
    BlizzardOptionsPanel_Slider_Enable(PriorityInterrupt)
    BlizzardOptionsPanel_Slider_Enable(PriorityFull)
    BlizzardOptionsPanel_Slider_Enable(PrioritySilence)
    BlizzardOptionsPanel_Slider_Enable(PriorityDisarm)
    BlizzardOptionsPanel_Slider_Enable(PriorityRoot)
    BlizzardOptionsPanel_Slider_Enable(PriorityImmune)
    BlizzardOptionsPanel_Slider_Enable(PriorityOther)
    BlizzardOptionsPanel_Slider_Enable(PriorityWarning)
    BlizzardOptionsPanel_Slider_Enable(PrioritySnare)
	else
		SetCVar("LossOfControl", 0)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlInterrupt)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlFull)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlSilence)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlDisarm)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlRoot)
    BlizzardOptionsPanel_Slider_Disable(LossOfControlImmune)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlOther)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlWarning)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlSnare)
    BlizzardOptionsPanel_Slider_Disable(PriorityInterrupt)
    BlizzardOptionsPanel_Slider_Disable(PriorityFull)
    BlizzardOptionsPanel_Slider_Disable(PrioritySilence)
    BlizzardOptionsPanel_Slider_Disable(PriorityDisarm)
    BlizzardOptionsPanel_Slider_Disable(PriorityRoot)
    BlizzardOptionsPanel_Slider_Disable(PriorityImmune)
    BlizzardOptionsPanel_Slider_Disable(PriorityOther)
    BlizzardOptionsPanel_Slider_Disable(PriorityWarning)
    BlizzardOptionsPanel_Slider_Disable(PrioritySnare)
	end
end)

if Unlock then Unlock:SetPoint("TOPLEFT",  title, "BOTTOMLEFT", 0, -30) end
if Scale then Scale:SetPoint("TOPLEFT", Unlock, "BOTTOMLEFT", 5, -30) end
if LossOfControl then LossOfControl:SetPoint("TOPLEFT", Scale, "BOTTOMLEFT", 5, -15) end

if PriorityFull then PriorityFull:SetPoint("TOPLEFT", LossOfControl, "BOTTOMLEFT", 0, -22.5) end
if PrioritySilence then PrioritySilence:SetPoint("TOPLEFT", PriorityFull, "BOTTOMLEFT", 0, -25) end
if PriorityInterrupt then PriorityInterrupt:SetPoint("TOPLEFT", PrioritySilence, "BOTTOMLEFT", 0, -25) end
if PriorityDisarm then PriorityDisarm:SetPoint("TOPLEFT", PriorityInterrupt, "BOTTOMLEFT", 0, -25) end
if PriorityRoot then PriorityRoot:SetPoint("TOPLEFT", PriorityDisarm, "BOTTOMLEFT", 0, -25) end
if PriorityImmune then PriorityImmune:SetPoint("TOPLEFT", PriorityRoot, "BOTTOMLEFT", 0, -25) end
if PriorityOther then PriorityOther:SetPoint("TOPLEFT", PriorityImmune, "BOTTOMLEFT", 0, -25) end
if PriorityWarning then PriorityWarning:SetPoint("TOPLEFT", PriorityOther, "BOTTOMLEFT", 0, -25) end
if PrioritySnare then PrioritySnare:SetPoint("TOPLEFT", PriorityWarning, "BOTTOMLEFT", 0, -25) end

if LossOfControlFull then LossOfControlFull:SetPoint("TOPLEFT", LossOfControl, "BOTTOMLEFT", 250, -22.5) end
if LossOfControlSilence then LossOfControlSilence:SetPoint("TOPLEFT", LossOfControlFull, "BOTTOMLEFT", 0, -25) end
if LossOfControlInterrupt then LossOfControlInterrupt:SetPoint("TOPLEFT", LossOfControlSilence, "BOTTOMLEFT", 0, -25) end
if LossOfControlDisarm then LossOfControlDisarm:SetPoint("TOPLEFT", LossOfControlInterrupt, "BOTTOMLEFT", 0, -25) end
if LossOfControlRoot then LossOfControlRoot:SetPoint("TOPLEFT", LossOfControlDisarm, "BOTTOMLEFT", 0, -25) end
if LossOfControlImmune then LossOfControlImmune:SetPoint("TOPLEFT", LossOfControlRoot, "BOTTOMLEFT", 0, -25) end
if LossOfControlOther then LossOfControlOther:SetPoint("TOPLEFT", LossOfControlImmune, "BOTTOMLEFT", 0, -25) end
if LossOfControlWarning then LossOfControlWarning:SetPoint("TOPLEFT", LossOfControlOther, "BOTTOMLEFT", 0, -25) end
if LossOfControlSnare then LossOfControlSnare:SetPoint("TOPLEFT", LossOfControlWarning, "BOTTOMLEFT", 0, -25) end

local PLoCOptions = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
PLoCOptions:SetFont("Fonts\\FRIZQT__.TTF", 11 )
PLoCOptions:SetText("|cffff00000:|r Disables Icon Type \n#: Sets the priority for each spell category \n|cff00ff00#:|r Higher numbers have more priority\n \n ")
PLoCOptions:SetJustifyH("LEFT")
PLoCOptions:SetPoint("TOPLEFT", PrioritySnare, "TOPLEFT", 0, -25)

local LoCOptions = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
LoCOptions:SetFont("Fonts\\FRIZQT__.TTF", 11 )
LoCOptions:SetText("|cffff00000:|r Disables Icon Type \n1: Shows Icon Alert (2 Seconds) \n|cff00ff002:|r Shows Icon for the Full Duration\n \n ")
LoCOptions:SetJustifyH("LEFT")
LoCOptions:SetPoint("TOPLEFT", LossOfControlSnare, "TOPLEFT", 0, -25)

-------------------------------------------------------------------------------
OptionsPanel.default = function() -- This method will run when the player clicks "defaults"
  if not LossOfControl:GetChecked() then
    BlizzardOptionsPanel_Slider_Enable(LossOfControlInterrupt)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlFull)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlSilence)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlDisarm)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlRoot)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlInterrupt)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlFull)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlSilence)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlDisarm)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlRoot)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlImmune)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlOther)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlWarning)
    BlizzardOptionsPanel_Slider_Enable(LossOfControlSnare)
    BlizzardOptionsPanel_Slider_Enable(PriorityInterrupt)
    BlizzardOptionsPanel_Slider_Enable(PriorityFull)
    BlizzardOptionsPanel_Slider_Enable(PrioritySilence)
    BlizzardOptionsPanel_Slider_Enable(PriorityDisarm)
    BlizzardOptionsPanel_Slider_Enable(PriorityRoot)
    BlizzardOptionsPanel_Slider_Enable(PriorityInterrupt)
    BlizzardOptionsPanel_Slider_Enable(PriorityFull)
    BlizzardOptionsPanel_Slider_Enable(PrioritySilence)
    BlizzardOptionsPanel_Slider_Enable(PriorityDisarm)
    BlizzardOptionsPanel_Slider_Enable(PriorityRoot)
    BlizzardOptionsPanel_Slider_Enable(PriorityImmune)
    BlizzardOptionsPanel_Slider_Enable(PriorityOther)
    BlizzardOptionsPanel_Slider_Enable(PriorityWarning)
    BlizzardOptionsPanel_Slider_Enable(PrioritySnare)
  end

	L.Spells:ResetAllSpellList()
	_G.EasyCCDB = nil
	L.Spells:WipeAll()
	EasyCC:ADDON_LOADED(addonName)
	L.Spells:UpdateAll()

  if EasyCC.test then EasyCC:toggletest() end
  print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Reset")
end

OptionsPanel.refresh = function()
	 -- This method will run when the Interface Options frame calls its OnShow function and after defaults have been applied via the panel.default method described above.
	LossOfControl:SetChecked(EasyCCDB.LossOfControl)
	LossOfControlInterrupt:SetValue(EasyCCDB.durationTime["Interrupt"])
	LossOfControlFull:SetValue(EasyCCDB.durationTime["CC"])
	LossOfControlSilence:SetValue(EasyCCDB.durationTime["Silence"])
	LossOfControlDisarm:SetValue(EasyCCDB.durationTime["Disarm"])
	LossOfControlRoot:SetValue(EasyCCDB.durationTime["Root"])
  LossOfControlImmune:SetValue(EasyCCDB.durationTime["Immune"])
  LossOfControlOther:SetValue(EasyCCDB.durationTime["Other"])
  LossOfControlWarning:SetValue(EasyCCDB.durationTime["Warning"])
  LossOfControlSnare:SetValue(EasyCCDB.durationTime["Snare"])

  PriorityInterrupt:SetValue(EasyCCDB.priority["Interrupt"])
  PriorityFull:SetValue(EasyCCDB.priority["CC"])
  PrioritySilence:SetValue(EasyCCDB.priority["Silence"])
  PriorityDisarm:SetValue(EasyCCDB.priority["Disarm"])
  PriorityRoot:SetValue(EasyCCDB.priority["Root"])
  PriorityImmune:SetValue(EasyCCDB.priority["Immune"])
  PriorityOther:SetValue(EasyCCDB.priority["Other"])
  PriorityWarning:SetValue(EasyCCDB.priority["Warning"])
  PrioritySnare:SetValue(EasyCCDB.priority["Snare"])

	Scale:SetValue(EasyCCDB.Scale)

  if EasyCC.test then Unlock:SetChecked(true) else Unlock:SetChecked(false) end
  if EasyCCDB.LossOfControl then SetCVar("lossOfControl", 1) else SetCVar("lossOfControl", 0) end
  if EasyCCDB.durationTime["CC"] == 2 then SetCVar("lossOfControlFull", 2) elseif EasyCCDB.durationTime["CC"] == 1 then SetCVar("lossOfControlFull", 1) else SetCVar("lossOfControlFull", 0) end
  if EasyCCDB.durationTime["Silence"] == 2 then SetCVar("lossOfControlSilence", 2) elseif EasyCCDB.durationTime["Silence"] == 1 then SetCVar("lossOfControlSilence", 1) else SetCVar("lossOfControlSilence", 0) end
  if EasyCCDB.durationTime["Interrupt"] == 2 then SetCVar("lossOfControlInterrupt", 2) elseif EasyCCDB.durationTime["Interrupt"] == 1 then SetCVar("lossOfControlInterrupt", 1) else SetCVar("lossOfControlInterrupt", 0) end
  if EasyCCDB.durationTime["Disarm"] == 2 then SetCVar("lossOfControlDisarm", 2) elseif EasyCCDB.durationTime["Disarm"] == 1 then SetCVar("lossOfControlDisarm", 1) else SetCVar("lossOfControlDisarm", 0) end
  if EasyCCDB.durationTime["Root"] == 2 then SetCVar("lossOfControlRoot", 2) elseif EasyCCDB.durationTime["Root"]  == 1 then SetCVar("lossOfControlRoot", 1) else SetCVar("lossOfControlRoot", 0) end

end

InterfaceOptions_AddCategory(OptionsPanel)

-------------------------------------------------------------------------------
SLASH_ECC1 = "/ecc"

local SlashCmd = {}

function SlashCmd:reset()
  OptionsPanel.default()
end

SlashCmdList["ECC"] = function(cmd)
	local args = {}
	for word in cmd:lower():gmatch("%S+") do
		tinsert(args, word)
	end
	if SlashCmd[args[1]] then
		SlashCmd[args[1]](unpack(args))
	else
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Type \"/ecc reset\" to reset all settings")
    InterfaceOptionsFrame_OpenToCategory(OptionsPanel)
	end
end
