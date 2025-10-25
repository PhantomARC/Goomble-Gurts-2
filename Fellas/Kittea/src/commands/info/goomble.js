const { SlashCommandBuilder, AttachmentBuilder, ActionRowBuilder, ButtonBuilder, MediaGalleryBuilder, ContainerBuilder, MessageFlags, TextDisplayBuilder } = require('discord.js');
const PATH = require('node:path');
const { getGoombleImagePath, getGoombleList, getGoombleData } = require(PATH.join(ROOT, 'src', 'modules', 'libParser.js'));
const goombleList = getGoombleList().sort();
const MFE = MessageFlags.Ephemeral;
const MSCV2 = MessageFlags.IsComponentsV2;
//Configurable
const AC_LIST_CAP = 10;
const MAX_TEXT_LEN = 40;
const DELIMITER = '★';


module.exports = {
	//Slash CMD
	data: new SlashCommandBuilder()
			.setName('goomble').setDescription('Look up a Goomble!')
			.addStringOption(option => option
					.setName('goomble')
					.setDescription('Which goomble are you looking for?')
					.setAutocomplete(true)
					.setRequired(true)),


	//Execute CMD
	async execute(interaction) {
		const name = interaction.options.getString('goomble').toLowerCase();
		if (!goombleList.includes(name)) {
			await interaction.reply({ content: `Couldn't find that goomble!`, flags: MFE });
			return;
		}
		createResponse(name.toLowerCase(), interaction);
	},


	//Autofill
	async autofill(interaction) {
		const autoInput = interaction.options.getFocused().toLowerCase();
		const startIndex = goombleList.findIndex(item => item.startsWith(autoInput));
		const slice = startIndex >= 0 ? goombleList.slice(startIndex, startIndex + AC_LIST_CAP) : [];
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


function textWrap(text, maxLength) {
  const words = text.split(' ');
  const lines = [];
  let currL = '';
  for (let word of words) {
		const spacer = currL ? ' ' : '';
    if ((currL + spacer + word).length <= maxLength) {
      currL += spacer + word;
    } else {
      lines.push(currL);
      currL = word;
    }
  }
  if (currL) lines.push(currL);
  return lines.join('\n');
}

async function createResponse(name, interaction) {
		await interaction.deferReply();
		const goombleData = getGoombleData(name);
		
		//Construct Objects
		const image = new AttachmentBuilder()
			.setFile(getGoombleImagePath(textFilter(name)))
			.setName('output.png');
		const imageContainer = new MediaGalleryBuilder().addItems(
			(mediaGalleryItem) =>
				mediaGalleryItem
					.setDescription(`The dex entry for ${name}.`)
					.setURL('attachment://output.png'),
		);
		const passiveRow = new ActionRowBuilder().addComponents(
			new ButtonBuilder().setCustomId(`passive${DELIMITER}${goombleData.passive}`).setStyle('Danger').setLabel(`${goombleData.passive}`),
		);
		const buttonRow1 = new ActionRowBuilder().addComponents(
			new ButtonBuilder().setCustomId(`move${DELIMITER}${goombleData.move_1}${DELIMITER}1`).setStyle('Secondary').setLabel(`${goombleData.move_1}`),
			new ButtonBuilder().setCustomId(`move${DELIMITER}${goombleData.move_2}${DELIMITER}2`).setStyle('Secondary').setLabel(`${goombleData.move_2}`),
		);
		const buttonRow2 = new ActionRowBuilder().addComponents(
			new ButtonBuilder().setCustomId(`move${DELIMITER}${goombleData.move_3}${DELIMITER}3`).setStyle('Secondary').setLabel(`${goombleData.move_3}`),
			new ButtonBuilder().setCustomId(`move${DELIMITER}${goombleData.move_4}${DELIMITER}4`).setStyle('Secondary').setLabel(`${goombleData.move_4}`),
		);
		const entryBlock = new TextDisplayBuilder().setContent(
			`\`\`\`ansi\n[1;31;1m${textWrap(goombleData.entry,MAX_TEXT_LEN)}\n\`\`\``,
		);
		const replyBlock = new ContainerBuilder()
			.setAccentColor(0xb40003)
			.addMediaGalleryComponents(imageContainer)
			.addSeparatorComponents((separator) => separator)
			.addTextDisplayComponents(entryBlock)
			.addSeparatorComponents((separator) => separator)
			.addActionRowComponents(passiveRow)
			.addActionRowComponents(buttonRow1)
			.addActionRowComponents(buttonRow2)
			;

		//Update Deferred Reply
		await interaction.editReply({ components: [replyBlock], files: [image], flags: MSCV2 });
}