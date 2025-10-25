const { Events, MessageFlags } = require('discord.js');
const MFE = MessageFlags.Ephemeral;


module.exports = {
	name: Events.InteractionCreate,
	async execute(interaction) {
		if (interaction.member.roles.cache.has(ACCESS_ROLE)) {
			await slashCMD(interaction);
			await buttonCMD(interaction);
			await selectCMD(interaction);
		}
	},
};


/* SLASH COMMANDS */
async function slashCMD(interaction) {
	if (!interaction.isCommand()) return;
	const command = interaction.client.commands.get(interaction.commandName);
	if (!command) return;
	
	try {
		await command.execute(interaction);
	} catch (error) {
		console.log(error);
		const replErr = { content: 'There was an error while executing this command!', flags: MFE };
		if (interaction.replied || interaction.deferred) {
			await interaction.followUp(replErr);
		} else {
			await interaction.reply(replErr);
		}
	}
}


/* BUTTON COMMANDS */
async function buttonCMD(interaction) {
	if (!interaction.isButton()) return;
	const DELIMITER = '★';
	const cmdParams = interaction.customId.split(DELIMITER);
	const cmdName = cmdParams.shift();
	const command = interaction.client.commands.get(cmdName);
	
	//special case commands
	if (!command) {
		
		if (cmdName === 'moveLink') {
			const command = interaction.client.commands.get('move');
			try {
				await command.genSources(cmdParams.shift(), interaction);
			} catch (error) {
				console.log(error);
				await sendError(interaction);
			}
			return;
		}
		console.log(`Unhandled Button Command: ${cmdName}`);
		await sendError(interaction);
		return;
	}
	
	try {
		await command.buttonResponse(cmdParams.shift(), interaction);
	} catch (error) {
		console.log(error);
		await sendError(interaction);
	}
}

/* SELECT COMMANDS */
async function selectCMD(interaction) {
	if (!interaction.isStringSelectMenu()) return;
	const command = interaction.client.commands.get(interaction.customId);
	try {
		await command.buttonResponse(interaction.values[0], interaction);
	} catch (error) {
		console.log(error);
		await sendError(interaction);
	}
}

/* Return Errors */
async function sendError(interaction) {
	const replErr = { content: 'There was an error with this selection...', flags: MFE };
	if (interaction.replied || interaction.deferred) {
		await interaction.followUp(replErr);
	} else {
		await interaction.reply(replErr);
	}
}