module.exports = { getMoveLinkArray, getPassiveLinkArray, getGoombleImagePath, getMoveImagePath, getPassiveImagePath, getMoveList, getPassiveList, getGoombleList, getGoombleData };


const FS = require('node:fs');
const PATH = require('node:path');
const LIBROOT = 'lib';
const TYPE = Object.freeze({
	//datalinks
	GOOMBLEDATA: {datatype : 'data', category : 'goomble', filetype : 'json'},
  MOVELINK: {datatype : 'data', category : 'move', filetype : 'txt'},
  PASSIVELINK: {datatype : 'data', category : 'passive', filetype : 'txt'},
	//images
	GOOMBLE: {datatype : 'img', category : 'goomble', filetype : 'png'},
	MOVE: {datatype : 'img', category : 'move', filetype : 'png'},
	PASSIVE: {datatype : 'img', category : 'passive', filetype : 'png'},
	//bins
	BINARY: {datatype : 'data', category : 'bin', filetype : 'txt'},
	MOVELIST: {datatype : 'data', category : 'bin', filetype : 'txt'},
	PASSIVELIST: {datatype : 'data', category : 'bin', filetype : 'txt'},
	GOOMBLELIST: {datatype : 'data', category : 'bin', filetype : 'txt'},
});


function getArray(filePath) {
	try {
		return FS.readFileSync(filePath, 'utf8').trim().split('\n');
	} catch (e) {
		console.error(`Couldn't find file at ${filePath}!`, e);
		return [];
	}
}


function getData(filePath) {
	try {
		return JSON.parse(FS.readFileSync(filePath, 'utf8'));
	} catch (e) {
		console.error(`Couldn't find file at ${filePath}!`, e);
		return {};
	}
}


function getPath(type, name) { 
	return PATH.join(ROOT, LIBROOT, type.datatype, type.category, `${name}.${type.filetype}`);
}


function getMoveLinkArray(name) {
	return getArray(getPath(TYPE.MOVELINK, name));
}


function getPassiveLinkArray(name) {
	return getArray(getPath(TYPE.PASSIVELINK, name));
}


function getGoombleImagePath(name) {
	return PATH.join(ROOT, LIBROOT, TYPE.GOOMBLE.datatype, TYPE.GOOMBLE.category, `${name}.${TYPE.GOOMBLE.filetype}`);
}


function getMoveImagePath(name) {
	return PATH.join(ROOT, LIBROOT, TYPE.MOVE.datatype, TYPE.MOVE.category, `${name}.${TYPE.MOVE.filetype}`);
}


function getPassiveImagePath(name) {
	return PATH.join(ROOT, LIBROOT, TYPE.PASSIVE.datatype, TYPE.PASSIVE.category, `${name}.${TYPE.PASSIVE.filetype}`);
}

function getMoveList() {
	return getArray(getPath(TYPE.MOVELIST, "moves"));
}

function getPassiveList() {
	return getArray(getPath(TYPE.PASSIVELIST, "passives"));
}

function getGoombleList() {
	return getArray(getPath(TYPE.GOOMBLELIST, "goombles"));
}

function getGoombleData(name) {
	return getData(PATH.join(ROOT, LIBROOT, TYPE.GOOMBLEDATA.datatype, TYPE.GOOMBLEDATA.category, `${name}.${TYPE.GOOMBLEDATA.filetype}`));
}