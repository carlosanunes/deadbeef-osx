#! /bin/bash

lib[0]='libzip'
lib[1]='libmad'
lib[2]='libsamplerate'
lib[3]='libcddb'
lib[4]='ogg'
lib[5]='libvorbis'

url[0]='http://www.nih.at/libzip/libzip-0.11.2.tar.gz'
url[1]='ftp://ftp.mars.org/pub/mpeg//libmad-0.15.1b.tar.gz'
url[2]='http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz'
url[3]='http://downloads.sourceforge.net/project/libcddb/libcddb/1.3.2/libcddb-1.3.2.tar.bz2'
url[4]='http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz'
url[5]='http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz'

# Fetch files
for u in "${url[@]}"
do

	echo "Fetching $u"
	curl -O -L $u
	echo

done

# Uncompress
for i in `seq 0 5`;
do
	mkdir ${lib[$i]}
	tar -xvf $(basename  ${url[$i]} ) -C ${lib[$i]} --strip-components=1

done