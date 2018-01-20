#!/bin/bash		###	$ empd [options]	see: /home/$USER/bin/empd


 ###  E    M     P      D
 ###  Easy Music Player Daemon


# all input inside > ${IN} <<< export IN=$*
#export IN="$@";


#options------------------------------------------------------------------------------------------------------------

PLAYER="mplayer"
OPERANDS="-vo null"

if [ " " != "$(echo ${OPERANDS}|head -c 1)" ];
then
	OPERANDS=" ${OPERANDS}";
fi;
if [ " " != "$(echo ${OPERANDS}|tail -c 1)" ];
then
	OPERANDS="${OPERANDS} ";
fi;

#options------------------------------------------------------------------------------------------------------------

#Define---Start-----------------------------------------------------------------------------------------------------

export EXC_START="--start";	#execute start
export EXC_STOP="--stop";		#execute stop
export EXC_NEXT="--next";		#execute next
export EXC_PREV="--prev";		#execute previous
#export EXC_PAUZE="--pauze";	#execute pauze
#export EXC_UP="--forward";			#execute forward (+5%)
#export EXC_DOWN="--rewind";		#execute rewind (-5%)
export EXC_SET="--set"			#execute set track number
export OPT_CONT="--continue";				#option contunue
export OPT_REPEAT="--repeat";				#option repeat
export OPT_SHUFFLE="--shuffle";			#option shuffle
export OPT_DECENT_OUT="--decent-output";	#option decent output
export OPT_RESHUFFLE="--reshuffle";		#option reshuffle
export OPT_OPT="--options"					#option change options
export VAR_DIR="--dir";					#variable directory
export VAR_MUSIC_MAP="--music-map";		#variable music map name
export VAR_SCRIPT_MAP="--script-map";		#variable script map name
export VAR_ICON_MAP="--icon-map";			#variable icon map name
export VAR_MUSIC_DIR="--music-path";		#variable music directory
export VAR_SCRIPT_DIR="--script-path";		#variable script directory
export VAR_ICON_DIR="--icon-path";			#variable icon directory
export VAR_DEF_ICON="--default-icon-name";	#variable default icon
export VAR_DEF_ICON_DIR="--default-icon";	#variable default icon with path
export GET_NOTIFY="--notify"				#get notifications
export GET_VERBOSE="--verbosity";			#get verbosity
GET_INFO="--info";							#get info
GET_FULL="--all-info";						#get full info
GET_HELP="-h";								#get help
DMAKE="--dmake";							#debug make filelist
DVAR="--dvar";								#debug variable output
DTEST="--dtest";							#debug test code in development: see function "maketest"

#Define---End-------------------------------------------------------------------------------------------------------

#messagetext---Start------------------------------------------------------------------------------------------------

function messages {
EMPDid="EMPD";
nowplayingmsg="Now playing";
startmsg="started,   playback will begin soon.";
statusmsgtitle="${EMPD}";
statusmsg="XXX tracks were found"; # XXX will be track number
if [ "${IN}" != "${IN%${OPT_SHUFFLE}*}" ];
then
	statusmsg="${statusmsg}, will play in shuffle mode";
fi;
statusmsg="${statusmsg}: PLAYING";
errormsgtitle="${EMPDid} ran into a problem";
playlistdone="Playlist completed.";
repeatmsg="repeating everything";
reshufflemsg="reshuffle &";
}

messages;

#messagetext---End--------------------------------------------------------------------------------------------------

#-FUNCTIONS---START-------------------------------------------------------------------------------------------------

function dotest {
	find ${musicdir} -name '*.mp3' -o -name '*.wav' -o -name '*.flac' -o -name '*.mp4' -o -name '*.aac' > ${scriptdir}/filelist;
	if [ "${IN}" != "${IN%${OPT_SHUFFLE}*}" ];
	then sort -R ${scriptdir}/filelist -o ${scriptdir}/filelist; echo "random sort";
	else sort ${scriptdir}/filelist -o ${scriptdir}/filelist; echo "sort acsending";
	fi;
	export tracks=$(($(wc -l < ${scriptdir}/filelist)+-1));
	cat ${scriptdir}/filelist > ${scriptdir}/playlist;
	sed -i '1 i \hello' ${scriptdir}/filelist;

	echo "Playlist" > ${scriptdir}/playlist;
	for ((x=2;x<=tracks;x++));
		do
		f=$(sed -n "${x}{p;q;}" ${scriptdir}/playlist);
		if [ "${IN}" != "${IN%${OPT_DECENT_OUT}*}" ];
			then
			f=${f//120BPM/xxxBPM};
			f=${f//[_%][0123456789ABCDEF][0123456789ABCDEF]/""};
			f=${f//__/-};
			f=${f//--/-};
			f=${f//-/ - };
			f=${f//_/ };
			f=${f//  / };
			f=${f//  / };
			f=${f//  / };
			f=${f//.flac/};
			f=${f//.html/};
			f=${f//.[azertyuiopqsdfghjklmwxcvbn1234567890][azertyuiopqsdfghjklmwxcvbn1234567890][azertyuiopqsdfghjklmwxcvbn123456790]/};
			f=${f//[Ss]ubtitles/};
			f=${f//[Mm]onstercat/};
			f=${f//[Vv]ideo/};
			f=${f//[EL]P/};
			f=${f//[Ee]xclusive/};
			f=${f//[Cc][Dd]/};
			f=${f//[Rr]elease/};
			f=${f//[Ll]yrics/};
			f=${f//[Ll]yric/};
			f=${f//[Dd]ownload/};
			f=${f//[Oo]fficial/};
			f=${f//FREE/};
			f=${f//[Ff]ree/};
			f=${f//[Mm]usic/};
			f=${f//HQ/};
			#f=${f//./ };
			f=${f//xxxBPM/120bpm};
			f=$(LC_ALL=C sed -r 's/^[^[:alpha:]]+//' <<< "$f");
		fi
		f=${f//_/ };
		echo "$f" >> ${musicdir}/playlist;
		echo $f;
	done;
}

function optopt {
	echo "option update";
	if [ "" != "" ];
	then sed -i 's/1/2' ${scriptdir}/options;
	fi;
	if [ "" != "" ];
	then sed -i 's/1/2' ${scriptdir}/options;
	fi;
}

#FileSelect.sh
function makelist {
	echo make;

#	echo "0" > ${scriptdir}/filelist;
#	ls ${musicdir}/|sort -R >> ${scriptdir}/filelist;
#	export tracks=$(($(wc -l < ${scriptdir}/filelist)+-1));

	find ${musicdir} -name '*.mp3' -o -name '*.wav' -o -name '*.flac' -o -name '*.mp4' -o -name '*.aac' > ${scriptdir}/filelist;
	if [ "${IN}" != "${IN%${OPT_SHUFFLE}*}" ];
	then sort -R ${scriptdir}/filelist -o ${scriptdir}/filelist; echo "random sort";
	else sort ${scriptdir}/filelist -o ${scriptdir}/filelist; echo "sort acsending";
	fi;
	sed 's/.*\///' ${scriptdir}/filelist > ${musicdir}/playlist;
	export tracks=$(($(wc -l < ${scriptdir}/filelist)+-1));
	sed -i '1 i \0' ${scriptdir}/filelist;

	if [ "$tracks" < "2" ];
		then
		if [ "${IN}" != "${IN%${GET_NOTIFY}*}" ];
			then notify-send "${errormsgtitle}" "No files found in ${musicdir}, exiting";
		fi;
		echo "${errormsg}: No files found in ${muiscdir}, exiting"
		exit;
	fi;
	if [ "${IN}" != "${IN%${OPT_DECENT_OUT}*}" ]; then
	for ((x=1;x<=tracks;x++));
		do
		f=$(sed -n "${x}{p;q;}" ${musicdir}/playlist);
			f=${f//120BPM/xxxBPM};
			f=${f//[_%][0123456789ABCDEF][0123456789ABCDEF]/""};
			f=${f//__/-};
			f=${f//--/-};
			f=${f//-/ - };
			f=${f//_/ };
			f=${f//  / };
			f=${f//  / };
			f=${f//  / };
			f=${f//.flac/};
			f=${f//.html/};
			f=${f//.[azertyuiopqsdfghjklmwxcvbn1234567890][azertyuiopqsdfghjklmwxcvbn1234567890][azertyuiopqsdfghjklmwxcvbn123456790]/};
			f=${f//[Ss]ubtitles/};
			f=${f//[Mm]onstercat/};
			f=${f//[Vv]ideo/};
			f=${f//[EL]P/};
			f=${f//[Ee]xclusive/};
			f=${f//[Cc][Dd]/};
			f=${f//[Rr]elease/};
			f=${f//[Ll]yrics/};
			f=${f//[Ll]yric/};
			f=${f//[Dd]ownload/};
			f=${f//[Oo]fficial/};
			f=${f//FREE/};
			f=${f//[Ff]ree/};
			f=${f//[Mm]usic/};
			f=${f//HQ/};
			#f=${f//./ };
			f=${f//xxxBPM/120bpm};
			f=$(LC_ALL=C sed -r 's/^[^[:alpha:]]+//' <<< "$f");
			f=${f//_/ };
		sed -i "${x}s/.*/${f}/" ${musicdir}/playlist;
	done;
	fi;
	sed -i '1 i \Playlist' ${musicdir}/playlist;
}

#-FUNCTIONS---END---------------------------------------------------------------------------------------------------

#SetVars---Start----------------------------------------------------------------------------------------------------

function setvars {
echo "variables set";
export scriptdir="/home/${USER}/.EMPD";
export dir="/home/$USER/Music";
export musicdir="${dir}";
export icondir="${dir}/Icons";
export deficon="${scriptdir}/_.icon";

#bash ${scriptdir}/config;

if [ "${IN}" != "${IN%${VAR_DIR}*}" ];
then
	echo dir;
	dir="$(awk -v x="${VAR_DIR}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
	if [ "/" == "$(tail -c 1 ${dir})" ];
	then
		dir=${dir::-1};
	fi;
else
	dir="/home/$USER/Music";
fi;

if [ "${IN}" != "${IN%${VAR_MUSIC_DIR}*}" ];
then
	echo music-dir;
	musicdir="$(awk -v x="${VAR_MUSIC_DIR}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
elif [ "${IN}" != "${IN%${VAR_MUSIC_MAP}*}" ];
then
	echo music-map;
	musicdir="${dir}/$(awk -v x="${VAR_MUSIC_MAP}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
fi;
	
if [ "${IN}" != "${IN%${VAR_ICON_DIR}*}" ];
then
	echo icon-dir;
	icondir="$(awk -v x="${VAR_ICON_DIR}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
elif [ "${IN}" != "${IN%${VAR_ICON_MAP}*}" ];
then
	echo icon-map;
	icondir="${dir}/$(awk -v x="${VAR_ICON_MAP}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
fi;

if [ "/" == "$(echo ${musicdir}|tail -c 1)" ];
then
	musicdir=${musicdir::-1};
fi;

if [ "/" == "$(echo ${icondir}|tail -c 1)" ];
then
	icondir=${icondir::-1};
fi;

if [ "${IN}" != "${IN%${VAR_DEF_ICON_DIR}*}" ];
	then
	echo def-icon-dir;
	deficon="$(awk -v x="${VAR_DEF_ICON_DIR}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
elif [ "${IN}" != "${IN%${VAR_DEF_ICON}*}" ];
	then
	echo def-icon-name;
	deficon="${icondir}/$(awk -v x="${VAR_DEF_ICON}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
fi;

if [ "${IN}" != "${IN%${VAR_SCRIPT_DIR}*}" ];
then
	echo script-dir;
	scriptdir="$(awk -v x="${VAR_SCRIPT_DIR}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
elif [ "${IN}" != "${IN%${VAR_SCRIPT_MAP}*}" ];
then
	echo script-map;
	scriptdir="${dir}/$(awk -v x="${VAR_SCRIPT_MAP}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN})";
fi;

if [ "/" == "$(echo ${scriptdir}|tail -c 1)" ];
then
	scriptdir=${scriptdir::-1};
fi;
}

setvars;

#SetVars---End------------------------------------------------------------------------------------------------------

#HELP/MAN---START---------------------------------------------------------------------------------------------------

# see MAN and HELP in ${scriptdir}

if [ "${IN}" != "${IN%${GET_HELP}*}" ];
	then
	eval echo \""$(cat ${scriptdir}/HELP)"\";
	exit;
fi;
if [ "${IN}" != "${IN%${DVAR}*}" ];
	then
	echo $dir;
	echo music $musicdir;
	echo icons $icondir;
	echo def icon $deficon;
	echo scripts $scriptdir;
	echo "${PLAYER}${OPERANDS}test";
fi;
if [ "${IN}" != "${IN%${GET_INFO}*}" ];
	then
	eval echo \""$(cat ${scriptdir}/INFO)"\";
	exit;
elif [ "${IN}" != "${IN%${GET_FULL}*}" ];
	then
	eval echo \""$(cat ${scriptdir}/FULLINFO)"\";
	exit;
elif [ "${IN}" != "${IN%${OPT_OPT}*}" ];
	then
	optopt;
	exit;
elif [ "${IN}" != "${IN%${DMAKE}*}" ];
	then
	makelist;
	exit;
elif [ "${IN}" != "${IN%${DTEST}*}" ];
	then
	dotest;
	exit;
fi;

#HELP/MAN---END-----------------------------------------------------------------------------------------------------

#---
if [ "${IN}" != "${IN%${EXC_START}*}" ];
then
#---

#Start.sh---Start---------------------------------------------------------------------------------------------------

echo "check-start";
if (($(($(pgrep -f EMPD.sh|grep -v ^$$\$|wc -w))) != 1));
then
	echo "FALSE --start use"
	IN=${IN//${EXC_START}/${EXC_NEXT}}
else
	echo "TRUE --start use";
fi;

#Start.sh---End-----------------------------------------------------------------------------------------------------

#---
fi;
if [ "${IN}" != "${IN%${EXC_STOP}*}" ];
then
#---

#Stop.sh---Start------------------------------------------------------------------------------------------------------

echo stop;
pkill ${PLAYER};
kill -9 $(pgrep -f EMPD.sh | grep -v ^$$\$);
echo "Process killed";
exit;

#Stop.sh---End--------------------------------------------------------------------------------------------------------

#---
fi;
if [ "${IN}" != "${IN%${EXC_SET}*}" ];
then
#---

#Set.sh---Start------------------------------------------------------------------------------------------------------

x=$(awk -v x="${EXC_SET}" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${IN});
echo "set $x";
if [ $(head -c 1 <<< ${x}) == $(head -c 1 <<< ${x//[123456789]/}) ];
	then
	x=${x//_/ };
	x=$(cat ${musicdir}/playlist | grep -n "${x}" | sort -R | head -1 );
	x=$(($(sed -r 's/:.*//' <<< "${x}")+-1));
fi;
echo $x;
sed -i "1s/.*/$((x+-1))/" ${scriptdir}/filelist;
pkill -u ${USER} -n ${PLAYER};
exit;

#Set.sh---End--------------------------------------------------------------------------------------------------------

#---
fi;
if [ "${IN}" != "${IN%${EXC_NEXT}*}" ];
then
#---

#Next.sh---Start------------------------------------------------------------------------------------------------------

echo next;
pkill -u ${USER} -n ${PLAYER};
exit;

#Next.sh---End--------------------------------------------------------------------------------------------------------

#---
fi;
if [ "${IN}" != "${IN%${EXC_PREV}*}" ];
then
#---

#Prev.sh---Start------------------------------------------------------------------------------------------------------

echo previous;
sed -i "1s/.*/$(($(sed -n "1{p;q;}" < ${scriptdir}/filelist)+-2))/" ${scriptdir}/filelist;
pkill -u ${USER} -n ${PLAYER};
exit;

#Prev.sh---End--------------------------------------------------------------------------------------------------------

#---
fi;
if [ "${IN}" != "${IN%${EXC_START}*}" ];
then
#---

#RD.sh---Start------------------------------------------------------------------------------------------------------

echo start;
if [ "${IN}" != "${IN%${GET_NOTIFY}*}" ];
then
	echo "${EMPDis} ::: ${startmsg}";
	notify-send "${EMPDid}" "${startmsg}";
fi;
if [ "${IN}" == "${IN%${OPT_CONT}*}" ];
then
	makelist;
	if [ "${IN}" != "${IN%${GET_NOTIFY}*}" ];
	then
	echo "${statusmsgtitle} ::: ${statusmsg//XXX/${tracks}}";
	notify-send "${statusmsgtitle}" "${statusmsg//XXX/${tracks}}";
	fi;
fi;
for ((n=0;n<tracks;n++));
	do
	export n=$(($(head -n 1 ${scriptdir}/filelist)+2));
	sed -i "1s/.*/$((n+-1))/" ${scriptdir}/filelist;
	file=$(sed -n "${n}{p;q;}" < ${scriptdir}/filelist);
	filename=$(sed -n "${n}{p;q;}" < ${musicdir}/playlist);
	echo $filename;
	if [ "${IN}" != "${IN%${GET_NOTIFY}*}" ];
		then
		echo "${nowplayingmsg} ::: $((n+-1))  ···  ${filename}";
		notify-send -i ${deficon} "${nowplayingmsg}" "$((n+-1))  ···  ${filename}";
	fi;
	eval "$PLAYER$OPERANDS${file}";
done;
notify="${playlistdonemsg}"
if [ "${IN}" != "${IN%${OPT_REPEAT}*}" ];
	then
	echo "\"${OPT_REPEAT}\" > repeating playlist";
	if [ "${IN}" != "${IN%${OPT_RESHUFFLE}*}" ];
		then
		notify="${notify} ${reshufflemsg}";
		makelist;
	fi;
	notify="${notify} ${repeatmsg}";
	else
	echo "no \"${OPT_REPEAT}\" option found. Stopping.";
	if [ "${IN}" != "${IN%${GET_NOTIFY}*}" ];
		then
		notify-send "${EMPDid}" "${notify}";
	fi;
	exit;
fi;
if [ "${IN}" != "${IN%${GET_NOTIFY}*}" ];
	then
	notify-send "${EMPDid}" "${notify}";
fi;

#RD.sh---End---------------------------------------------------------------------------------------------------------

else
	echo "No \"--start\" option found. Not starting";
fi;
echo "No operations found, See \"${GET_HELP}\", \"${GET_INFO}\" or \"${GET_FULL}\"";
eval echo \""$(cat ${scriptdir}/HELP)"\";
echo "Exiting"
exit;


###END
