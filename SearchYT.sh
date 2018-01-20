#!/bin/bash
scriptdir="/home/$USER/.EMPD";
query=$@;
python ${scriptdir}/SearchYT.py --q "${query}" > ${scriptdir}/ytresults;
l=$(wc -l < ${scriptdir}/ytresults);
for ((x=1;x<l;x++));
do
	f=$(sed -n "${x}{p;q;}" ${scriptdir}/ytresults);
	id=$(awk -v x="--id" '{for (I=1;I<=NF;I++) if ($I == x) {print $(I+1)};}' <<< ${f});
	name=$(sed 's/.*--name //' <<< ${f});
	echo "$id | $name";
done;
exit;
