#!/bin/bash

exit 0 # no need to keep re-mirroring old data

cd $(dirname $0)

CURLOPTS='-L -c /tmp/cookies -A eps/1.2'
curl $CURLOPTS -o mirror/page01.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature"
curl $CURLOPTS -o mirror/page02.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=15"
curl $CURLOPTS -o mirror/page03.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=30"
curl $CURLOPTS -o mirror/page04.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=45"
curl $CURLOPTS -o mirror/page05.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=60"
curl $CURLOPTS -o mirror/page06.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=75"
curl $CURLOPTS -o mirror/page07.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=90"
curl $CURLOPTS -o mirror/page08.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=105"
curl $CURLOPTS -o mirror/page09.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=120"
curl $CURLOPTS -o mirror/page10.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=135"
curl $CURLOPTS -o mirror/page11.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=150"
curl $CURLOPTS -o mirror/page12.html "https://www.assnat.cm/index.php/fr/deputes/7eme-legislature?start=165"

cd ~-
