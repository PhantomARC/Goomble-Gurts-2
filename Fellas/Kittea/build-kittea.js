// Globals - ROOT for callables/subfuncs path
global.ROOT = process.cwd();


/** Library Dependencies
 *  discord.js - for interactions with Discord.com
 *  fs - for file parsing and writing.
 *  path - for joining directories
 */
const FS = require('node:fs');
const PATH = require('node:path');
const { REST, Routes } = require('discord.js');


/** File Dependencies
 *  config.json - for token, guild and client identification
 *  fetchData.js - function subset for returning relevant data
 */
const { clientId, guildId, token } = require(PATH.join(ROOT, 'src', 'config', 'config.json'));


// Miscellaneous Variables
const commands = [];
const cmdPath = PATH.join(ROOT, 'src', 'commands');
const cmdDir = FS.readdirSync(cmdPath);


// Run Program (Java-style, structured)
main();


/** @func main
 *  the primary function to run
 */
async function main() {
	for (const folder of cmdDir) {
		const uDir = PATH.join(cmdPath, folder);
		const cmdList = FS.readdirSync(uDir).filter((file) => file.endsWith('.js'));
		for (const file of cmdList) {
			const filePath = PATH.join(uDir, file);
			const cmd = require(filePath);
			if ('data' in cmd && 'execute' in cmd) {
				commands.push(cmd.data.toJSON());
			} else {
				console.log(`${filePath} is missing a "data" or "execute" property.`);
			}
		}
	}

	const rest = new REST().setToken(token);
	await rest.put(Routes.applicationGuildCommands(clientId, guildId), { body: commands })
			.then(() => console.log('Kittea.js has been updated and is ready to deploy.'))
			.catch(console.error);
}


	// //Search Move
	// new SlashCommandBuilder()
		// .setName('move')
		// .setDescription('Look up a Move!')
			// .addStringOption(option =>option
				// .setName('move')
				// .setDescription('What move do you want information about?')
				// .setAutocomplete(true)
				// .setRequired(true)),
	// //Search Passive
	// new SlashCommandBuilder()
		// .setName('passive')
		// .setDescription('Look up a Passive!')
			// .addStringOption(option =>option
				// .setName('passive')
				// .setDescription('What passive do you want to know about?')
				// .setAutocomplete(true)
				// .setRequired(true)),  
	// //Display Goomblepedia Table of Contents
	// new SlashCommandBuilder()
		// .setName('list_goombles')
		// .setDescription('View the full list of Goombles!'),  
	// //Display Movepedia Table of Contents
	// new SlashCommandBuilder()
		// .setName('list_moves')
		// .setDescription('View the full list of moves!'), 
	// //Display Passivepedia Table of Contents
	// new SlashCommandBuilder()
		// .setName('list_passives')
		// .setDescription('View the full list of passives!'),  



