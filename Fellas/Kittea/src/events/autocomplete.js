const { Events, MessageFlags } = require('discord.js');

module.exports = {
	name: Events.InteractionCreate,
	async execute(interaction) {
		if (!interaction.isAutocomplete()) return;
		if (!interaction.member.roles.cache.has(ACCESS_ROLE)) return;
		const command = interaction.client.commands.get(interaction.commandName);
		if (!command) return;
		
		try {
			await command.autofill(interaction);
		} catch (error) {
			console.log(error);
		}
	},
};