Config = {
	Default_Prio = 500000, -- This is the default priority value if a discord isn't found
	AllowedPerTick = 100, -- How many players should we allow to connect at a time?
	CheckForGhostUsers = 3, -- How many seconds should the script check for ghosts users in the queue?
	HostDisplayQueue = true,
	onlyActiveWhenFull = false,
	Requirements = { -- A player must have the identifier to be allowed into the server
		Discord = false,
		Steam = false
	},
	WhitelistRequired = false, -- If this option is set to true, a player must have a role in Config.Rankings to be allowed into the server
	Debug = true,
	Webhook = 'WEBHOOK_HERE',
	Displays = {
		Prefix = '[Ethnic-queue]',
		ConnectingLoop = { 
			'🐌', 
			'🐍',
			'🐎', 
			'🐑', 
			'🐒',
			'🐘', 
			'🐙', 
			'🐛',
			'🐜',
			'🐝',
			'🐞',
			'🐟',
			'🐠',
			'🐡',
			'🐢',
			'🐤',
			'🐦',
			'🐧',
			'🐩',
			'🐫',
			'🐬',
			'🐲',
			'🐳',
			'🐴',
			'🐅',
			'🐈',
			'🐉',
			'🐋',
			'🐀',
			'🐇',
			'🐏',
			'🐐',
			'🐓',
			'🐕',
			'🐖',
			'🐪',
			'🐆',
			'🐄',
			'🐃',
			'🐂',
			'🐁',
			'🔥'
		},
		Messages = {
			MSG_CONNECTING = 'You are {QUEUE_NUM}/{QUEUE_MAX}', -- Default message if they have no discord roles 
			MSG_CONNECTED = 'Connecting...',
			MSG_QUEUE = 'You are {QUEUE_NUM}/{QUEUE_MAX} in queue ',
			MSG_DISCORD_REQUIRED = 'Discord is not connected on your FiveM Account. You must have your Discord connected to your FiveM Account to play.',
			MSG_STEAM_REQUIRED = 'Steam is not connected on your FiveM Account. You must have your Steam connected to your FiveM Account to play.',
			MSG_NOT_WHITELISTED = '⚜️ Join the Ethnic Framework Discord & Do an intake to gain access to the Ethnic GTA RP Server: https://discord.gg/Ethnic-coll',
		},
	},
}

Config.Rankings = {
	-- LOWER NUMBER === HIGHER PRIORITY 
	-- [''] = {25, "You are {QUEUE_NUM}/{QUEUE_MAX} in queue. Please Wait.\n⚜️ See our discord for more information: https://discord.gg/Ethnic-coll\n FiveM Account: LINKED ✔️\n Priority Queue: Intaker 🎙\n⚠️ If you should have Priority Queue then close your game and wait 5 minutes before reconnecting the server again ⚠️"}, -- Admin
	-- [''] = {25, "You are {QUEUE_NUM}/{QUEUE_MAX} in queue. Please Wait.\n⚜️ See our discord for more information: https://discord.gg/Ethnic-coll\n FiveM Account: LINKED ✔️\n Priority Queue: Administrator 🛡\n⚠️ If you should have Priority Queue then close your game and wait 5 minutes before reconnecting the server again ⚠️"}, -- Admin
	-- [''] = {1, "You are {QUEUE_NUM}/{QUEUE_MAX} in queue. Please Wait.\n⚜️ See our discord for more information: https://discord.gg/Ethnic-coll\n FiveM Account: LINKED ✔️\n Priority Queue: Developer 🛠\n⚠️ If you should have Priority Queue then close your game and wait 5 minutes before reconnecting the server again ⚠️"}, -- Developers
	-- [''] = {1, "You are {QUEUE_NUM}/{QUEUE_MAX} in queue. Please Wait.\n⚜️ See our discord for more information: https://discord.gg/Ethnic-coll\n FiveM Account: LINKED ✔️\n Priority Queue: Owner 💎\n⚠️ If you should have Priority Queue then close your game and wait 5 minutes before reconnecting the server again ⚠️"}, -- Founder
}