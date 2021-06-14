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
local tblinsert = table.insert
local tblremove= table.remove
local mathfloor = math.floor
local CLocData = C_LossOfControl.GetActiveLossOfControlData
local f, x, y
local _G = _G
local TimeSinceLastUpdate = 0
local EasyCCDB
local hieght = 48
local width = 48
local time = 2 -- Fade Timer
local spellIds = {}

local interrupts = {
  -- NPC Classic Interrupts
  --------------------------------------------------------
  {2676, 2},		-- Pulverize
  {5133, 30},		-- Interrupt (PT)
  {8714, 5},		-- Overwhelming Musk
  {10887, 5},		-- Crowd Pummel
  {11972, 8},		-- Shield Bash
  {11978, 6},		-- Kick
  {12555, 5},		-- Pummel
  {13281, 2},		-- Earth Shock
  {13728, 2},		-- Earth Shock
  {15122, 15},		-- Counterspell
  {15501, 2},		-- Earth Shock
  {15610, 6},		-- Kick
  {15614, 6},		-- Kick
  {15615, 5},		-- Pummel
  {19129, 2},		-- Massive Tremor
  {19639, 5},		-- Pummel
  {19715, 10},		-- Counterspell
  {20537, 15},		-- Counterspell
  {20788, 0.0010},	-- Counterspell
  {21832, 10},		-- Boulder
  {22885, 2},		-- Earth Shock
  {23114, 2},		-- Earth Shock
  {24685, 4},		-- Earth Shock
  {25025, 2},		-- Earth Shock
  {25788, 5},		-- Head Butt
  {26194, 2},		-- Earth Shock
  {27613, 4},		-- Kick
  {27620, 4},		-- Snap Kick
  {27814, 6},		-- Kick
  {27880, 3},		-- Stun
  {29298, 4},		-- Dark Shriek
  {29560, 2},		-- Kick
  {29586, 5},		-- Kick
  {29961, 10},		-- Counterspell
  {30849, 6},		-- Spell Lock
  {31596, 6},		-- Counterspell
  {31999, 15},		-- Counterspell
  {32322, 4},		-- Dark Shriek
  {32691, 6},		-- Spell Shock
  {32747, 3},		-- Deadly Interrupt Effect
  {32846, 4},		-- Counter Kick
  {32938, 4},		-- Cry of the Dead
  {33871, 8},		-- Shield Bash
  {34797, 6},		-- Nature Shock
  {34802, 6},		-- Kick
  {35039, 10},		-- Countercharge
  {35178, 6},		-- Shield Bash
  {35856, 3},		-- Stun
  {35920, 2},		-- Electroshock
  {36033, 6},		-- Kick
  {36138, 3},		-- Hammer Stun
  {36254, 3},		-- Judgement of the Flame
  {36841, 3},		-- Sonic Boom
  {36988, 8},		-- Shield Bash
  {37359, 5},		-- Rush
  {37470, 3},		-- Counterspell
  {38052, 3},		-- Sonic Boom
  {38233, 8},		-- Shield Bash
  {38313, 5},		-- Pummel
  {38625, 6},		-- Kick
  {38750, 4},		-- War Stomp
  {38897, 4},		-- Sonic Boom
  {39076, 6},		-- Spell Shock
  {39120, 6},		-- Nature Shock
  {40305, 1},		-- Power Burn
  {40547, 1},		-- Interrupt Unholy Growth
  {40751, 3},		-- Disrupt Magic
  {40864, 3},		-- Throbbing Stun
  {41180, 3},		-- Shield Bash
  {41197, 3},		-- Shield Bash
  {41395, 5},		-- Kick
  {43305, 4},		-- Earth Shock
  {43518, 2},		-- Kick
  {44418, 2},		-- Massive Tremor
  {44644, 6},		-- Arcane Nova
  {45214, 8},		-- Ron's Test Spell #4
  {45356, 5},		-- Kick
  {46036, 6},		-- Arcane Nova
  {46182, 2},		-- Snap Kick
  {47071, 2},		-- Earth Shock
  {47081, 5},		-- Pummel


}

local spellsTable = {
{"PVP", --TAB
-- Player Interrupts

 {11978, "Interrupt"},		-- Pummel (Iron Knuckles Item)

  {13491, "Interrupt"},		-- Pummel (Iron Knuckles Item)
  {29443, "Interrupt"},		-- Counterspell (Clutch of Foresight)

  {29704, "Interrupt"},		-- Shield Bash (rank 4) (Warrior)
  {1672, "Interrupt"},		-- Shield Bash (rank 3) (Warrior)
  {1671, "Interrupt"},		-- Shield Bash (rank 2) (Warrior)
  {72,   "Interrupt"},	 	-- Shield Bash (rank 1) (Warrior)
  {6554, "Interrupt"},		-- Pummel (rank 2) (Warrior)
  {6552, "Interrupt"},		-- Pummel (rank 1) (Warrior)
  {19647, "Interrupt"},		-- Spell Lock (felhunter) (rank 2) (Warlock)
  {19244, "Interrupt"},		-- Spell Lock (felhunter) (rank 1) (Warlock)
  {26679, "Interrupt"},		-- Deadly Throw (Gladiator's Leather Gloves) (rank 1) (Rogue)
  {38768, "Interrupt"},		-- Kick (rank 5) (Rogue)
  {1769, "Interrupt"},		-- Kick (rank 4) (Rogue)
  {1768, "Interrupt"},		-- Kick (rank 3) (Rogue)
  {1767, "Interrupt"},		-- Kick (rank 2) (Rogue)
  {1766, "Interrupt"},		-- Kick (rank 1) (Rogue)
  {2139, "Interrupt"},		-- Counterspell (Mage)
  {19675, "Interrupt"},		-- Feral Charge (Druid)
  {22570, "Interrupt"},		-- Maim (Gladiator's Dragonhide Gloves) (rank 1) (Druid)
  {25454, "Interrupt"},		-- Earth Shock (rank 8) (Shaman)
  {10414, "Interrupt"},		-- Earth Shock (rank 7) (Shaman)
  {10413, "Interrupt"},		-- Earth Shock (rank 6) (Shaman)
  {10412, "Interrupt"},		-- Earth Shock (rank 5) (Shaman)
  {8046, "Interrupt"},		-- Earth Shock (rank 4) (Shaman)
  {8045, "Interrupt"},		-- Earth Shock (rank 3) (Shaman)
  {8044, "Interrupt"},		-- Earth Shock (rank 2) (Shaman)
  {8042, "Interrupt"},		-- Earth Shock (rank 1) (Shaman)
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

  {39796  , "CC"},				-- Stoneclaw Stun (Stoneclaw Totem)

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

  {853    , "CC"},				-- Hammer of Justice (rank 1)
  {5588   , "CC"},				-- Hammer of Justice (rank 2)
  {5589   , "CC"},				-- Hammer of Justice (rank 3)
  {10308  , "CC"},				-- Hammer of Justice (rank 4)
  {20170  , "CC"},				-- Stun (Seal of Justice)
  {2878   , "CC"},				-- Turn Undead (rank 1)
  {5627   , "CC"},				-- Turn Undead (rank 2)
  {10326  , "CC"},				-- Turn Evil (rank 1)
  {20066  , "CC"},				-- Repentance (talent)

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

  {20549  , "CC"},				-- War Stomp (tauren racial)

  {34490  , "Silence"},		-- Silencing Shot
  {18469  , "Silence"},		-- Counterspell - Silenced (Improved Counterspell talent)
  {15487  , "Silence"},		-- Silence (talent)
  {1330   , "Silence"},		-- Garrote - Silence
  {43523  , "Silence"},		-- Unstable Affliction
  {24259  , "Silence"},		-- Spell Lock (Felhunter)
  {18498  , "Silence"},		-- Shield Bash - Silenced (Improved Shield Bash talent)
  {25046  , "Silence"},		-- Arcane Torrent (blood elf racial)
  {28730  , "Silence"},		-- Arcane Torrent (blood elf racial)


  {19306  , "Root"},				-- Counterattack (talent) (rank 1)
  {20909  , "Root"},				-- Counterattack (talent) (rank 2)
  {20910  , "Root"},				-- Counterattack (talent) (rank 3)
  {27067  , "Root"},				-- Counterattack (talent) (rank 4)
  {19229  , "Root"},				-- Improved Wing Clip (talent)
  {19185  , "Root"},				-- Entrapment (talent)

  {4167   , "Root"},				-- Web
  {4168   , "Root"},				-- Web II
  {4169   , "Root"},				-- Web III
  {25999   , "Root"},				-- Boar Charge

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

  {122    , "Root"},				-- Frost Nova (rank 1)
  {865    , "Root"},				-- Frost Nova (rank 2)
  {6131   , "Root"},				-- Frost Nova (rank 3)
  {10230  , "Root"},				-- Frost Nova (rank 4)
  {27088  , "Root"},				-- Frost Nova (rank 5)
  {12494  , "Root"},				-- Frostbite (talent)
  {33395  , "Root"},				-- Freeze

  {44041  , "Root"},				-- Chastise (rank 1)
  {44043  , "Root"},				-- Chastise (rank 2)
  {44044  , "Root"},				-- Chastise (rank 3)
  {44045  , "Root"},				-- Chastise (rank 4)
  {44046  , "Root"},				-- Chastise (rank 5)
  {44047  , "Root"},				-- Chastise (rank 6)

  {23694  , "Root"},				-- Improved Hamstring (talent)

  {642    , "ImmunePlayer"},			-- Divine Shield
	{47585  , "ImmunePlayer"},			-- Dispersion
  {27827  , "ImmunePlayer"},			-- Spirit of Redemption
  {290114 , "ImmunePlayer"},			-- Spirit of Redemption	(pvp honor talent)
  {215769 , "ImmunePlayer"},			-- Spirit of Redemption	(pvp honor talent)
  {213602 , "ImmunePlayer"},			-- Greater Fade (pvp honor talent - protects vs spells. melee}, ranged attacks + 50% speed)
  {320224 , "ImmunePlayer"},			--Podtender (NightFae: Dreamweaver Tree)

	{202797 , "Disarm_Warning"},   -- Viper Sting Healing Reduction
	{77606  , "Disarm_Warning"},   -- Dark Simulacrum
  {314793 , "Disarm_Warning"},   -- Mirrors of Torment
  {322442 , "Disarm_Warning"}, --Thoughtstolen
  {322464 , "Disarm_Warning"}, --Thoughtstolen
  {322463 , "Disarm_Warning"}, --Thoughtstolen
  {322462 , "Disarm_Warning"}, --Thoughtstolen
  {322461 , "Disarm_Warning"}, --Thoughtstolen
  {322460 , "Disarm_Warning"}, --Thoughtstolen
  {322459 , "Disarm_Warning"}, --Thoughtstolen
  {322458 , "Disarm_Warning"}, --Thoughtstolen
  {322457 , "Disarm_Warning"}, --Thoughtstolen
	{197091 , "Disarm_Warning"},   -- Neurotoxin
	{206649 , "Disarm_Warning"},	 -- Eye of Leotheras (no silence}, 4% dmg and duration reset for spell casted)

  {117405 , "CC_Warning"},      -- Binding Shot
  {191241 , "CC_Warning"},      -- Sticky Bomb
  {182387 , "CC_Warning"},      -- Earthquake

  {199483 , "Stealth"},     -- Camo
  {5384   , "Stealth"},     -- Fiegn Death
  {5215   , "Stealth"},     -- Prowl
  {66     , "Stealth"},     -- Invis
  {32612  , "Stealth"},     -- Invis
  {110960 , "Stealth"},     -- Greater Invis
  {198158 , "Stealth"},     -- Mass Invis
  {1784   , "Stealth"},     -- Stealth
  {115191 , "Stealth"},     -- Stealth
  {11327  , "Stealth"},     -- Vanish
  {207736 , "Stealth"},	    -- Shadowy Duel
  {114018 , "Stealth"},	    -- Shroud of Concealment
  {58984  , "Stealth"},     -- Meld

  {228050 , "Immune"},			-- Divine Shield (Guardian of the Forgotten Queen)
  {1022   , "Immune"},	    -- Hand of Protection
  {204018 , "Immune"},	   	-- Blessing of Spellwarding
  {199448 , "Immune"},			-- Blessing of Sacrifice (Ultimate Sacrifice pvp talent) (not immune}, 100% damage transfered to paladin)

--  "ImmuneSpell",
--	"ImmunePhysical",

  {289655 , "AuraMastery_Cast_Auras"},			-- Holy Word: Concentration
  {317929 , "AuraMastery_Cast_Auras"},			-- Aura Mastery

	{127797 , "ROP_Vortex"},				-- Ursol's Vortex
	{102793 , "ROP_Vortex"},				-- Ursol's Vortex

	{209749 , "Disarm"},			-- Faerie Swarm (pvp honor talent)
	{233759 , "Disarm"},			-- Grapple Weapon
	{207777 , "Disarm"},			-- Dismantle
	--{197091 , "Disarm"},			-- Neurotoxin
  {236236 , "Disarm"},			-- Disarm (pvp honor talent - protection)
  {236077 , "Disarm"},			-- Disarm (pvp honor talent)S

  {320035 , "Haste_Reduction"},			-- Mirrors of Torment
  {247777 , "Haste_Reduction"},			-- Mind Trauma
  {199890 , "Haste_Reduction"},			-- Curse of Tongues


	{236273 , "Dmg_Hit_Reduction"},		-- Duel
  {199892 , "Dmg_Hit_Reduction"},   -- Curse of Weakness
  {200947 , "Dmg_Hit_Reduction"},   -- Encraching Vines
  {202900 , "Dmg_Hit_Reduction"},   -- Scorpid Sting
  {203268 , "Dmg_Hit_Reduction"},   -- Sticky Tar
	{212150 , "Dmg_Hit_Reduction"},		-- Cheap Tricks (pvp honor talent) (-75%  melee & range physical hit chance)

  --Interrupt

  {204361 , "AOE_DMG_Modifiers"},				-- Bloodlust (Shamanism pvp talent)
  {204362 , "AOE_DMG_Modifiers"},				-- Heroism (Shamanism pvp talent
  {208963 , "AOE_DMG_Modifiers"},				-- Skyfury Totem (Shamanism pvp talent
  {197871 , "AOE_DMG_Modifiers"},				-- Dark Archangel
  {197874 , "AOE_DMG_Modifiers"},				-- Dark Archangel
  {57934  , "AOE_DMG_Modifiers"},				-- Tricks of the Trade

  {212183 , "Friendly_Smoke_Bomb"},			-- Smoke Bomb

	{8178   , "AOE_Spell_Refections"},		-- Grounding Totem Effect (Grounding Totem)
  {213915 , "AOE_Spell_Refections"},		-- Mass Spell Reflection

  --{260881 , "Speed_Freedoms"}, --Spirit Wolf
  --{204262 , "Speed_Freedoms"}, --Spectral Recovery
  --{2645 , "Speed_Freedoms"}, --Ghost Wolf
  {212552 , "Speed_Freedoms"},		-- Wraith Walk
  {48265  , "Speed_Freedoms"},		-- Death's Advance
  {108843 , "Speed_Freedoms"},		-- Blazing Speed
  {269513 , "Speed_Freedoms"},		-- Death from Above
  {197003 , "Speed_Freedoms"},		-- Maneuverability
  {205629 , "Speed_Freedoms"},		-- Demonic Trample
  {310143 , "Speed_Freedoms"},    -- Soulshape

  {54216 , "Freedoms"},		-- Master's Call
  {118922 , "Freedoms"},		-- Posthaste
  {186257 , "Freedoms"},		-- Aspect of the Cheetah
  {192082 , "Freedoms"},		-- Wind Rush
  {58875 , "Freedoms"},		-- Spirit Walk
  {77764 , "Freedoms"},		-- Stampeding Roar
  {106898 , "Freedoms"},		-- Stampeding Roar
  {1850 , "Freedoms"},		-- Dash
  {252216 , "Freedoms"},		-- Tiger Dash
  {201447 , "Freedoms"},		-- Ride the Wind
  {116841 , "Freedoms"},		-- Tiger's Lust
  {1044 , "Freedoms"},		-- Blessing of Freedom
  {305395 , "Freedoms"}, --Blessing of Freedom (Not Purgeable)
  {221886 , "Freedoms"},		-- Divine Steed
  {36554 , "Freedoms"},		-- Shadowstep
  {2983 , "Freedoms"},		-- Sprint
  {111400 , "Freedoms"},		-- Burning Rush
  {68992 , "Freedoms"},		-- Darkflight
  {54861 , "Freedoms"},		-- Nitro Boots

  {6940 , "Friendly_Defensives"},		-- Blessing of Sacrifice
  {147833 , "Friendly_Defensives"},		-- Intervene
  {330279 , "Friendly_Defensives"},		-- Overwatch
  {213871 , "Friendly_Defensives"},		-- Bodyguard

  {26166, "Mana_Regen"},		-- Innervate
  {64901, "Mana_Regen"},		-- Symbol of Hope

  --{213644, "CC_Reduction"},		-- Nimble Brew
  {210256, "CC_Reduction"},		-- Blessing of Sanctuary
  {213610, "CC_Reduction"},		-- Holy Ward
  {236321, "CC_Reduction"},		-- War Banner

  {200183, "Personal_Offensives"},		-- Apotheosis
  {319952, "Personal_Offensives"},		-- Surrender to Madness
  {117679, "Personal_Offensives"},		-- Incarnation

  {22842, "Peronsal_Defensives"},		-- Frenzied Regeneration
  {22812, "Peronsal_Defensives"},		-- Barkskin

  {108839, "Movable_Cast_Auras"},		-- Ice Floes
  {10060, "Movable_Cast_Auras"},		-- Power Infusion
  {331937, "Movable_Cast_Auras"},		-- Euphoria
  {332506, "Movable_Cast_Auras"},		-- Soulsteel Clamps
  {332505, "Movable_Cast_Auras"},		-- Soulsteel Clamps
  {315443, "Movable_Cast_Auras"},		-- Abomination Limb

  --"Other", --
	--"PvE", --PVE only

  {201787, "SnareSpecial"},		-- Heavy-Handed Strikes
  {199845, "SnareSpecial"},		-- Psyflay (pvp honor talent)
  {198222, "SnareSpecial"},		-- System Shock (pvp honor talent) (90% slow)
  {200587, "SnareSpecial"},		-- Fel Fissure
  {308498, "SnareSpecial"},   -- Resonating Arrow (Hunter Kyrain Special)
  {320267, "SnareSpecial"},		-- Soothing Voice
  {204206, "SnareSpecial"},		-- Chilled (Chill Streak)

  {45524,  "SnarePhysical70"},		-- Chains of Ice
  {273977, "SnarePhysical70"},		-- Grip of the Dead
  {157981, "SnarePhysical70"},		-- Blast Wave
  {248744, "SnarePhysical70"},		-- Shiv
  {115196, "SnarePhysical70"},		-- Crippling Posion
  {12323 , "SnarePhysical70"},		-- Piercing Howl
  {198813, "SnarePhysical70"},		-- Vengeful Retreat
  {247121, "SnarePhysical70"},		-- Metamorphosis

  {212792, "SnareMagic70"},		-- Cone of Cold
  {228354, "SnareMagic70"},		-- Flurry
  {321329, "SnareMagic70"},		-- Ring of Frost
  {123586, "SnareMagic70"},		-- Flying Serpent Kick
  {183218, "SnareMagic70"},		-- Hand of Hindrance
  {204263, "SnareMagic70"},		-- Shining Force
  {204843, "SnareMagic70"},		-- Sigil of Chains

  {195645, "SnarePhysical50"},		-- Wing Clip
  {135299, "SnarePhysical50"},		-- Tar Trap
  {5116, "SnarePhysical50"},		-- Concussive Shot
  {186387, "SnarePhysical50"},		-- Bursting Shot
  {51490, "SnarePhysical50"},		-- Thunderstorm
  {288548, "SnarePhysical50"},		-- Frostbolt
  {50259, "SnarePhysical50"},		-- Dazed
  {232559, "SnarePhysical50"},		-- Thorns
  {12486, "SnarePhysical50"},		-- Blizzard
  {205021, "SnarePhysical50"},		-- Ray of Frost
  {236299, "SnarePhysical50"},		-- Chrono Shift
  {317792, "SnarePhysical50"},		-- Frostbolt
  {116095, "SnarePhysical50"},		-- Disable
  {196733, "SnarePhysical50"},		-- Special Delivery
  {204242, "SnarePhysical50"},		-- Consecration
  {255937, "SnarePhysical50"},		-- Wake of Ashes
  {15407, "SnarePhysical50"},		-- Mind Flay
  {193473, "SnarePhysical50"},		-- Mind Flay
  {185763, "SnarePhysical50"},		-- Pistol Shot
  {1715, "SnarePhysical50"},		-- Hamstring
  {213405, "SnarePhysical50"},		-- Master of the Glaive

  {3409, "SnarePosion50"},		-- Crippling Poison
  {334275, "SnarePosion50"},		-- Curse of Exhaustion

  {147732, "SnareMagic50"},		-- Frostbrand
  {3600, "SnareMagic50"},		-- Earthbind
  {116947, "SnareMagic50"},		-- Earthbind
  {196840, "SnareMagic50"},		-- Frostshock
  {279303, "SnareMagic50"},		-- Frostwyrm's Fury
  {61391, "SnareMagic50"},		-- Typhoon
  {"Frostbolt", "SnareMagic50"},		-- Frostbolt
  {205708, "SnareMagic50"},		-- Chilled
  {31589, "SnareMagic50"},		-- Slow
  {336887, "SnareMagic50"},		-- Lingering Numbness
  {337956, "SnareMagic50"},		-- Mental Recovery
  {6360, "SnareMagic50"},		-- Whiplash
  {337113, "SnareMagic50"},		-- Sacrolash's Dark Strike
  {260369, "SnareMagic50"},		-- Arcane Pulse

  {162546, "SnarePhysical30"},		-- Frozen Ammo
  {197385, "SnarePhysical30"},		-- Fury of Air
  {211793, "SnarePhysical30"},		-- Remorseless Winter
  {206930, "SnarePhysical30"},		-- Heart Strike
  {2120, "SnarePhysical30"},		-- Flamestrike
  {289308, "SnarePhysical30"},		-- Frozen Orb
  {121253, "SnarePhysical30"},		-- Keg Smash
  {6343, "SnarePhysical30"},		-- Thunder Clap
  {210003, "SnarePhysical30"},		-- Razor Spikes

	{58180, "SnareMagic30"}, -- Infected Wounds
	{206760, "SnareMagic30"}, -- Shadow Grasp

	----------------
	-- Demonhunter
	----------------

	{196555 , "Other"},			  -- Netherwalk
	{188499 , "Other"},	      -- Blade Dance (dodge chance increased by 100%)
	{198589 , "Other"},				-- Blur
	{209426 , "Other"},				-- Darkness

	----------------
	-- Death Knight
	----------------

	{115018 , "Other"},				-- Desecrated Ground (Immune to CC)
	{48707  , "Other"},	     	-- Anti-Magic Shell
	{51271  , "Other"},				-- Pillar of Frost
	{48792  , "Other"},				-- Icebound Fortitude
	{287081 , "Other"},				-- Lichborne
	{81256  , "Other"},				-- Dancing Rune Weapon
	{194679 , "Other"},				-- Rune Tap
	{152279 , "Other"},				-- Breath of Sindragosa
	{207289 , "Other"},				-- Unholy Frenzy
	{145629 , "Other"},		    -- Anti-Magic Zone (not immune}, 60% damage reduction)

	----------------
	-- Druid
	----------------

	{61336  , "Other"},			  -- Survival Instincts (not immune}, damage taken reduced by 50%)
	{305497 , "Other"},				-- Thorns (pvp honor talent)
	{102543 , "Other"},				-- Incarnation: King of the Jungle
	{106951 , "Other"},				-- Berserk
	{102558 , "Other"},				-- Incarnation: Guardian of Ursoc
	{102560 , "Other"},				-- Incarnation: Chosen of Elune
	{236696 , "Other"},				-- Thorns
	{29166  , "Other"},				-- Innervate
	{102342 , "Other"},				-- Ironbark

	----------------
	-- Hunter
	----------------

	{186265 , "Other"},			  -- Deterrence (aspect of the turtle)
	{19574  , "Other"},		    -- Bestial Wrath (only if The Beast Within (212704) it's active) (immune to some CC's)
	{266779 , "Other"},				-- Coordinated Assault
	{193530 , "Other"},				-- Aspect of the Wild
	{186289 , "Other"},				-- Aspect of the Eagle
	{288613 , "Other"},				-- Trueshot
	{202748 , "Other"},			  -- Survival Tactics (pvp honor talent) (not immune}, 99% damage reduction)
	{248519 , "Other"},	    	-- Interlope (pvp honor talent)

	  ----------------
	  -- Hunter Pets
	  ----------------

	  {26064  , "Other"},			-- Shell Shield (damage taken reduced 50%) (Turtle)
	  {90339  , "Other"},			-- Harden Carapace (damage taken reduced 50%) (Beetle)
	  {160063 , "Other"},			-- Solid Shell (damage taken reduced 50%) (Shale Spider)
	  {264022 , "Other"},			-- Niuzao's Fortitude (damage taken reduced 60%) (Oxen)
	  {263920 , "Other"},			-- Gruff (damage taken reduced 60%) (Goat)
	  {263867 , "Other"},			-- Obsidian Skin (damage taken reduced 50%) (Core Hound)
	  {279410 , "Other"},			-- Bulwark (damage taken reduced 50%) (Krolusk)
	  {263938 , "Other"},			-- Silverback (damage taken reduced 60%) (Gorilla)
	  {263869 , "Other"},			-- Bristle (damage taken reduced 50%) (Boar)
	  {263868 , "Other"},			-- Defense Matrix (damage taken reduced 50%) (Mechanical)
	  {263926 , "Other"},			-- Thick Fur (damage taken reduced 60%) (Bear)
	  {263865 , "Other"},			-- Scale Shield (damage taken reduced 50%) (Scalehide)
	  {279400 , "Other"},			-- Ancient Hide (damage taken reduced 60%) (Pterrordax)
	  {160058 , "Other"},			-- Thick Hide (damage taken reduced 60%) (Clefthoof)

	----------------
	-- Mage
	----------------

	{45438  , "Other"},			-- Ice Block
	{198065 , "Other"},	-- Prismatic Cloak (pvp talent) (not immune}, 50% magic damage reduction)
	{110959 , "Other"},				-- Greater Invisibility
	{198144 , "Other"},				-- Ice form (stun/knockback immune)
	{12042  , "Other"},				-- Arcane Power
	{190319 , "Other"},				-- Combustion
	{12472  , "Other"},				-- Icy Veins
	{198111 , "Other"},			-- Temporal Shield (not immune}, heals all damage taken after 4 sec)

	----------------
	-- Monk
	----------------

	{125174 , "Other"},		  	-- Touch of Karma
  {124280 , "Other"},       -- Touch of Karma Dot
  {122470 , "Other"},       -- Touch of Karma
	{122783 , "Other"},     	-- Diffuse Magic (not immune}, 60% magic damage reduction)
	{115176 , "Other"},		  	-- Zen Meditation (60% damage reduction)
	{202248 , "Other"},	      -- Guided Meditation (pvp honor talent) (redirect spells to monk)
	{201325 , "Other"},				-- Zen Moment
	{122278 , "Other"},				-- Dampen Harm
	{243435 , "Other"},				-- Fortifying Brew
	{120954 , "Other"},				-- Fortifying Brew
	{201318 , "Other"},				-- Fortifying Brew (pvp honor talent)
	{116849 , "Other"},				-- Life Cocoon
	{214326 , "Other"},				-- Exploding Keg (artifact trait - blind)
	{213664 , "Other"},				-- Nimble Brew
	{209584 , "Other"},				-- Zen Focus Tea
	{216113 , "Other"},				-- Way of the Crane
	{137639 , "Other"},				-- Storm}, Earth}, and Fire
	{152173 , "Other"},				-- Serenity
	{115080 , "Other"},				-- Touch of Death

	----------------
	-- Paladin
	----------------

	{31821  , "Other"},				-- Aura Mastery
	{210294 , "Other"},				-- Divine Favor
	{105809 , "Other"},				-- Holy Avenger
	{31850  , "Other"},				-- Ardent Defender
	{31884  , "Other"},				-- Avenging Wrath
	{216331 , "Other"},				-- Avenging Crusader
	{86659  , "Other"},				-- Guardian of Ancient Kings

	----------------
	-- Priest
	----------------

	{47788  , "Other"},				-- Guardian Spirit (prevent the target from dying)
	{197268 , "Other"},				-- Ray of Hope
	{33206  , "Other"},				-- Pain Suppression
	{232707 , "Other"},		  	-- Ray of Hope (pvp honor talent - not immune}, only delay damage and heal)

	----------------
	-- Rogue
	----------------

	{31224  , "Other"},	     	-- Cloak of Shadows
	{51690  , "Other"},				-- Killing Spree
	{13750  , "Other"},				-- Adrenaline Rush
	{1966   , "Other"},				-- Feint
	{121471 , "Other"},				-- Shadow Blades
	{45182  , "Other"},			  -- Cheating Death (-85% damage taken)
	{5277   , "Other"},	      -- Evasion (dodge chance increased by 100%)
	{212283 , "Other"},				-- Symbols of Death
	{226364 , "Other"},				-- Evasion (Shadow Swiftness}, artifact trait)

	----------------
	-- Shaman
	----------------

	{207498 , "Other"},				-- Ancestral Protection (prevent the target from dying)
	{290641 , "Other"},				-- Ancestral Gift (PvP Talent) (immune to Silence and Interrupt effects)
	{108271 , "Other"},				-- Astral Shift
	{114050 , "Other"},				-- Ascendance (Elemental)
	{114051 , "Other"},				-- Ascendance (Enhancement)
	{114052 , "Other"},				-- Ascendance (Restoration)
  {210918 , "Other"},	      -- Ethereal Form

	----------------
	-- Warlock
	----------------

	{110913 , "Other"},				-- Dark Bargain
	{104773 , "Other"},				-- Unending Resolve
	{113860 , "Other"},				-- Dark Soul: Misery
	{113858 , "Other"},				-- Dark Soul: Instability
	{212295 , "Other"},	     	-- Netherward (reflects spells)

	----------------
	-- Warrior
	----------------

	{46924  , "Other"},		    -- Bladestorm (not immune to dmg}, only to LoC)
	{227847 , "Other"},			  -- Bladestorm (not immune to dmg}, only to LoC)
	{199038 , "Other"},			  -- Leave No Man Behind (not immune}, 90% damage reduction)
	{218826 , "Other"},			  -- Trial by Combat (warr fury artifact hidden trait) (only immune to death)
	{23920  , "Other"},		    -- Spell Reflection
	{216890 , "Other"},	   	  -- Spell Reflection
	{871    , "Other"},				-- Shield Wall
	{12975  , "Other"},				-- Last Stand
	{18499  , "Other"},				-- Berserker Rage
	{107574 , "Other"},				-- Avatar
	{262228 , "Other"},				-- Deadly Calm
	{198817 , "Other"},				-- Sharpen Blade (pvp honor talent)(Buff on Warrior)
	{198819 , "Other"},				-- Mortal Strike (Sharpen Blade pvp honor talent))(Debuff on Target)
	{184364 , "Other"},				-- Enraged Regeneration
	{118038 , "Other"},	      -- Die by the Sword (parry chance increased by 100%}, damage taken reduced by 30%)
	{198760 , "Other"},	      -- Intercept (pvp honor talent) (intercept the next ranged or melee hit)

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
  {7744   , "Other"},				-- Will of the Forsaken	(undead racial)
  {26635  , "Other"},				-- Berserking (troll racial)
  {20594  , "Other"},				-- Stoneform (dwarf racial)
  {13327  , "CC"},				-- Reckless Charge (Goblin Rocket Helmet)
  --{23230  , "Other"},				-- Blood Fury (orc racial)
  {13181  , "CC"},				-- Gnomish Mind Control Cap (Gnomish Mind Control Cap helmet)
  {26740  , "CC"},				-- Gnomish Mind Control Cap (Gnomish Mind Control Cap helmet)
  {8345   , "CC"},				-- Control Machine (Gnomish Universal Remote trinket)
  {13235  , "CC"},				-- Forcefield Collapse (Gnomish Harm Prevention belt)
  {13158  , "CC"},				-- Rocket Boots Malfunction (Engineering Rocket Boots)
  {8893   , "CC"},				-- Rocket Boots Malfunction (Engineering Rocket Boots)
  {13466  , "CC"},				-- Goblin Dragon Gun (engineering trinket malfunction)
  {8224   , "CC"},				-- Cowardice (Savory Deviate Delight effect)
  {8225   , "CC"},				-- Run Away! (Savory Deviate Delight effect)
  {23131  , "ImmuneSpell"},		-- Frost Reflector (Gyrofreeze Ice Reflector trinket) (only reflect frost spells)
  {23097  , "ImmuneSpell"},		-- Fire Reflector (Hyper-Radiant Flame Reflector trinket) (only reflect fire spells)
  {23132  , "ImmuneSpell"},		-- Shadow Reflector (Ultra-Flash Shadow Reflector trinket) (only reflect shadow spells)
  {30003  , "ImmuneSpell"},		-- Sheen of Zanza
  {23444  , "CC"},				-- Transporter Malfunction
  {23447  , "CC"},				-- Transporter Malfunction
  {23456  , "CC"},				-- Transporter Malfunction
  {23457  , "CC"},				-- Transporter Malfunction
  {8510   , "CC"},				-- Large Seaforium Backfire
  {8511   , "CC"},				-- Small Seaforium Backfire
  {7144   , "ImmunePhysical"},	-- Stone Slumber
  {12843  , "Immune"},			-- Mordresh's Shield
  {27619  , "Immune"},			-- Ice Block
  {21892  , "Immune"},			-- Arcane Protection
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
  --{9774   , "Other"},				-- Immune Root (spider belt)
  {18278  , "Silence"},			-- Silence (Silent Fang sword)
  {8346   , "Root"},				-- Mobility Malfunction (trinket)
  {13099  , "Root"},				-- Net-o-Matic (trinket)
  {13119  , "Root"},				-- Net-o-Matic (trinket)
  {13138  , "Root"},				-- Net-o-Matic (trinket)
  {16566  , "Root"},				-- Net-o-Matic (trinket)
  {23723  , "Other"},				-- Mind Quickening (Mind Quickening Gem trinket)
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
  {17820  , "Other"},				-- Veil of Shadow
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
  {15091  , "Snare"},				-- Blast Wave
  {17277  , "Snare"},				-- Blast Wave
  {23039  , "Snare"},				-- Blast Wave
  {23113  , "Snare"},				-- Blast Wave
  {23115  , "Snare"},				-- Frost Shock
  {19133  , "Snare"},				-- Frost Shock
  {21030  , "Snare"},				-- Frost Shock
  {11538  , "Snare"},				-- Frostbolt
  {21369  , "Snare"},				-- Frostbolt
  {20297  , "Snare"},				-- Frostbolt
  {20806  , "Snare"},				-- Frostbolt
  {20819  , "Snare"},				-- Frostbolt
  {12737  , "Snare"},				-- Frostbolt
  {20792  , "Snare"},				-- Frostbolt
  {20822  , "Snare"},				-- Frostbolt
  {23412  , "Snare"},				-- Frostbolt
  {24942  , "Snare"},				-- Frostbolt
  {23102  , "Snare"},				-- Frostbolt
  {20828  , "Snare"},				-- Cone of Cold
  {22746  , "Snare"},				-- Cone of Cold
  {20717  , "Snare"},				-- Sand Breath
  {16568  , "Snare"},				-- Mind Flay
  {16094  , "Snare"},				-- Frost Breath
  {16340  , "Snare"},				-- Frost Breath
  {17174  , "Snare"},				-- Concussive Shot
  {27634  , "Snare"},				-- Concussive Shot
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
  {4932   , "ImmuneSpell"},		-- Ward of Myzrael
  {7383   , "ImmunePhysical"},	-- Water Bubble
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
  {3389   , "ImmuneSpell"},		-- Ward of the Eye
  {3651   , "ImmuneSpell"},		-- Shield of Reflection
  {20223  , "ImmuneSpell"},		-- Magic Reflection
  {27546  , "ImmuneSpell"},		-- Faerie Dragon Form (not immune}, 50% magical damage reduction)
  {17177  , "ImmunePhysical"},	-- Seal of Protection
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
  {18803  , "Other"},				-- Focus (Hand of Edward the Odd mace)
  {1604   , "Snare"},				-- Dazed
  {9462   , "Snare"},				-- Mirefin Fungus
  {19137  , "Snare"},				-- Slow
  {24753  , "CC"},				-- Trick
  {21847  , "CC"},				-- Snowman
  {21848  , "CC"},				-- Snowman
  {21980  , "CC"},				-- Snowman
  {27880  , "CC"},				-- Stun
  {23010  , "CC"},				-- Tendrils of Air
  {6724   , "Immune"},			-- Light of Elune
  {13007  , "Immune"},			-- Divine Protection
  {24360  , "CC"},				-- Greater Dreamless Sleep Potion
  {15822  , "CC"},				-- Dreamless Sleep Potion
  {15283  , "CC"},				-- Stunning Blow (Dark Iron Pulverizer weapon)
  {21152  , "CC"},				-- Earthshaker (Earthshaker weapon)
  {16600  , "CC"},				-- Might of Shahram (Blackblade of Shahram sword)
  {16597  , "Snare"},				-- Curse of Shahram (Blackblade of Shahram sword)
  {13496  , "Snare"},				-- Dazed (Mug O' Hurt mace)
  {3238   , "Other"},				-- Nimble Reflexes
  {5990   , "Other"},				-- Nimble Reflexes
  {6615   , "Other"},				-- Free Action Potion
  {11359  , "Other"},				-- Restorative Potion
  {24364  , "Other"},				-- Living Free Action Potion
  {23505  , "Other"},				-- Berserking
  {24378  , "Other"},				-- Berserking
  {19135  , "Other"},				-- Avatar
  {12738  , "Other"},				-- Amplify Damage
  {26198  , "CC"},				-- Whisperings of C'Thun
  {26195  , "CC"},				-- Whisperings of C'Thun
  {26197  , "CC"},				-- Whisperings of C'Thun
  {26258  , "CC"},				-- Whisperings of C'Thun
  {26259  , "CC"},				-- Whisperings of C'Thun
  {17624  , "Immune"},			-- Flask of Petrification
  {13534  , "Disarm"},			-- Disarm (The Shatterer weapon)
  {11879  , "Disarm"},			-- Disarm (Shoni's Disarming Tool weapon)
  {13439  , "Snare"},				-- Frostbolt (some weapons)
  {16621  , "ImmunePhysical"},	-- Self Invulnerability (Invulnerable Mail)
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
  {40282  , "Immune"},			-- Possess Spirit Immune
  {45838  , "Immune"},			-- Possess Drake Immune
  {35236  , "CC"},				-- Heat Wave (chance to hit reduced by 35%)
  {29117  , "CC"},				-- Feather Burst (chance to hit reduced by 50%)
  {34088  , "CC"},				-- Feeble Weapons (chance to hit reduced by 75%)
  {45078  , "Other"},				-- Berserk (damage increased by 500%)
  {32378  , "Other"},				-- Filet (healing effects reduced by 50%)
  {32736  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  {39595  , "Other"},				-- Mortal Cleave (healing effects reduced by 50%)
  {40220  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  {43441  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  {44268  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  {34625  , "Other"},				-- Demolish (healing effects reduced by 75%)
  {36513  , "ImmunePhysical"},	-- Intangible Presence (not immune}, physical damage taken reduced by 40%)
  {31731  , "Immune"},			-- Shield Wall (not immune}, damage taken reduced by 60%)
  {41104  , "Immune"},			-- Shield Wall (not immune}, damage taken reduced by 60%)
  {41196  , "Immune"},			-- Shield Wall (not immune}, damage taken reduced by 75%)
  {45954  , "Immune"},			-- Ahune's Shield (not immune}, damage taken reduced by 75%)
  {46416  , "Immune"},			-- Ahune Self Stun
  {50279  , "Immune"},			-- Copy of Elemental Shield (not immune}, damage taken reduced by 75%)
  {29476  , "Immune"},			-- Astral Armor (not immune}, damage taken reduced by 90%)
  {30858  , "Immune"},			-- Demon Blood Shell
  {42206  , "Immune"},			-- Protection
  {33581  , "Immune"},			-- Divine Shield
  {40733  , "Immune"},			-- Divine Shield
  {41367  , "Immune"},			-- Divine Shield
  {30972  , "Immune"},			-- Evocation
  {31797  , "Immune"},			-- Banish Self
  {34973  , "Immune"},			-- Ravandwyr's Ice Block
  {36527  , "Immune"},			-- Stasis
  {36816  , "Immune"},			-- Water Shield
  {36860  , "Immune"},			-- Cannon Charging (self)
  {36911  , "Immune"},			-- Ice Block
  {37546  , "Immune"},			-- Banish
  {37905  , "Immune"},			-- Metamorphosis
  {37205  , "Immune"},			-- Channel Air Shield
  {38099  , "Immune"},			-- Channel Air Shield
  {38100  , "Immune"},			-- Channel Air Shield
  {37204  , "Immune"},			-- Channel Earth Shield
  {38101  , "Immune"},			-- Channel Earth Shield
  {38102  , "Immune"},			-- Channel Earth Shield
  {37206  , "Immune"},			-- Channel Fire Shield
  {38103  , "Immune"},			-- Channel Fire Shield
  {38104  , "Immune"},			-- Channel Fire Shield
  {36817  , "Immune"},			-- Channel Water Shield
  {38105  , "Immune"},			-- Channel Water Shield
  {38106  , "Immune"},			-- Channel Water Shield
  {38456  , "Immune"},			-- Banish Self
  {38916  , "Immune"},			-- Diplomatic Immunity
  {40357  , "Immune"},			-- Legion Ring - Character Invis and Immune
  {41130  , "Immune"},			-- Toranaku - Character Invis and Immune
  {40671  , "Immune"},			-- Health Funnel
  {41590  , "Immune"},			-- Ice Block
  {42354  , "Immune"},			-- Banish Self
  {46604  , "Immune"},			-- Ice Block
  {11412  , "ImmunePhysical"},	-- Nether Shell
  {27181  , "ImmunePhysical"},	-- Nether Cloak
  {34518  , "ImmunePhysical"},	-- Nether Protection (Embrace of the Twisting Nether & Twisting Nether Chain Shirt items)
  {38026  , "ImmunePhysical"},	-- Viscous Shield
  {36576  , "ImmuneSpell"},		-- Shaleskin (not immune}, magic damage taken reduced by 50%)
  {39804  , "ImmuneSpell"},		-- Damage Immunity: Magic
  {39811  , "ImmuneSpell"},		-- Damage Immunity: Fire}, Frost}, Shadow}, Nature}, Arcane
  {39666  , "ImmuneSpell"},		-- Cloak of Shadows
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
  {31533  , "ImmuneSpell"},		-- Spell Reflection (50% chance to reflect a spell)
  {33719  , "ImmuneSpell"},		-- Perfect Spell Reflection
  {34783  , "ImmuneSpell"},		-- Spell Reflection
  {36096  , "ImmuneSpell"},		-- Spell Reflection
  {37885  , "ImmuneSpell"},		-- Spell Reflection
  {38331  , "ImmuneSpell"},		-- Spell Reflection
  {43443  , "ImmuneSpell"},		-- Spell Reflection
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
  {29158  , "Snare"},				-- Inhale
  {29957  , "Snare"},				-- Frostbolt Volley
  {30600  , "Snare"},				-- Blast Wave
  {30942  , "Snare"},				-- Frostbolt
  {30981  , "Snare"},				-- Crippling Poison
  {31296  , "Snare"},				-- Frostbolt
  {32334  , "Snare"},				-- Cyclone
  {32417  , "Snare"},				-- Mind Flay
  {32774  , "Snare"},				-- Avenger's Shield
  {32984  , "Snare"},				-- Frostbolt
  {33047  , "Snare"},				-- Void Bolt
  {34214  , "Snare"},				-- Frost Touch
  {34347  , "Snare"},				-- Frostbolt
  {35252  , "Snare"},				-- Unstable Cloud
  {35263  , "Snare"},				-- Frost Attack
  {35316  , "Snare"},				-- Frostbolt
  {35351  , "Snare"},				-- Sand Breath
  {35955  , "Snare"},				-- Dazed
  {36148  , "Snare"},				-- Chill Nova
  {36278  , "Snare"},				-- Blast Wave
  {36279  , "Snare"},				-- Frostbolt
  {36464  , "Snare"},				-- The Den Mother's Mark
  {36518  , "Snare"},				-- Shadowsurge
  {36839  , "Snare"},				-- Impairing Poison
  {36843  , "Snare"},				-- Slow
  {37276  , "Snare"},				-- Mind Flay
  {37330  , "Snare"},				-- Mind Flay
  {37359  , "Snare"},				-- Rush
  {37554  , "Snare"},				-- Avenger's Shield
  {37786  , "Snare"},				-- Bloodmaul Rage
  {37830  , "Snare"},				-- Repolarized Magneto Sphere
  {38032  , "Snare"},				-- Stormbolt
  {38256  , "Snare"},				-- Piercing Howl
  {38534  , "Snare"},				-- Frostbolt
  {38536  , "Snare"},				-- Blast Wave
  {38663  , "Snare"},				-- Slow
  {38712  , "Snare"},				-- Blast Wave
  {38767  , "Snare"},				-- Daze
  {38771  , "Snare"},				-- Burning Rage
  {38952  , "Snare"},				-- Frost Arrow
  {39001  , "Snare"},				-- Blast Wave
  {39038  , "Snare"},				-- Blast Wave
  {40417  , "Snare"},				-- Rage
  {40429  , "Snare"},				-- Frostbolt
  {40430  , "Snare"},				-- Frostbolt
  {40653  , "Snare"},				-- Whirlwind
  {40976  , "Snare"},				-- Slimy Spittle
  {41281  , "Snare"},				-- Cripple
  {41439  , "Snare"},				-- Mangle
  {41486  , "Snare"},				-- Frostbolt
  {42396  , "Snare"},				-- Mind Flay
  {42803  , "Snare"},				-- Frostbolt
  {43428  , "Snare"},				-- Frostbolt
  {43530  , "Snare"},				-- Piercing Howl
  {43945  , "Snare"},				-- You're a ...! (Effects)
  {43963  , "Snare"},				-- Retch!
  {44289  , "Snare"},				-- Crippling Poison
  {44937  , "Snare"},				-- Fel Siphon
  {46984  , "Snare"},				-- Cone of Cold
  {46987  , "Snare"},				-- Frostbolt
  {47106  , "Snare"},				-- Soul Flay
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
  	{29309  , "Immune"},			-- Phase Shift
  	{37432  , "Immune"},			-- Water Shield (not immune}, damage taken reduced by 50%)
  	{37434  , "Immune"},			-- Fire Shield (not immune}, damage taken reduced by 50%)
  	{30969  , "ImmuneSpell"},		-- Reflection
  	{29505  , "Silence"},			-- Banshee Shriek
  	{30013  , "Disarm"},			-- Disarm
  	--{30019  , "CC"},				-- Control Piece
  	--{39331  , "Silence"},			-- Game In Session
  	{29303  , "Snare"},				-- Wing Beat
  	{29540  , "Snare"},				-- Curse of Past Burdens
  	{29666  , "Snare"},				-- Frost Shock
  	{29667  , "Snare"},				-- Hamstring
  	{29837  , "Snare"},				-- Fist of Stone
  	{29717  , "Snare"},				-- Cone of Cold
  	{29923  , "Snare"},				-- Frostbolt Volley
  	{29926  , "Snare"},				-- Frostbolt
  	{29292  , "Snare"},				-- Frost Mist
  	-- -- Servant Quarters
  	{29896  , "CC"},				-- Hyakiss' Web
  	{29904  , "Silence"},			-- Sonic Burst
  	-- -- Attumen the Huntsman
  	{29711  , "CC"},				-- Knockdown
  	{29833  , "CC"},				-- Intangible Presence (chance to hit with spells and melee attacks reduced by 50%)
  	-- -- Moroes
  	{29425  , "CC"},				-- Gouge
  	{34694  , "CC"},				-- Blind
  	{29382  , "Immune"},			-- Divine Shield
  	{29390  , "Immune"},			-- Shield Wall (not immune}, damage taken reduced by 75%)
  	{29572  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{29570  , "Snare"},				-- Mind Flay
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
  	{30887  , "Other"},				-- Devotion
  	-- -- The Curator
  	{30254  , "CC"},				-- Evocation
  	-- -- Terestian Illhoof
  	{30115  , "CC"},				-- Sacrifice
  	-- -- Shade of Aran
  	{29964  , "CC"},				-- Dragon's Breath
  	{29963  , "CC"},				-- Mass Polymorph
  	{29991  , "Root"},				-- Chains of Ice
  	{29954  , "Snare"},				-- Frostbolt
  	{29990  , "Snare"},				-- Slow
  	{29951  , "Snare"},				-- Blizzard
  	{30035  , "Snare"},				-- Mass Slow
  	-- -- Nightbane
  	{36922  , "CC"},				-- Bellowing Roar
  	{30130  , "CC"},				-- Distracting Ash (chance to hit with attacks}, spells and abilities reduced by 30%)
  	-- -- Prince Malchezaar
  	{39095  , "Other"},				-- Amplify Damage (damage taken is increased by 100%)
  	{30843  , "Other"},				-- Enfeeble (healing effects and health regeneration reduced by 100%)
    },
  	------------------------
  {"Gruul's Lair Raid",
  	-- -- Trash
  	{33709  , "CC"},				-- Charge
  	{39171  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	-- -- High King Maulgar & Council
  	{33173  , "CC"},				-- Greater Polymorph
  	{33130  , "CC"},				-- Death Coil
  	{33175  , "Disarm"},			-- Arcane Shock
  	{33054  , "ImmuneSpell"},		-- Spell Shield (not immune}, magic damage taken reduced by 75%)
  	{33147  , "Other"},				-- Greater Power Word: Shield (immune to spell interrupt}, immune to stun)
  	{33238  , "Snare"},				-- Whirlwind
  	{33061  , "Snare"},				-- Blast Wave
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
  	{38599  , "ImmuneSpell"},		-- Spell Reflection
  	{38634  , "Silence"},			-- Arcane Lightning
  	{38491  , "Silence"},			-- Silence
  	{38572  , "Other"},				-- Mortal Cleave (healing effects reduced by 50%)
  	{38631  , "Snare"},				-- Avenger's Shield
  	{38644  , "Snare"},				-- Cone of Cold
  	{38645  , "Snare"},				-- Frostbolt
  	{38995  , "Snare"},				-- Hamstring
  	{39062  , "Snare"},				-- Frost Shock
  	{39064  , "Snare"},				-- Frostbolt
  	{38516  , "Snare"},				-- Cyclone
  	-- -- Hydross the Unstable
  	{38246  , "CC"},				-- Vile Sludge (damage and healing dealt is reduced by 50%)
  	-- -- Leotheras the Blind
  	{37749  , "CC"},				-- Consuming Madness
  	-- -- Fathom-Lord Karathress
  	{38441  , "CC"},				-- Cataclysmic Bolt
  	{38234  , "Snare"},				-- Frost Shock
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
  	{38112  , "Immune"},			-- Magic Barrier
  	{38262  , "Snare"},				-- Hamstring
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
  	{37262  , "Snare"},				-- Frostbolt Volley
  	{37265  , "Snare"},				-- Cone of Cold
  	{39087  , "Snare"},				-- Frost Attack
  	-- -- Void Reaver
  	{34190  , "Silence"},			-- Arcane Orb
  	-- -- Kael'thas
  	{36834  , "CC"},				-- Arcane Disruption
  	{37018  , "CC"},				-- Conflagration
  	{44863  , "CC"},				-- Bellowing Roar
  	{36797  , "CC"},				-- Mind Control
  	{37029  , "CC"},				-- Remote Toy
  	{36989  , "Root"},				-- Frost Nova
  	{36970  , "Snare"},				-- Arcane Burst
  	{36990  , "Snare"},				-- Frostbolt
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
  	{41371  , "ImmuneSpell"},		-- Shell of Pain
  	{41381  , "ImmuneSpell"},		-- Shell of Life
  	{39667  , "Immune"},			-- Vanish
  	{41062  , "Disarm"},			-- Disarm
  	{36139  , "Disarm"},			-- Disarm
  	{41084  , "Silence"},			-- Silencing Shot
  	{41168  , "Silence"},			-- Sonic Strike
  	{41097  , "Snare"},				-- Whirlwind
  	{41116  , "Snare"},				-- Frost Shock
  	{41384  , "Snare"},				-- Frostbolt
  	-- -- High Warlord Naj'entus
  	{39837  , "CC"},				-- Impaling Spine
  	{39872  , "Immune"},			-- Tidal Shield
  	-- -- Supremus
  	{41922  , "Snare"},				-- Snare Self
  	-- -- Shade of Akama
  	{41179  , "CC"},				-- Debilitating Strike (physical damage done reduced by 75%)
  	-- -- Teron Gorefiend
  	{40175  , "CC"},				-- Spirit Chains
  	-- -- Gurtogg Bloodboil
  	{40597  , "CC"},				-- Eject
  	{40491  , "CC"},				-- Bewildering Strike
  	{40599  , "Other"},				-- Arcing Smash (healing effects reduced by 50%)
  	{40569  , "Root"},				-- Fel Geyser
  	{40591  , "CC"},				-- Fel Geyser
  	-- -- Reliquary of the Lost
  	{41426  , "CC"},				-- Spirit Shock
  	{41376  , "Immune"},			-- Spite
  	--{41292  , "Other"},				-- Aura of Suffering (healing effects reduced by 100%)
  	-- -- Mother Shahraz
  	{40823  , "Silence"},			-- Silencing Shriek
  	-- -- The Illidari Council
  	{41468  , "CC"},				-- Hammer of Justice
  	{41479  , "CC"},				-- Vanish
  	{41452  , "Immune"},			-- Devotion Aura (not immune}, damage taken reduced by 75%)
  	{41478  , "ImmuneSpell"},		-- Dampen Magic (not immune}, magic damage taken reduced by 75%)
  	{41451  , "ImmuneSpell"},		-- Blessing of Spell Warding
  	{41450  , "ImmunePhysical"},	-- Blessing of Protection
  	-- -- Illidan
  	{40647  , "CC"},				-- Shadow Prison
  	{41083  , "CC"},				-- Paralyze
  	{40620  , "CC"},				-- Eyebeam
  	{40695  , "CC"},				-- Caged
  	{40760  , "CC"},				-- Cage Trap
  	{41218  , "CC"},				-- Death
  	{41220  , "CC"},				-- Death
  	{41221  , "CC"},				-- Teleport Maiev
  	{39869  , "Other"},				-- Uncaged Wrath
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
  	{31406  , "Snare"},				-- Cripple
  	{31622  , "Snare"},				-- Frostbolt
  	{31688  , "Snare"},				-- Frost Breath
  	{31741  , "Snare"},				-- Slow
  	-- -- Rage Winterchill
  	{31249  , "CC"},				-- Icebolt
  	{31250  , "Root"},				-- Frost Nova
  	{31257  , "Snare"},				-- Chilled
  	-- -- Anetheron
  	{31298  , "CC"},				-- Sleep
  	-- -- Kaz'rogal
  	{31480  , "CC"},				-- War Stomp
  	{31477  , "Snare"},				-- Cripple
  	-- -- Azgalor
  	{31344  , "Silence"},			-- Howl of Azgalor
  	-- -- Archimonde
  	{31970  , "CC"},				-- Fear
  	{32053  , "Silence"},			-- Soul Charge
  	{38528  , "Immune"},			-- Protection of Elune
    },
  	------------------------
  	{"Zul'Aman Raid",
  	-- -- Trash
  	{43356  , "CC"},				-- Pounce
  	{43361  , "CC"},				-- Domesticate
  	{42220  , "CC"},				-- Conflagration
  	{35011  , "CC"},				-- Knockdown
  	{42479  , "Immune"},			-- Protective Ward
  	{43362  , "Root"},				-- Electrified Net
  	{43364  , "Snare"},				-- Tranquilizing Poison
  	{43524  , "Snare"},				-- Frost Shock
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
  	{46287  , "Immune"},			-- Infernal Defense (immune to most forms of damage}, holy damage taken increased by 500%)
  	{46296  , "Other"},				-- Necrotic Poison (healing effects reduced by 75%)
  	{46299  , "Snare"},				-- Wavering Will
  	{46562  , "Snare"},				-- Mind Flay
  	{46745  , "Snare"},				-- Chilling Touch
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
  	{45996  , "Other"},				-- Darkness (cannot be healed)
  	-- -- Kil'jaeden
  	{37369  , "CC"},				-- Hammer of Justice
  	{45848  , "Immune"},			-- Shield of the Blue (all incoming and outgoing damage is reduced by 95%)
  	{45885  , "Other"},				-- Shadow Spike (healing effects reduced by 50%)
  	{45737  , "Snare"},				-- Flame Dart
  	{45740  , "Snare"},				-- Flame Dart
  	{45741  , "Snare"},				-- Flame Dart
    },
  	------------------------
  {"TBC World Bosses",
  	-- -- Doom Lord Kazzak
  	{21063  , "Other"},				-- Twisted Reflection
  	{32964  , "Other"},				-- Frenzy
  	{21066  , "Snare"},				-- Void Bolt
  	{36706  , "Snare"},				-- Thunderclap
  	-- -- Doomwalker
  	{33653  , "Other"},				-- Frenzy
    },
  	------------------------
  	-- TBC Dungeons
  {"Hellfire Ramparts",
  	{39427  , "CC"},				-- Bellowing Roar
  	{30615  , "CC"},				-- Fear
  	{30621  , "CC"},				-- Kidney Shot
  	{31901  , "Immune"},			-- Demonic Shield (not immune}, damage taken reduced by 75%)
    },
  {"The Blood Furnace",
  	{30923  , "CC"},				-- Domination
  	{31865  , "CC"},				-- Seduction
  	{30940  , "Immune"},			-- Burning Nova
    },
  {"The Shattered Halls",
  	{30500  , "CC"},				-- Death Coil
  	{30741  , "CC"},				-- Death Coil
  	{30584  , "CC"},				-- Fear
  	{37511  , "CC"},				-- Charge
  	{23601  , "CC"},				-- Scatter Shot
  	{30980  , "CC"},				-- Sap
  	{30986  , "CC"},				-- Cheap Shot
  	{36023  , "Other"},				-- Deathblow (healing effects reduced by 50%)
  	{36054  , "Other"},				-- Deathblow (healing effects reduced by 50%)
  	{32587  , "Other"},				-- Shield Block (chance to block increased by 100%)
  	{30989  , "Snare"},				-- Hamstring
  	{31553  , "Snare"},				-- Hamstring
    },
  {"The Slave Pens",
  	{34984  , "CC"},				-- Psychic Horror
  	{32173  , "Root"},				-- Entangling Roots
  	{31983  , "Root"},				-- Earthgrab
  	{32192  , "Root"},				-- Frost Nova
  	{31986  , "ImmunePhysical"},	-- Stoneskin (melee damage taken reduced by 50%)
  	{31554  , "ImmuneSpell"},		-- Spell Reflection (50% chance to reflect a spell)
  	{33787  , "Snare"},				-- Cripple
  	{15497  , "Snare"},				-- Frostbolt
    },
  {"The Underbog",
  	{31428  , "CC"},				-- Sneeze
  	{31932  , "CC"},				-- Freezing Trap Effect
  	{35229  , "CC"},				-- Sporeskin (chance to hit with attacks}, spells and abilities reduced by 35%)
  	{31673  , "Root"},				-- Foul Spores
  	{12248  , "Other"},				-- Amplify Damage
  	{31719  , "Snare"},				-- Suspension
    },
  {"The Steamvault",
  	{31718  , "CC"},				-- Enveloping Winds
  	{38660  , "CC"},				-- Fear
  	{35107  , "Root"},				-- Electrified Net
  	{31534  , "ImmuneSpell"},		-- Spell Reflection
  	{22582  , "Snare"},				-- Frost Shock
  	{37865  , "Snare"},				-- Frost Shock
  	{37930  , "Snare"},				-- Frostbolt
  	{10987  , "Snare"},				-- Geyser
    },
  {"Mana-Tombs",
  	{32361  , "CC"},				-- Crystal Prison
  	{34322  , "CC"},				-- Psychic Scream
  	{33919  , "CC"},				-- Earthquake
  	{34940  , "CC"},				-- Gouge
  	{32365  , "Root"},				-- Frost Nova
  	{38759  , "ImmuneSpell"},		-- Dark Shell
  	{32358  , "ImmuneSpell"},		-- Dark Shell
  	{34922  , "Silence"},			-- Shadows Embrace
  	{32315  , "Other"},				-- Soul Strike (healing effects reduced by 50%)
  	{25603  , "Snare"},				-- Slow
  	{32364  , "Snare"},				-- Frostbolt
  	{32370  , "Snare"},				-- Frostbolt
  	{38064  , "Snare"},				-- Blast Wave
    },
  {"Auchenai Crypts",
  	{32421  , "CC"},				-- Soul Scream
  	{32830  , "CC"},				-- Possess
  	{32859  , "Root"},				-- Falter
  	{33401  , "Root"},				-- Possess
  	{32346  , "CC"},				-- Stolen Soul (damage and healing done reduced by 50%)
  	{37335  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{37332  , "Snare"},				-- Frost Shock
    },
  {"Sethekk Halls",
  	{40305  , "CC"},				-- Power Burn
  	{40184  , "CC"},				-- Paralyzing Screech
  	{43309  , "CC"},				-- Polymorph
  	{38245  , "CC"},				-- Polymorph
  	{40321  , "CC"},				-- Cyclone of Feathers
  	{35120  , "CC"},				-- Charm
  	{32654  , "CC"},				-- Talon of Justice
  	{33961  , "ImmuneSpell"},		-- Spell Reflection
  	{32690  , "Silence"},			-- Arcane Lightning
  	{38146  , "Silence"},			-- Arcane Lightning
  	{12548  , "Snare"},				-- Frost Shock
  	{32651  , "Snare"},				-- Howling Screech
  	{32674  , "Snare"},				-- Avenger's Shield
  	{33967  , "Snare"},				-- Thunderclap
  	{35032  , "Snare"},				-- Slow
  	{38238  , "Snare"},				-- Frostbolt
  	{17503  , "Snare"},				-- Frostbolt
    },
  {"Shadow Labyrinth",
  	{30231  , "Immune"},			-- Banish
  	{33547  , "CC"},				-- Fear
  	{38791  , "CC"},				-- Banish
  	{33563  , "CC"},				-- Draw Shadows
  	{33684  , "CC"},				-- Incite Chaos
  	{33502  , "CC"},				-- Brain Wash
  	{33332  , "CC"},				-- Suppression Blast
  	{33686  , "Silence"},			-- Shockwave
  	{33499  , "Silence"},			-- Shape of the Beast
  	{33666  , "Snare"},				-- Sonic Boom
  	{38795  , "Snare"},				-- Sonic Boom
  	{38243  , "Snare"},				-- Mind Flay
    },
  {"Old Hillsbrad Foothills",
  	{33789  , "CC"},				-- Frightening Shout
  	{50733  , "CC"},				-- Scatter Shot
  	{32890  , "CC"},				-- Knockout
  	{32864  , "CC"},				-- Kidney Shot
  	{41389  , "CC"},				-- Kidney Shot
  	{50762  , "Root"},				-- Net
  	{12024  , "Root"},				-- Net
  	{31911  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{31914  , "Snare"},				-- Sand Breath
  	{38384  , "Snare"},				-- Cone of Cold
    },
  {"The Black Morass",
  	{31422  , "CC"},				-- Time Stop
  	{38592  , "ImmuneSpell"},		-- Spell Reflection
  	{31458  , "Other"},				-- Hasten (melee and movement speed increased by 200%)
  	{15708  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{35054  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{31467  , "Snare"},				-- Time Lapse
  	{31473  , "Snare"},				-- Sand Breath
  	{39049  , "Snare"},				-- Sand Breath
  	{31478  , "Snare"},				-- Sand Breath
    },
  {"The Mechanar",
  	{35250  , "CC"},				-- Dragon's Breath
  	{35326  , "CC"},				-- Hammer Punch
  	{35280  , "CC"},				-- Domination
  	{35049  , "CC"},				-- Pound
  	{35783  , "CC"},				-- Knockdown
  	{36333  , "CC"},				-- Anesthetic
  	{35268  , "CC"},				-- Inferno
  	{35158  , "ImmuneSpell"},		-- Reflective Magic Shield
  	{36022  , "Silence"},			-- Arcane Torrent
  	{35055  , "Disarm"},			-- The Claw
  	{35189  , "Other"},				-- Solar Strike (healing effects reduced by 50%)
  	{35056  , "Snare"},				-- Glob of Machine Fluid
  	{38923  , "Snare"},				-- Glob of Machine Fluid
  	{35178  , "Snare"},				-- Shield Bash
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
  	{36173  , "Other"},				-- Gift of the Doomsayer (chance to heal enemy when healed)
  	{36693  , "Other"},				-- Necrotic Poison (healing effects reduced by 45%)
  	{36917  , "Other"},				-- Magma-Thrower's Curse (healing effects reduced by 50%)
  	{35965  , "Snare"},				-- Frost Arrow
  	{38942  , "Snare"},				-- Frost Arrow
  	{36646  , "Snare"},				-- Sightless Touch
  	{38815  , "Snare"},				-- Sightless Touch
  	{36710  , "Snare"},				-- Frostbolt
  	{38826  , "Snare"},				-- Frostbolt
  	{36741  , "Snare"},				-- Frostbolt Volley
  	{38837  , "Snare"},				-- Frostbolt Volley
  	{36786  , "Snare"},				-- Soul Chill
  	{38843  , "Snare"},				-- Soul Chill
    },
  {"The Botanica",
  	{34716  , "CC"},				-- Stomp
  	{34661  , "CC"},				-- Sacrifice
  	{32323  , "CC"},				-- Charge
  	{34639  , "CC"},				-- Polymorph
  	{34752  , "CC"},				-- Freezing Touch
  	{34770  , "CC"},				-- Plant Spawn Effect
  	{34801  , "CC"},				-- Sleep
  	{34551  , "Immune"},			-- Tree Form
  	{35399  , "ImmuneSpell"},		-- Spell Reflection
  	{22127  , "Root"},				-- Entangling Roots
  	{34353  , "Snare"},				-- Frost Shock
  	{34782  , "Snare"},				-- Bind Feet
  	{34800  , "Snare"},				-- Impending Coma
  	{35507  , "Snare"},				-- Mind Flay
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
  	{44475  , "ImmuneSpell"},		-- Magic Dampening Field (magic damage taken reduced by 75%)
  	{44177  , "Root"},				-- Frost Nova
  	{47168  , "Root"},				-- Improved Wing Clip
  	{46182  , "Silence"},			-- Snap Kick
  	{44505  , "Other"},				-- Drink Fel Infusion (damage and attack speed increased dramatically)
  	{44534  , "Other"},				-- Wretched Strike (healing effects reduced by 50%)
  	{44286  , "Snare"},				-- Wing Clip
  	{44504  , "Snare"},				-- Wretched Frostbolt
  	{44606  , "Snare"},				-- Frostbolt
  	{46035  , "Snare"},				-- Frostbolt
  	{46180  , "Snare"},				-- Frost Shock
  	{21401  , "Snare"},				-- Frost Shock
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
  	{19716  , "Other"},				-- Gehennas' Curse
  	-- -- Garr
  	{19496  , "Snare"},				-- Magma Shackles
  	-- -- Shazzrah
  	{19714  , "ImmuneSpell"},		-- Deaden Magic (not immune}, 50% magical damage reduction)
  	-- -- Baron Geddon
  	{19695  , "CC"},				-- Inferno
  	{20478  , "CC"},				-- Armageddon
  	-- -- Golemagg the Incinerator
  	{19820  , "Snare"},				-- Mangle
  	{22689  , "Snare"},				-- Mangle
  	-- -- Sulfuron Harbinger
  	{19780  , "CC"},				-- Hand of Ragnaros
  	-- -- Majordomo Executus
  	{20619  , "ImmuneSpell"},		-- Magic Reflection (not immune}, 50% chance reflect spells)
  	{20229  , "Snare"},				-- Blast Wave
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
  	{22247  , "Snare"},				-- Suppression Aura
  	{22424  , "Snare"},				-- Blast Wave
  	{15548  , "Snare"},				-- Thunderclap
  	-- -- Razorgore the Untamed
  	{19872  , "CC"},				-- Calm Dragonkin
  	{23023  , "CC"},				-- Conflagration
  	{15593  , "CC"},				-- War Stomp
  	{16740  , "CC"},				-- War Stomp
  	{28725  , "CC"},				-- War Stomp
  	{14515  , "CC"},				-- Dominate Mind
  	{22274  , "CC"},				-- Greater Polymorph
  	{13747  , "Snare"},				-- Slow
  	-- -- Broodlord Lashlayer
  	{23331  , "Snare"},				-- Blast Wave
  	{25049  , "Snare"},				-- Blast Wave
  	-- -- Chromaggus
  	{23310  , "CC"},				-- Time Lapse
  	{23312  , "CC"},				-- Time Lapse
  	{23174  , "CC"},				-- Chromatic Mutation
  	{23171  , "CC"},				-- Time Stop (Brood Affliction: Bronze)
  	{23153  , "Snare"},				-- Brood Affliction: Blue
  	{23169  , "Other"},				-- Brood Affliction: Green
  	-- -- Nefarian
  	{22666  , "Silence"},			-- Silence
  	{22667  , "CC"},				-- Shadow Command
  	{22663  , "Immune"},			-- Nefarian's Barrier
  	{22686  , "CC"},				-- Bellowing Roar
  	{22678  , "CC"},				-- Fear
  	{23603  , "CC"},				-- Wild Polymorph
  	{23364  , "CC"},				-- Tail Lash
  	{23365  , "Disarm"},			-- Dropped Weapon
  	{23415  , "ImmunePhysical"},	-- Improved Blessing of Protection
  	{23414  , "Root"},				-- Paralyze
  	{22687  , "Other"},				-- Veil of Shadow
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
  	{24021  , "ImmuneSpell"},		-- Anti-Magic Shield
  	{24674  , "Other"},				-- Veil of Shadow
  	{13737  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{3604   , "Snare"},				-- Tendon Rip
  	{24002  , "Snare"},				-- Tranquilizing Poison
  	{24003  , "Snare"},				-- Tranquilizing Poison
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
  	{16099  , "Snare"},				-- Frost Breath
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
  	{25187  , "Snare"},				-- Hive'Zara Catalyst
  	-- -- Kurinnaxx
  	{25656  , "CC"},				-- Sand Trap
  	-- -- General Rajaxx
  	{19134  , "CC"},				-- Frightening Shout
  	{29544  , "CC"},				-- Frightening Shout
  	{25425  , "CC"},				-- Shockwave
  	{25282  , "Immune"},			-- Shield of Rajaxx
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
  	--{13022  , "ImmuneSpell"},		-- Fire and Arcane Reflect (only reflect fire and arcane spells)
  	--{19595  , "ImmuneSpell"},		-- Shadow and Frost Reflect (only reflect shadow and frost spells)
  	{1906   , "Snare"},				-- Debilitating Charge
  	{25809  , "Snare"},				-- Crippling Poison
  	{26078  , "Snare"},				-- Vekniss Catalyst
  	-- -- The Prophet Skeram
  	{785    , "CC"},				-- True Fulfillment
  	-- -- Bug Trio: Yauj}, Vem}, Kri
  	{3242   , "CC"},				-- Ravage
  	{26580  , "CC"},				-- Fear
  	{19128  , "CC"},				-- Knockdown
  	{25989  , "Snare"},				-- Toxin
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
  	{568    , "Snare"},				-- Arcane Burst
  	{12241  , "Root"},				-- Twin Colossals Teleport
  	{12242  , "Root"},				-- Twin Colossals Teleport
  	-- -- Ouro
  	{26102  , "CC"},				-- Sand Blast
  	-- -- C'Thun
  	{23953  , "Snare"},				-- Mind Flay
  	{26211  , "Snare"},				-- Hamstring
  	{26141  , "Snare"},				-- Hamstring
    },
  	------------------------
  {"Naxxramas (Classic) Raid",
  	-- -- Trash
  	{6605   , "CC"},				-- Terrifying Screech
  	{27758  , "CC"},				-- War Stomp
  	{27990  , "CC"},				-- Fear
  	{28412  , "CC"},				-- Death Coil
  	{29848  , "CC"},				-- Polymorph
  	{28995  , "Immune"},			-- Stoneskin
  	{29849  , "Root"},				-- Frost Nova
  	{30094  , "Root"},				-- Frost Nova
  	{28350  , "Other"},				-- Veil of Darkness (immune to direct healing)
  	{28440  , "Other"},				-- Veil of Shadow
  	{18328  , "Snare"},				-- Incapacitating Shout
  	{28310  , "Snare"},				-- Mind Flay
  	{30092  , "Snare"},				-- Blast Wave
  	{30095  , "Snare"},				-- Cone of Cold
  	-- -- Anub'Rekhan
  	{28786  , "CC"},				-- Locust Swarm
  	{25821  , "CC"},				-- Charge
  	{28991  , "Root"},				-- Web
  	-- -- Grand Widow Faerlina
  	{30225  , "Silence"},			-- Silence
  	{28732  , "Other"},				-- Widow's Embrace (prevents enraged and silenced nature spells)
  	-- -- Maexxna
  	{28622  , "CC"},				-- Web Wrap
  	{29484  , "CC"},				-- Web Spray
  	{28776  , "Other"},				-- Necrotic Poison (healing taken reduced by 90%)
  	-- -- Noth the Plaguebringer
  	{29212  , "Snare"},				-- Cripple
  	-- -- Heigan the Unclean
  	{30112  , "CC"},				-- Frenzied Dive
  	{30109  , "Snare"},				-- Slime Burst
  	-- -- Instructor Razuvious
  	{29061  , "Immune"},			-- Shield Wall (not immune}, 75% damage reduction)
  	{29125  , "Other"},				-- Hopeless (increases damage taken by 5000%)
  	-- -- Gothik the Harvester
  	{11428  , "CC"},				-- Knockdown
  	{27993  , "Snare"},				-- Stomp
  	-- -- Gluth
  	{29685  , "CC"},				-- Terrifying Roar
  	-- -- Sapphiron
  	{28522  , "CC"},				-- Icebolt
  	{28547  , "Snare"},				-- Chill
  	-- -- Kel'Thuzad
  	{28410  , "CC"},				-- Chains of Kel'Thuzad
  	{27808  , "CC"},				-- Frost Blast
  	{28478  , "Snare"},				-- Frostbolt
  	{28479  , "Snare"},				-- Frostbolt
    },
  	------------------------
  {"Classic World Bosses",
  	-- -- Azuregos
  	{23186  , "CC"},				-- Aura of Frost
  	{21099  , "CC"},				-- Frost Breath
  	{22067  , "ImmuneSpell"},		-- Reflection
  	{27564  , "ImmuneSpell"},		-- Reflection
  	{21098  , "Snare"},				-- Chill
  	-- -- Doom Lord Kazzak & Highlord Kruul
  	{8078   , "Snare"},				-- Thunderclap
  	{23931  , "Snare"},				-- Thunderclap
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
  	{5213   , "Snare"},				-- Molten Metal
  	{6435   , "CC"},				-- Smite Slam
  	{6432   , "CC"},				-- Smite Stomp
  	{6264   , "Other"},				-- Nimble Reflexes (chance to parry increased by 75%)
  	{113    , "Root"},				-- Chains of Ice
  	{512    , "Root"},				-- Chains of Ice
  	{5159   , "Snare"},				-- Melt Ore
  	{228    , "CC"},				-- Polymorph: Chicken
  	{6466   , "CC"},				-- Axe Toss
    },
  {"Wailing Caverns",
  	{8040   , "CC"},				-- Druid's Slumber
  	{8147   , "Snare"},				-- Thunderclap
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
  	{9080   , "Snare"},				-- Hamstring
  	{7621   , "CC"},				-- Arugal's Curse
  	{7068   , "Other"},				-- Veil of Shadow
  	{23224  , "Other"},				-- Veil of Shadow
  	{7803   , "CC"},				-- Thundershock
  	{7074   , "Silence"},			-- Screams of the Past
    },
  {"Blackfathom Deeps",
  	{246    , "Snare"},				-- Slow
  	{15531  , "Root"},				-- Frost Nova
  	{6533   , "Root"},				-- Net
  	{8399   , "CC"},				-- Sleep
  	{8379   , "Disarm"},			-- Disarm
  	{18972  , "Snare"},				-- Slow
  	{9672   , "Snare"},				-- Frostbolt
  	{8398   , "Snare"},				-- Frostbolt Volley
  	{8391   , "CC"},				-- Ravage
  	{7645   , "CC"},				-- Dominate Mind
  	{15043  , "Snare"},				-- Frostbolt
    },
  {"The Stockade",
  	{3419   , "Other"},				-- Improved Blocking
  	{7964   , "CC"},				-- Smoke Bomb
  	{6253   , "CC"},				-- Backhand
    },
  {"Gnomeregan",
  	{10737  , "CC"},				-- Hail Storm
  	{15878  , "CC"},				-- Ice Blast
  	{10856  , "CC"},				-- Link Dead
  	{10831  , "ImmuneSpell"},		-- Reflection Field
  	{11820  , "Root"},				-- Electrified Net
  	{10852  , "Root"},				-- Battle Net
  	{10734  , "Snare"},				-- Hail Storm
  	{11264  , "Root"},				-- Ice Blast
  	{10730  , "CC"},				-- Pacify
    },
  {"Razorfen Kraul",
  	{8281   , "Silence"},			-- Sonic Burst
  	{8359   , "CC"},				-- Left for Dead
  	{8285   , "CC"},				-- Rampage
  	{8361   , "Immune"},			-- Purity
  	{8377   , "Root"},				-- Earthgrab
  	{6984   , "Snare"},				-- Frost Shot
  	{18802  , "Snare"},				-- Frost Shot
  	{6728   , "CC"},				-- Enveloping Winds
  	{3248   , "Other"},				-- Improved Blocking
  	{6524   , "CC"},				-- Ground Tremor
    },
  {"Scarlet Monastery",
  	{9438   , "Immune"},			-- Arcane Bubble
  	{13323  , "CC"},				-- Polymorph
  	{8988   , "Silence"},			-- Silence
  	{8989   , "ImmuneSpell"},		-- Whirlwind
  	{13874  , "Immune"},			-- Divine Shield
  	{9256   , "CC"},				-- Deep Sleep
  	{3639   , "Other"},				-- Improved Blocking
  	{6146   , "Snare"},				-- Slow
    },
  {"Razorfen Downs",
  	{12252  , "Root"},				-- Web Spray
  	{15530  , "Snare"},				-- Frostbolt
  	{12946  , "Silence"},			-- Putrid Stench
  	{745    , "Root"},				-- Web
  	{11443  , "Snare"},				-- Cripple
  	{11436  , "Snare"},				-- Slow
  	{12531  , "Snare"},				-- Chilling Touch
  	{12748  , "Root"},				-- Frost Nova
    },
  {"Uldaman",
  	{11876  , "CC"},				-- War Stomp
  	{3636   , "CC"},				-- Crystalline Slumber
  	{9906   , "ImmuneSpell"},		-- Reflection
  	{6726   , "Silence"},			-- Silence
  	{10093  , "Silence"},			-- Harsh Winds
  	{25161  , "Silence"},			-- Harsh Winds
    },
  {"Maraudon",
  	{12747  , "Root"},				-- Entangling Roots
  	{21331  , "Root"},				-- Entangling Roots
  	{21909  , "Root"},				-- Dust Field
  	{21793  , "Snare"},				-- Twisted Tranquility
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
  	{11089  , "ImmunePhysical"},	-- Theka Transform (also immune to shadow damage)
  	{12551  , "Snare"},				-- Frost Shot
  	{11836  , "CC"},				-- Freeze Solid
  	{11131  , "Snare"},				-- Icicle
  	{11641  , "CC"},				-- Hex
    },
  {"The Temple of Atal'Hakkar (Sunken Temple)",
  	{12888  , "CC"},				-- Cause Insanity
  	{12480  , "CC"},				-- Hex of Jammal'an
  	{12890  , "CC"},				-- Deep Slumber
  	{6607   , "CC"},				-- Lash
  	{33126  , "Disarm"},			-- Dropped Weapon
  	{25774  , "CC"},				-- Mind Shatter
  	{7992   , "Snare"},				-- Slowing Poison
    },
  {"Blackrock Depths",
  	{8994   , "CC"},				-- Banish
  	{15588  , "Snare"},				-- Thunderclap
  	{12674  , "Root"},				-- Frost Nova
  	{12675  , "Snare"},				-- Frostbolt
  	{15244  , "Snare"},				-- Cone of Cold
  	{15636  , "ImmuneSpell"},		-- Avatar of Flame
  	{7121   , "ImmuneSpell"},		-- Anti-Magic Shield
  	{15471  , "Silence"},			-- Enveloping Web
  	{3609   , "CC"},				-- Paralyzing Poison
  	{15474  , "Root"},				-- Web Explosion
  	{17492  , "CC"},				-- Hand of Thaurissan
  	{12169  , "Other"},				-- Shield Block
  	{15062  , "Immune"},			-- Shield Wall (not immune}, 75% damage reduction)
  	{14030  , "Root"},				-- Hooked Net
  	{14870  , "CC"},				-- Drunken Stupor
  	{13902  , "CC"},				-- Fist of Ragnaros
  	{15063  , "Root"},				-- Frost Nova
  	{6945   , "CC"},				-- Chest Pains
  	{3551   , "CC"},				-- Skull Crack
  	{15621  , "CC"},				-- Skull Crack
  	{11831  , "Root"},				-- Frost Nova
  	{15499  , "Snare"},				-- Frost Shock
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
  	{16046  , "Snare"},				-- Blast Wave
  	{15744  , "Snare"},				-- Blast Wave
  	{16249  , "Snare"},				-- Frostbolt
  	{16469  , "Root"},				-- Web Explosion
  	{15532  , "Root"},				-- Frost Nova
    },
  {"Stratholme",
  	{17398  , "CC"},				-- Balnazzar Transform Stun
  	{17405  , "CC"},				-- Domination
  	{17246  , "CC"},				-- Possessed
  	{19832  , "CC"},				-- Possess
  	{15655  , "CC"},				-- Shield Slam
  	{19645  , "ImmuneSpell"},		-- Anti-Magic Shield
  	{16799  , "Snare"},				-- Frostbolt
  	{16798  , "CC"},				-- Enchanting Lullaby
  	{12542  , "CC"},				-- Fear
  	{12734  , "CC"},				-- Ground Smash
  	{17293  , "CC"},				-- Burning Winds
  	{4962   , "Root"},				-- Encasing Webs
  	{13322  , "Snare"},				-- Frostbolt
  	{15089  , "Snare"},				-- Frost Shock
  	{12557  , "Snare"},				-- Cone of Cold
  	{16869  , "CC"},				-- Ice Tomb
  	{17244  , "CC"},				-- Possess
  	{17307  , "CC"},				-- Knockout
  	{15970  , "CC"},				-- Sleep
  	{14897  , "Snare"},				-- Slowing Poison
  	{3589   , "Silence"},			-- Deafening Screech
    },
  {"Dire Maul",
  	{27553  , "CC"},				-- Maul
  	{17145  , "Snare"},				-- Blast Wave
  	{22651  , "CC"},				-- Sacrifice
  	{22419  , "Disarm"},			-- Riptide
  	{22691  , "Disarm"},			-- Disarm
  	{22833  , "CC"},				-- Booze Spit (chance to hit reduced by 75%)
  	{22856  , "CC"},				-- Ice Lock
  	{16727  , "CC"},				-- War Stomp
  	--{22735  , "ImmuneSpell"},		-- Spirit of Runn Tum (not immune}, 50% chance reflect spells)
  	{22994  , "Root"},				-- Entangle
  	{22924  , "Root"},				-- Grasping Vines
  	{22914  , "Snare"},				-- Concussive Shot
  	{22915  , "CC"},				-- Improved Concussive Shot
  	{22919  , "Snare"},				-- Mind Flay
  	{22909  , "Snare"},				-- Eye of Immol'thar
  	{28858  , "Root"},				-- Entangling Roots
  	{22415  , "Root"},				-- Entangling Roots
  	{22744  , "Root"},				-- Chains of Ice
  	{16856  , "Other"},				-- Mortal Strike (healing effects reduced by 50%)
  	{12611  , "Snare"},				-- Cone of Cold
  	{16838  , "Silence"},			-- Banshee Shriek
  	{22519  , "CC"},				-- Ice Nova
  	{22356  , "Snare"},				-- Slow
    },
  {"Scholomance",
  	{5708   , "CC"},				-- Swoop
  	{18144  , "CC"},				-- Swoop
  	{18103  , "CC"},				-- Backhand
  	{8208   , "CC"},				-- Backhand
  	{12461  , "CC"},				-- Backhand
  	{8140   , "Other"},				-- Befuddlement

  	{27565  , "CC"},				-- Banish

  	{16350  , "CC"},				-- Freeze

  },


{"Discovered Spells"
},
}

local tabs = {
  "CC",
	"Interrupt",
	"Silence",
	"Root",
	"Disarm",
  "Other"
	}

L.spellsTable = spellsTable

local tabsIndex = {}
for i = 1, #tabs do
	tabsIndex[tabs[i]] = i
end

local DBdefaults = {
 Scale = .65,
 xOfs = 0,
 yOfs = -30,
 version = 2.07,
 LossOfControl = true,
 LossOfControlInterrupt = 2,
 LossOfControlFull = 2,
 LossOfControlSilence = 2,
 LossOfControlDisarm = 2,
 LossOfControlRoot = 2,
 DiscoveredSpells = { },
 spellEnabled = { },
 customSpellIds = { },
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
	elseif event == "PLAYER_ENTERING_WORLD" then
		EasyCC:OnLoad()
	elseif event == "ADDON_LOADED" and ... == addonName then
		EasyCC:ADDON_LOADED(addonName)
	end
end)

 -- this is a custom function
---EasyCC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EasyCC:RegisterEvent("PLAYER_ENTERING_WORLD")
EasyCC:RegisterEvent("ADDON_LOADED")
EasyCC:RegisterEvent("LOSS_OF_CONTROL_ADDED")
EasyCC:RegisterEvent("LOSS_OF_CONTROL_UPDATE")


function EasyCC:cleu()
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, _, _, spellSchool = CombatLogGetCurrentEventInfo()
	if (event == "SPELL_INTERRUPT") then
		print(sourceName.." kicked "..destName.." w/ "..spellName.. " on "..spellSchool.." LCI")
		if destGUID == UnitGUID("player") then
			_, _, icon = GetSpellInfo(spellId)
			duration = spells[spellId]
			if self.test then EasyCC:toggletest() end
			local string = EasyCC:stringcleu(spellSchool)
			EasyCC:Display(icon, duration, string)
		end
	end
	if (event == "SPELL_CAST_SUCCESS") and not (event == "SPELL_INTERRUPT") then --channleed kicks on player
		if spells[spellId] then
			if (destGUID == UnitGUID("player")) and (select(7, UnitChannelInfo("player")) == false) then
			 print(sourceName.." kicked "..destName.." w/ "..spellName.. " on spellschool: "..spellSchool.." LCI")
			 local duration = spells[spellId]
				if (duration ~= nil) then
					_, _, icon = GetSpellInfo(spellId)
					duration = spells[spellId]
					if self.test then EasyCC:toggletest() end
					local string = EasyCC:stringcleu(spellSchool)
					EasyCC:Display(icon, duration, string)
				end
			end
		end
	end
end

function EasyCC:LossOfControl(data, Index)
 	if not data then f:Hide(); self.priority = nil; self.startTime = nil; return end
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
	if not spellIds[spellID] then EasyCC:NewSpell(spellID, locType, lockoutSchool, duration) end --Need to filter out deleted spells fron DB or will keep finding same spell thats been deleted
	if EasyCCDB.LossOfControl and EasyCCDB.spellEnabled[spellID] and ((not self.priority or (priority > self.priority or priority == self.priority )) or not f:IsShown()) and (not self.startTime or startTime ~= self.startTime) then
  	if displayType ~= DISPLAY_TYPE_NONE then
      self.priority = priority; self.startTime = startTime; self.start = startTime; self.spellID = spellID
			if (locType == "STUN_MECHANIC") or (locType =="PACIFY") or (locType =="STUN") or (locType =="FEAR") or (locType =="CHARM") or (locType =="CONFUSE") or (locType =="POSSESS") or (locType =="FEAR_MECHANIC") or (locType =="FEAR") then
				if EasyCCDB.LossOfControlFull == "2" or EasyCCDB.LossOfControlFull == 2 then
					EasyCC:Display(iconTexture, duration, text, true)
				elseif EasyCCDB.LossOfControlFull == "1" or EasyCCDB.LossOfControlFull == 1 then
					EasyCC:Display(iconTexture, duration, text, false)
				end
			elseif locType == "DISARM" then
				if EasyCCDB.LossOfControlDisarm  == "2" or EasyCCDB.LossOfControlDisarm == 2 then
					EasyCC:Display(iconTexture, duration, text, true)
				elseif EasyCCDB.LossOfControlDisarm  == "1" or EasyCCDB.LossOfControlDisarm  == 1 then
					EasyCC:Display(iconTexture, duration, text, false)
				end
			elseif (locType == "PACIFYSILENCE") or (locType =="SILENCE") then
				if EasyCCDB.LossOfControlSilence  == "2" or EasyCCDB.LossOfControlSilence  == 2 then
					EasyCC:Display(iconTexture, duration, text, true)
				elseif EasyCCDB.LossOfControlSilence  == "1" or EasyCCDB.LossOfControlSilence  == 1 then
					EasyCC:Display(iconTexture, duration, text, false)
				end
			elseif locType == "ROOT" then
				if EasyCCDB.LossOfControlRoot == "2" or EasyCCDB.LossOfControlRoot == 2 then
					EasyCC:Display(iconTexture, duration, text, true)
				elseif EasyCCDB.LossOfControlRoot == "1" or EasyCCDB.LossOfControlRoot == 1 then
					EasyCC:Display(iconTexture, duration, text, false)
				end
			elseif locType == "SCHOOL_INTERRUPT" then
				text = string.format("%s Locked", GetSchoolString(lockoutSchool));
				if EasyCCDB.LossOfControlInterrupt == "2" or EasyCCDB.LossOfControlInterrupt == 2 then
					EasyCC:Display(iconTexture, duration, text, true)
				elseif EasyCCDB.LossOfControlInterrupt == "1" or EasyCCDB.LossOfControlInterrupt == 1 then
					EasyCC:Display(iconTexture, duration, text, false)
				end
			else
			end
		end
	end
end

function EasyCC:NewSpell(spellID, locType, lockoutSchool, duration)
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
    Type = "Other"; print("EasyCC Discovered New Other " ..spell);
  end
  spellIds[spellID] = Type; EasyCCDB.spellEnabled[spellID]= true
  tblinsert(EasyCCDB.customSpellIds, {spellID, Type, instanceType, name.."\n"..ZoneName, "Discovered", #L.spells})
  tblinsert(L.spells[#L.spells][tabsIndex[Type]], {spellID, Type, instanceType, name.."\n"..ZoneName, "Discovered", #L.spells})
  L.Spells:UpdateTab(#L.spells)
end


function EasyCC:Display(icon, duration, string, full)
	if self.test then time = 30; self.start = GetTime() elseif full then time = duration else time = 2 end
	if f and f:IsShown() then f:Hide(); self.priority = nil; self.startTime = nil end
	if string then
		f.Ltext:SetText(string)
	end
	if icon then --icon control here
		f.Icon.texture:SetTexture(icon)
	else
		f.Icon.texture:SetTexture(132219)
	end
	if duration and duration ~= 0 then --duration control here
		f.Icon.cooldown:SetCooldown(GetTime(), duration)
		f.Icon.cooldown:SetSwipeColor(0, 0, 0, 1)
		f.Ltext:ClearAllPoints()
		f.timer:ClearAllPoints()
		f.Ltext:SetPoint("LEFT", f.Icon, "RIGHT", 5, 9)
	  f.timer:SetPoint("LEFT", f.Icon, "RIGHT", 5, -14)
		f.timer:Show()
	else
		f.Icon.cooldown:SetCooldown(GetTime(), 0)
		f.Icon.cooldown:SetSwipeColor(0, 0, 0, 0)
		f.Ltext:ClearAllPoints()
		f.Ltext:SetPoint("LEFT", f.Icon, "RIGHT", 7.5, 0)
		f.timer:Hide()
	end
	if IsAddOnLoaded("BambiUI") then
		point, relativeTo, relativePoint, xOfs, yOfs = PartyAnchor5:GetPoint()
		y = yOfs
		x = 0
	else
		y = EasyCCDB.yOfs
		x = EasyCCDB.xOfs
	end
	f.barB.texture:SetWidth(f.Icon:GetWidth() + (string.len(f.Ltext:GetText()) * 21))
	f.barU.texture:SetWidth(f.Icon:GetWidth() + (string.len(f.Ltext:GetText()) * 21))
	f.barU.texture:ClearAllPoints()
	f.barB.texture:ClearAllPoints()
	f.barU.texture:SetPoint("BOTTOM", f, "TOP", 0, 3)
	f.barB.texture:SetPoint("TOP", f, "BOTTOM", 0, -3)
	f:SetWidth(f.Icon:GetWidth() + (string.len(f.Ltext:GetText()) * 16))
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "CENTER", x, y)
	f:Show()
end

function EasyCC:OnLoad()
	if not f then --create the frame
		f = CreateFrame("Frame")
		f:SetIgnoreParentScale(true)
		f:SetScale(EasyCCDB.Scale)
		f:SetParent(UIParent)
		f:SetFrameStrata("HIGH")
		f:SetHeight(hieght)
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
		f.Ltext = f.Icon:CreateFontString(nil, "OVERLAY")
		f.Ltext:SetFont("Fonts\\FRIZQT__.TTF", 24, "THICKOUTLINE, SHADOW" )
		f.Ltext:SetTextColor(1, .6, 0, 1)
		f.Ltext:SetJustifyH("LEFT")
		f.Ltext:SetParent(f.Icon)
		f.timer = f.Icon:CreateFontString(nil, "OVERLAY")
		f.timer:SetParent(f.Icon)
		f.timer:SetFont("Fonts\\FRIZQT__.TTF", 20, "THICKOUTLINE")
		f.Ltext:SetJustifyH("LEFT")
		local text = f.timer
		local ONUPDATE_INTERVAL = 1; local start
		f.barU = CreateFrame("Frame", "f.barU")
		f.barU.texture = f.barU:CreateTexture(f.barU, 'BACKGROUND')
		f.barU.texture:SetTexture("Interface\\Cooldown\\Loc-RedLine")
		f.barU.texture:SetHeight(17)
		f.barU.texture:SetParent(f)
		f.barB = CreateFrame("Frame", "f.barU")
		f.barB.texture = f.barB:CreateTexture(f.barB, 'BACKGROUND')
		f.barB.texture:SetTexture("Interface\\Cooldown\\Loc-RedLine")
		f.barB.texture:SetHeight(17)
		f.barB.texture:SetParent(f)
		f.barB.texture:SetRotation(math.rad(180))
		-- The number of seconds since the last update, script to set the duration to show before fading
		f.Icon:SetScript("OnUpdate", function(self, elapsed)
			if TimeSinceLastUpdate == 0 then start = EasyCC.start or 0 end
			text:SetText(string.format("%.1f", start - GetTime() + (f.Icon.cooldown:GetCooldownDuration()/1000)) .." seconds")
			TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
			if TimeSinceLastUpdate >= time then
				TimeSinceLastUpdate = 0
				if f and f:IsShown() then f:Hide(); self.priority = nil; self.startTime = nil; end
	      if EasyCC.test then EasyCC:toggletest() end
			end
		end)
		-- When the frame is shown, reset the update f.timer
		f.Icon:SetScript("OnShow", function(self)
			TimeSinceLastUpdate = 0
		end)
		f:SetScript("OnEvent", self.OnEvent)
		f:SetScript("OnDragStart", self.StartMoving) -- this function is already built into the Frame class
		f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
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
				if (_G.EasyCCDB[j] == nil) then
					_G.EasyCCDB[j] = u
					print("EasyCC Option "..j.." Added w/ Update.")
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
		--Build Custom Table for Check
		for k, v in ipairs(EasyCCDB.customSpellIds) do
			local spellID, prio, _, _, _, tabId  = unpack(v)
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
        if prio == "CC" or prio == "Interrupt" or prio == "Silence" or prio == "Root" or prio == "Disarm" or prio == "Other" then
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
			for k,v in ipairs(EasyCCDB.customSpellIds) do
				local spellID, prio, instanceType, zone, customname, row, position  = unpack(v)
				if prio ~= "Delete" then
          if customname == "Discovered" then row = #spells end
					if position then
          	tblinsert(spells[row][position], 1, v)
					else
            tblinsert(spells[row][tabsIndex[prio]], 1, v) --v[7]: Category to enter spell / v[8]: Tab to update / v[9]: Table
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
		for k in pairs(spellIds) do --spellIds is the combined PVE list, Spell List and the Discovered & Custom lists from tblinsert above
			if EasyCCDB.spellEnabled[k] == nil then
			EasyCCDB.spellEnabled[k]= true
			end
		end
    if EasyCCDB.LossOfControl then SetCVar("lossOfControl", 1) else SetCVar("lossOfControl", 0) end
    if EasyCCDB.LossOfControlInterrupt == "2" then SetCVar("lossOfControlInterrupt", 2) elseif EasyCCDB.LossOfControlInterrupt == "1" then SetCVar("lossOfControlInterrupt", 1) else SetCVar("lossOfControlInterrupt", 0) end
    if EasyCCDB.LossOfControlFull == "2" then SetCVar("lossOfControlFull", 2) elseif EasyCCDB.LossOfControlFull == "1" then SetCVar("lossOfControlFull", 1) else SetCVar("lossOfControlFull", 0) end
    if EasyCCDB.LossOfControlSilence == "2" then SetCVar("lossOfControlSilence", 2) elseif EasyCCDB.LossOfControlSilence == "1" then SetCVar("lossOfControlSilence", 1) else SetCVar("lossOfControlSilence", 0) end
    if EasyCCDB.LossOfControlDisarm == "2" then SetCVar("lossOfControlDisarm", 2) elseif EasyCCDB.LossOfControlDisarm == "1" then SetCVar("lossOfControlDisarm", 1) else SetCVar("lossOfControlDisarm", 0) end
    if EasyCCDB.LossOfControlRoot == "2" then SetCVar("lossOfControlRoot", 2) elseif EasyCCDB.LossOfControlRoot == "1" then SetCVar("lossOfControlRoot", 1) else SetCVar("lossOfControlRoot", 0) end
end


local teststring = {"Holy Locked", "Polymorph", "Shadow Locked", "Stunned", "Feared"}
local mytime = {30, 35, 40, 40, 0, 0, 0}

function EasyCC:toggletest()
	if not self.test then
		self.test = true
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Test Mode On")
		local string = teststring[ math.random( #teststring )]
    local keys = {} -- for random icon sillyness
    for k in pairs(spellIds) do
      tinsert(keys, k)
    end
    local _, _, icon = GetSpellInfo(keys[random(#keys)])
		EasyCC:Display(icon, mytime[ math.random( #mytime ) ], string )
		f:SetMovable(true)
		f:RegisterForDrag("LeftButton", "RightButton")
		f:EnableMouse(true)
	else
		self.test = nil
		TimeSinceLastUpdate = 0
		if f and f:IsShown() then f:Hide() end
		f:EnableMouse(false)
		f:RegisterForDrag()
		f:SetMovable(false)
		local frame = f
		frame.point, frame.anchor, frame.relativePoint, frame.x, frame.y = f:GetPoint()
    EasyCCDB.yOfs = frame.y
    EasyCCDB.xOfs = frame.x
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Test Mode Off")
	end
end



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

local Spells = CreateFrame("Button", O.."Spells", OptionsPanel, "OptionsButtonTemplate")
_G[O.."Spells"]:SetText("Spells")
Spells:SetHeight(28)
Spells:SetWidth(100)
Spells:SetScale(1)
Spells:SetScript("OnClick", function(self)
L.Spells:Toggle()
end)
Spells:SetPoint("LEFT", title, "RIGHT", 10, 3)

local BambiText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
BambiText:SetFont("Fonts\\MORPHEUS.ttf", 20 )
BambiText:SetText("By ".."|cff00ccffBambi|r")
BambiText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 60, 1)

local unlocknewline = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
unlocknewline:SetFont("Fonts\\FRIZQT__.TTF", 16 )
unlocknewline:SetText(" (drag an icon to move)")


-- "Unlock" checkbox - allow the frames to be moved
local Unlock = CreateFrame("CheckButton", O.."Unlock", OptionsPanel, "OptionsCheckButtonTemplate")
function Unlock:OnClick()
	if self:GetChecked() then
		unlocknewline:SetPoint("LEFT", Unlock, "RIGHT", 69, 0)
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
unlock:SetText("Unlock")
unlock:SetPoint("LEFT", Unlock, "RIGHT", 6, 0)

local Scale
Scale = CreateSlider("EasyCC Scale", OptionsPanel, .2, 1.5, .01, "EasyCC Scale")
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
LossOfControlFull:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("LossOfControlFull".. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.LossOfControlFull = ("%.0f"):format(value)-- the real alpha value
	SetCVar("lossOfControlFull", ("%.0f"):format(value))
end)


local LossOfControlSilence
LossOfControlSilence = CreateSlider("LossOfControlSilence", OptionsPanel, 0, 2, 1, "LossOfControlSilence")
LossOfControlSilence:SetScript("OnValueChanged", function(self, value)
LossOfControlSilence:SetScale(1)
LossOfControlSilence:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("LossOfControlSilence" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.LossOfControlSilence = ("%.0f"):format(value)-- the real alpha value
	SetCVar("lossOfControlSilence", ("%.0f"):format(value))
end)

local LossOfControlInterrupt
LossOfControlInterrupt = CreateSlider("LossOfControlInterrupt", OptionsPanel, 0, 2, 1, "LossOfControlInterrupt")
LossOfControlInterrupt:SetScript("OnValueChanged", function(self, value)
LossOfControlInterrupt:SetScale(1)
LossOfControlInterrupt:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("LossOfControlInterrupt" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.LossOfControlInterrupt = ("%.0f"):format(value)-- the real alpha value
	SetCVar("lossOfControlInterrupt", ("%.0f"):format(value))
end)

local LossOfControlDisarm
LossOfControlDisarm = CreateSlider("LossOfControlDisarm", OptionsPanel, 0, 2, 1, "LossOfControlDisarm")
LossOfControlDisarm:SetScript("OnValueChanged", function(self, value)
LossOfControlDisarm:SetScale(1)
LossOfControlDisarm:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("LossOfControlDisarm" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.LossOfControlDisarm = ("%.0f"):format(value)-- the real alpha value
	SetCVar("lossOfControlDisarm", ("%.0f"):format(value))
end)

local LossOfControlRoot
LossOfControlRoot = CreateSlider("LossOfControlRoot", OptionsPanel, 0, 2, 1, "LossOfControlRoot")
LossOfControlRoot:SetScript("OnValueChanged", function(self, value)
LossOfControlRoot:SetScale(1)
LossOfControlRoot:SetWidth(200)
	_G[self:GetName() .. "Text"]:SetText("LossOfControlRoot" .. " (" .. ("%.0f"):format(value) .. ")")
	EasyCCDB.LossOfControlRoot = ("%.0f"):format(value)-- the real alpha value
	SetCVar("lossOfControlRoot", ("%.0f"):format(value))
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
	else
		SetCVar("LossOfControl", 0)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlInterrupt)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlFull)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlSilence)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlDisarm)
		BlizzardOptionsPanel_Slider_Disable(LossOfControlRoot)
	end
end)

if Unlock then Unlock:SetPoint("TOPLEFT",  title, "BOTTOMLEFT", 0, -30) end
if Scale then Scale:SetPoint("TOPLEFT", Unlock, "BOTTOMLEFT", 5, -35) end
if LossOfControl then LossOfControl:SetPoint("TOPLEFT", Scale, "BOTTOMLEFT", 5, -25) end
if LossOfControlFull then LossOfControlFull:SetPoint("TOPLEFT", LossOfControl, "BOTTOMLEFT", 0, -25) end
if LossOfControlSilence then LossOfControlSilence:SetPoint("TOPLEFT", LossOfControlFull, "BOTTOMLEFT", 0, -25) end
if LossOfControlInterrupt then LossOfControlInterrupt:SetPoint("TOPLEFT", LossOfControlSilence, "BOTTOMLEFT", 0, -25) end
if LossOfControlDisarm then LossOfControlDisarm:SetPoint("TOPLEFT", LossOfControlInterrupt, "BOTTOMLEFT", 0, -25) end
if LossOfControlRoot then LossOfControlRoot:SetPoint("TOPLEFT", LossOfControlDisarm, "BOTTOMLEFT", 0, -25) end

local LoCOptions = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
LoCOptions:SetFont("Fonts\\FRIZQT__.TTF", 12 )
LoCOptions:SetText("Blizzard Loss of Control must be enabled to discover new spells \n\n|cffff00000:|r Disables Icon Type \n1: Shows icon for short duartion \n|cff00ff002:|r Shows icon for full duration \n \n ")
LoCOptions:SetJustifyH("LEFT")
LoCOptions:SetPoint("TOPLEFT", LossOfControlRoot, "TOPLEFT", 0, -30)


-------------------------------------------------------------------------------
OptionsPanel.default = function() -- This method will run when the player clicks "defaults"
	L.Spells:ResetAllSpellList()
	_G.EasyCCDB = nil
	L.Spells:WipeAll()
	EasyCC:ADDON_LOADED(addonName)
	L.Spells:UpdateAll()
  BlizzardOptionsPanel_Slider_Enable(LossOfControlInterrupt)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlFull)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlSilence)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlDisarm)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlRoot)
  if EasyCC.test then EasyCC:toggletest() end
end

OptionsPanel.refresh = function()
	 -- This method will run when the Interface Options frame calls its OnShow function and after defaults have been applied via the panel.default method described above.
	LossOfControl:SetChecked(EasyCCDB.LossOfControl)
	LossOfControlInterrupt:SetValue(EasyCCDB.LossOfControlInterrupt)
	LossOfControlFull:SetValue(EasyCCDB.LossOfControlFull)
	LossOfControlSilence:SetValue(EasyCCDB.LossOfControlSilence)
	LossOfControlDisarm:SetValue(EasyCCDB.LossOfControlDisarm)
	LossOfControlRoot:SetValue(EasyCCDB.LossOfControlRoot)
	Scale:SetValue(EasyCCDB.Scale)
  if EasyCC.test then Unlock:SetChecked(true) else Unlock:SetChecked(false) end
  if EasyCCDB.LossOfControl then SetCVar("lossOfControl", 1) else SetCVar("lossOfControl", 0) end
  if EasyCCDB.LossOfControlInterrupt == "2" then SetCVar("lossOfControlInterrupt", 2) elseif EasyCCDB.LossOfControlInterrupt == "1" then SetCVar("lossOfControlInterrupt", 1) else SetCVar("lossOfControlInterrupt", 0) end
  if EasyCCDB.LossOfControlFull == "2" then SetCVar("lossOfControlFull", 2) elseif EasyCCDB.LossOfControlFull == "1" then SetCVar("lossOfControlFull", 1) else SetCVar("lossOfControlFull", 0) end
  if EasyCCDB.LossOfControlSilence == "2" then SetCVar("lossOfControlSilence", 2) elseif EasyCCDB.LossOfControlSilence == "1" then SetCVar("lossOfControlSilence", 1) else SetCVar("lossOfControlSilence", 0) end
  if EasyCCDB.LossOfControlDisarm == "2" then SetCVar("lossOfControlDisarm", 2) elseif EasyCCDB.LossOfControlDisarm == "1" then SetCVar("lossOfControlDisarm", 1) else SetCVar("lossOfControlDisarm", 0) end
  if EasyCCDB.LossOfControlRoot == "2" then SetCVar("lossOfControlRoot", 2) elseif EasyCCDB.LossOfControlRoot == "1" then SetCVar("lossOfControlRoot", 1) else SetCVar("lossOfControlRoot", 0) end
end

InterfaceOptions_AddCategory(OptionsPanel)


SLASH_ECC1 = "/ecc"

local SlashCmd = {}
function SlashCmd:test()
	EasyCC:toggletest()
end

function SlashCmd:reset()
	print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Reset")
  L.Spells:ResetAllSpellList()
  _G.EasyCCDB = nil
  L.Spells:WipeAll()
  EasyCC:ADDON_LOADED(addonName)
  L.Spells:UpdateAll()
  BlizzardOptionsPanel_Slider_Enable(LossOfControlInterrupt)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlFull)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlSilence)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlDisarm)
  BlizzardOptionsPanel_Slider_Enable(LossOfControlRoot)
  LossOfControl:SetChecked(EasyCCDB.LossOfControl)
  LossOfControlInterrupt:SetValue(EasyCCDB.LossOfControlInterrupt)
  LossOfControlFull:SetValue(EasyCCDB.LossOfControlFull)
  LossOfControlSilence:SetValue(EasyCCDB.LossOfControlSilence)
  LossOfControlDisarm:SetValue(EasyCCDB.LossOfControlDisarm)
  LossOfControlRoot:SetValue(EasyCCDB.LossOfControlRoot)
  if EasyCC.test then EasyCC:toggletest() end
end

SlashCmdList["ECC"] = function(cmd)
	local args = {}
	for word in cmd:lower():gmatch("%S+") do
		tinsert(args, word)
	end
	if SlashCmd[args[1]] then
		SlashCmd[args[1]](unpack(args))
	else
		print("|cff00ccffEasyCC|r","|cffFF7D0A (TBC)|r",": Type \"/ecc test\" for testing or /ecc reset.")
	end
end
