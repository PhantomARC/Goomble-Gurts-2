/** 
 * Kittea.js (using discord.js@14.23.2)
 * 
 * @version 2.0.3
 * @author <<_ARX>>
 * @timestamp 10/21/2025 7:11 PM PST
 * 
 * Written as a companion app for Goomble Gurt II.
 *
 * Special thanks to https://discordjs.guide/ for detailed function examples.
 */


// Globals - ROOT for callables/subfuncs path
global.ROOT = process.cwd();
global.ACCESS_ROLE = '1288766265506140222';


/** Library Dependencies
 *  discord.js - for interactions with Discord.com
 *  fs - for file parsing and writing.
 *  path - for joining directories
 */
const { Client, Collection, Events, GatewayIntentBits } = require('discord.js');
const PATH = require('node:path');
const FS = require('node:fs');


/** File Dependencies
 *  config.json - for token, guild and client identification
 */
const { token } = require(PATH.join(ROOT, 'src', 'config', 'config.json')); //token


/** Discord Client Objects
 *  intentArray - holds intents.
 *  client - constructed object including intents
 */
const client = new Client({ intents: [	GatewayIntentBits.Guilds ] });


// Run Program (Java-style, structured)
main();


/** @func main
 *  the primary function to run
 */
function main() {
	client.commands = new Collection();
	
	/* COMMAND LOADER */
	const cmdPath = PATH.join(ROOT, 'src', 'commands');
	const cmdDir = FS.readdirSync(cmdPath);
	for (const folder of cmdDir) {
		const uDir = PATH.join(cmdPath, folder);
		const cmdList = FS.readdirSync(uDir).filter((file) => file.endsWith('.js'));
		for (const file of cmdList) {
			const filePath = PATH.join(uDir, file);
			const cmd = require(filePath);
			if ('data' in cmd && 'execute' in cmd) {
				client.commands.set(cmd.data.name, cmd);
			} else {
				console.log(`${filePath} is missing a "data" or "execute" property.`);
			}
		}
	}

	/* AUTOFILL LOADER */
	const eventPath = PATH.join(ROOT, 'src', 'events');
	const eventList = FS.readdirSync(eventPath).filter((file) => file.endsWith('.js'));
	for (const file of eventList) {
		const filePath = PATH.join(eventPath, file);
		const event = require(filePath);
		if (event.once) {
			client.once(event.name, (...args) => event.execute(...args));
		} else {
			client.on(event.name, (...args) => event.execute(...args));
		}
	}

	client.login(token);
}