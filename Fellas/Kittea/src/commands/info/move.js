const { SlashCommandBuilder, AttachmentBuilder, ActionRowBuilder, ButtonBuilder, 
		StringSelectMenuBuilder, StringSelectMenuOptionBuilder, MediaGalleryBuilder, 
		ContainerBuilder, EmbedBuilder, MessageFlags } = require('discord.js');
const PATH = require('node:path');
const { getMoveImagePath, getMoveList, getMoveLinkArray } = require(PATH.join(ROOT, 'src', 'modules', 'libParser.js'));
const moveList = getMoveList().sort();
const MFE = MessageFlags.Ephemeral;
const MSCV2 = MessageFlags.IsComponentsV2;
//Configurable
const AC_LIST_CAP = 10; //Discord Maximum is 25
const SELECTOR_CAP = 25; //Discord Maximum is 25
const DELIMITER = '★';


module.exports = {
	//Slash CMD
	data: new SlashCommandBuilder()
			.setName('move').setDescription('Look up a Move!')
			.addStringOption(option => option
					.setName('move')
					.setDescription('Which move are you looking for?')
					.setAutocomplete(true)
					.setRequired(true)),


	//Execute CMD
	async execute(interaction) {
		const name = interaction.options.getString('move').toLowerCase();
		if (!moveList.includes(name)) {
			await interaction.reply({ content: `Move not found!`, flags: MFE });
			return;
		}
		createResponse(name.toLowerCase(), interaction);
	},
	
	
	//Autofill
	async autofill(interaction) {
		const autoInput = interaction.options.getFocused().toLowerCase();
		const startIndex = moveList.findIndex(item => item.startsWith(autoInput));
		const slice = startIndex >= 0 ? moveList.slice(startIndex, startIndex + AC_LIST_CAP) : [];
		const filtered = slice.filter(item => item.startsWith(autoInput)).slice(0, AC_LIST_CAP);
		await interaction.respond(filtered.map(choice => ({ name: choice, value: choice })));
	},


	//Button Response
	async buttonResponse(name, interaction) {
		createResponse(name.toLowerCase(), interaction);
	},


	//Special Response - Generate Sources
	async genSources(name, interaction) {
		listSources(name.toLowerCase(), interaction);
	},
};


function textFilter(input) {
	return input.replaceAll(":", "").replaceAll("?", "");
}


async function createResponse(name, interaction) {
	await interaction.deferReply();
	
	//Construct Objects
	const image = new AttachmentBuilder()
			.setFile(getMoveImagePath(textFilter(name)))
			.setName('output.png');
	const imageContainer = new MediaGalleryBuilder().addItems(
		(mediaGalleryItem) =>
			mediaGalleryItem
				.setDescription(`The move entry for ${name}.`)
				.setURL('attachment://output.png'),
	);
	const replyBlock = new ContainerBuilder()
		.setAccentColor(0xfff4dd)
		.addMediaGalleryComponents(imageContainer);
	let moveArr = getMoveLinkArray(name);
	if (moveArr[0]  !== '') {
		if (moveArr.length > SELECTOR_CAP) {
			const sourceRow = new ActionRowBuilder().addComponents(
			new ButtonBuilder().setCustomId(`moveLink${DELIMITER}${name}`).setStyle('Primary').setLabel(`View All ${moveArr.length} Sources`),);
			replyBlock.addSeparatorComponents((separator) => separator)
				.addActionRowComponents(sourceRow);
		} else {
			const selectRow = new StringSelectMenuBuilder()
			.setCustomId('goomble')
			.setPlaceholder('Optional: Lookup a Source');
			
			moveArr.forEach(moveGoomble => { selectRow.addOptions(
				new StringSelectMenuOptionBuilder()
						.setLabel(`${moveGoomble}`)
						.setValue(`${moveGoomble}`),);
			});
			replyBlock.addSeparatorComponents((separator) => separator)
				.addActionRowComponents((actionRow) => actionRow.setComponents(selectRow));
		}
		
	}
	//Update Deferred Reply
	await interaction.editReply({ components: [replyBlock], files: [image], flags: MSCV2 });
}


async function listSources(name, interaction) {
	await interaction.deferReply();
	let moveArr = getMoveLinkArray(name);

	const embed = new EmbedBuilder()
			.setColor(0xb9b4a5)
			.setTitle(`Sources of ${name}:`);
	
	const bin1 = [];
	const bin2 = [];
	const bin3 = [];
	
	for (let i = 0; i < moveArr.length; i++) {
		const e = moveArr[i];
		switch (i % 3) {
			case 0:
				bin1.push(e);
				break;
			case 1:
				bin2.push(e);
				break;
			case 2:
				bin3.push(e);
				break;
		}
	}
	
	embed.addFields(
			{ name: '', value: bin1.join('\n'), inline: true },
			{ name: '', value: bin2.join('\n'), inline: true },
			{ name: '', value: bin3.join('\n'), inline: true },
	);

	await interaction.editReply({ embeds: [embed] });
}
