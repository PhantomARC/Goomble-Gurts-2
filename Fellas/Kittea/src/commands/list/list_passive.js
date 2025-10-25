const { SlashCommandBuilder, AttachmentBuilder, ActionRowBuilder, ButtonBuilder, MediaGalleryBuilder, ContainerBuilder, StringSelectMenuBuilder, StringSelectMenuOptionBuilder, MessageFlags } = require('discord.js');
const PATH = require('node:path');
const { getPassiveList } = require(PATH.join(ROOT, 'src', 'modules', 'libParser.js'));
const passiveList = getPassiveList().sort();
const MFE = MessageFlags.Ephemeral;
const MSCV2 = MessageFlags.IsComponentsV2;
//Configurable
const LIST_ENTRY_CAP = 25; //entries per list page
const DELIMITER = '★';


module.exports = {
	//Slash CMD
	data: new SlashCommandBuilder()
			.setName('list_passives').setDescription('View the full list of passives!')
			.addStringOption(option => option
					.setName('page')
					.setDescription('~ Optional: Jump to a specific page ~')
					.setRequired(false)),


	//Execute CMD
	async execute(interaction) {
		await interaction.deferReply();
		const currPage = interaction.options.getString('page');
		createResponse(currPage, interaction, false);
	},
	
	//Execute CMD
	async buttonResponse(page, interaction) {
		createResponse(page, interaction, true);
	},
};


//clamping for page indexing
function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}


//Generate Response
async function createResponse(page, interaction, isButtonInteraction) {
	const pageCount = Math.ceil(passiveList.length / LIST_ENTRY_CAP);
	const pageNumber = (page) ? (clamp(parseInt(page), 1, pageCount) - 1) : 0;
	const pageArray = passiveList.slice(pageNumber * LIST_ENTRY_CAP, (pageNumber + 1) * LIST_ENTRY_CAP);
	
	const buttonRow = new ActionRowBuilder().addComponents(
		new ButtonBuilder().setCustomId(`list_passives${DELIMITER}1${DELIMITER}0`).setStyle('Primary').setEmoji('⏪').setDisabled(pageNumber == 0),
		new ButtonBuilder().setCustomId(`list_passives${DELIMITER}${pageNumber}${DELIMITER}2`).setStyle('Primary').setEmoji('⬅️').setDisabled(pageNumber == 0),
		new ButtonBuilder().setCustomId(`list_passives${DELIMITER}${pageNumber + 2}${DELIMITER}3`).setStyle('Primary').setEmoji('➡️').setDisabled(pageNumber == (pageCount - 1)),
		new ButtonBuilder().setCustomId(`list_passives${DELIMITER}${pageCount}${DELIMITER}4`).setStyle('Primary').setEmoji('⏩').setDisabled(pageNumber == (pageCount - 1))
	);
	
	const selectRow = new StringSelectMenuBuilder()
		.setCustomId('passive')
		.setPlaceholder('Optional: Select a Passive');
		
	pageArray.forEach(option => { selectRow.addOptions(
			new StringSelectMenuOptionBuilder()
					.setLabel(`${option}`)
					.setValue(`${option}`),);
		});
	
	const replyBlock = new ContainerBuilder()
			.setAccentColor(0x00ffff)
			.addTextDisplayComponents((textDisplay) =>
					textDisplay.setContent(
						`### List of Passives (${passiveList.length.toString()})\n\`\`\`ansi\n[1;36;1m${pageArray.join('\n')}\n\`\`\`\n-# Page ${(pageNumber + 1).toString()} of ${pageCount}`,
					),
				)
			.addSeparatorComponents((separator) => separator)
			.addActionRowComponents(buttonRow)
			.addSeparatorComponents((separator) => separator)
			.addActionRowComponents((actionRow) => actionRow.setComponents(selectRow));

	if (!isButtonInteraction) {
		//Update Deferred Reply
		await interaction.editReply({ components: [replyBlock], flags: MSCV2 });
	} else {
			//Update Message
			await interaction.update({ components: [replyBlock], flags: MSCV2 });
	}
}