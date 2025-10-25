const { SlashCommandBuilder, AttachmentBuilder, ActionRowBuilder, ButtonBuilder, MediaGalleryBuilder, ContainerBuilder, MessageFlags } = require('discord.js');
const PATH = require('node:path');
const { getPassiveImagePath, getPassiveList, getPassiveLinkArray } = require(PATH.join(ROOT, 'src', 'modules', 'libParser.js'));
const passiveList = getPassiveList().sort();
const MFE = MessageFlags.Ephemeral;
const MSCV2 = MessageFlags.IsComponentsV2;
//Configurable
const AC_LIST_CAP = 10;
const DELIMITER = '★';


module.exports = {
	//Slash CMD
	data: new SlashCommandBuilder()
			.setName('passive').setDescription('Look up a Passive!')
			.addStringOption(option => option
					.setName('passive')
					.setDescription('What passive do you want to know more about?')
					.setAutocomplete(true)
					.setRequired(true)),


	//Execute CMD
	async execute(interaction) {
		const name = interaction.options.getString('passive').toLowerCase();
		if (!passiveList.includes(name)) {
			await interaction.reply({ content: `Passive not recognized!`, flags: MFE });
			return;
		}
		createResponse(name.toLowerCase(), interaction);
	},
	
	
	//Autofill
	async autofill(interaction) {
		const autoInput = interaction.options.getFocused().toLowerCase();
		const startIndex = passiveList.findIndex(item => item.startsWith(autoInput));
		const slice = startIndex >= 0 ? passiveList.slice(startIndex, startIndex + AC_LIST_CAP) : [];
		const filtered = slice.filter(item => item.startsWith(autoInput)).slice(0, AC_LIST_CAP);
		await interaction.respond(filtered.map(choice => ({ name: choice, value: choice })));
	},
	
	
	//Button Response
	async buttonResponse(name, interaction) {
		createResponse(name.toLowerCase(), interaction);
	},
};


function textFilter(input) {
	return input.replaceAll(":", "").replaceAll("?", "");
}


async function createResponse(name, interaction) {
	await interaction.deferReply();
	
	//Construct Objects
	const image = new AttachmentBuilder()
			.setFile(getPassiveImagePath(textFilter(name)))
			.setName('output.png');
	const imageContainer = new MediaGalleryBuilder().addItems(
		(mediaGalleryItem) =>
			mediaGalleryItem
				.setDescription(`The move entry for ${name}.`)
				.setURL('attachment://output.png'),
	);
	let passArr = getPassiveLinkArray(name);
	const replyBlock = new ContainerBuilder()
			.setAccentColor(0x4c4a44)
			.addMediaGalleryComponents(imageContainer);
	if (passArr[0]  !== '') {
		const sourceRow = new ActionRowBuilder();
		passArr.forEach(passiveGoomble => { sourceRow.addComponents(
			new ButtonBuilder().setCustomId(`goomble${DELIMITER}${passiveGoomble}`)
					.setStyle('Secondary')
					.setLabel(`${passiveGoomble}`));
		});
		replyBlock.addSeparatorComponents((separator) => separator)
			.addActionRowComponents(sourceRow);
	}

	//Update Deferred Reply
	await interaction.editReply({ components: [replyBlock], files: [image], flags: MSCV2 });
}
