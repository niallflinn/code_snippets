# Run dcraw on multiple threads in a number of directories:
for i in $(seq 30 40); do dcraw -T -4 -v rocks_$i/images/RAW/*.NEF  & done


# Move all files in a sequence into a specified directory:
for i in $(seq 30 40); do mv rocks_$i/images/RAW/*.tiff  rocks_$i/images/TIFF & done 

# Run iconvert concurrently on all exr files in cwd:
for filename in *.exr; do   iconvert "$filename" "${filename%.exr}.rat" & done

# Run iconvert concurrently on all exr files in cwd, running in batches of size N:
N=37
(
for filename in *.exr; do
	((i=i%N)); ((i++==0)) && wait
	iconvert "$filename" "${filename%.exr}.rat"&
done
)

# ffmpeg high quality screen capture: 
ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :1+0,36 -f pulse -i default -ac 1 -acodec pcm_s16le -vcodec prores_ks -profile:v 1 -qscale:v 8 -vendor apl0 -pix_fmt yuv422p10le -s 1920x1080 -r 48 $filename

# ffmpeg convert frame sequence to mp4:
ffmpeg -framerate 24 -start_number 1001 -i 'rudy_splat.%04d.png' -vf format=yuv420p rudy_splat.mp4

# swap super and alt keys for mac-configured keyboard:
setxkbmap -option altwin:swap_alt_win

# rename a file sequence to a new version by string substitution
# in a multithreaded for loop:
old="v008"
new="v009"
for filename in *.jpg; do mv $filename  ${filename/$old/$new}& done

# convert a file sequence from one format to another in a 
# multithreaded for loop:
old='exr'
new='png'
for filename in *.exr; do convert $filename ${filename/$old/$new} & done 

# find out how many files each directory in the cwd contains and 
# list each with the dir name:
for dir in *; do echo  `ls $dir | wc -l` $dir ; done >> list.txt 

# make a thumbnail from the first exr of the sequence in a set of render directories:
for dir in *; do infile=$dir/*00001.exr; outfile=$dir/thumbnail.jpg; iconvert $infile $outfile; done

# compress all directories under cwd with zip:
for file in *; do zip -r $file.zip $file & done
# file files and list with absolute path:
find ~+ -name *grunge* 

# find files with a particular extension and supply absolute path to another program:
find ~+ -name *.exr -exec makerat {} \; 

# find number of files in cwd:
ls -1q log* | wc -l

# play all the exrs under the current directory in one mplay session:
find . -name *.exr | xargs mplay

# view the realtime output from a specified process ID:
tail /proc/{PID}/fd/1 -f

# script to read a list of unpadded frame numbers and move the corresponding 
# frames into a directory:
input="/mnt/wildshare01/IlluminariumWild/04_VFX/LOCATIONS2/Solio/houdini/hip/bad_frames.txt"
while IFS= read -r line
do 
    paddedframe=`printf "%05d\n" $line`
    glob="grassFullNoHoldout*.$paddedframe.exr"
    mv $glob bad_frames
done < "$input"


# for loop to print padded frames: 
for i in $(seq -f "%05g" 1 480 ); do echo grassWedges_v003.$i.ass  ; done


# copy every nth file to a subdirectory:
for i in `seq -f "%05g" 1 25 455`; do cp DSC_small.$i.png tmp; done


# play the contents of each listed dir in RV in parallel, at a low colour and spatial 
# resolution:
for dir in mantraBirdsB mantraBirdsC mantraBirdsD mantraBirdsE mantraBirdsF; do rv $dir/$dir.%05d.exr -s 0.1 -nofloat -maxbits 8 &  done


# renice and ionice a whole process tree:
parent_pid=88699
for pid in $(pstree -ap "$parent_pid" | grep -oP ',\K\d+'); do
 renice -n 19 -p $pid >/dev/null
 ionice -c 3 -p $pid
done


# read file paths from a text file and see if they exist:
while read -r line; do
	if test -f $line; then
		echo "$line exists" 
	else
	 	echo "$line does not exist" 
	fi
done < bad_textures.txt 


# run a conversion from .exr to .tx in parallel, on files which don’t have 
# an existing .tx version:
function max2 {
   while [ `jobs | wc -l` -ge 48 ]   # check number of running sub processes
   do
      sleep 5
   done
}
# loop over exr files and submit a conversion for any 
# that lack a corresponding .tx 
for filename in *.exr;
	do 
		if ! test -f ${filename/.exr/.tx};	# string substitution to get .tx filename
			then max2; maketx $filename &
   		fi;
   	done
wait

ls -hlrt


# print file sizes in bytes of all exrs in dir:
for file in *.exr; do stat --printf="%s" $file ; printf "\n";  done


# list all but the first file in the dir:
count=`ls -1 | wc -l`
ls -1 -r | head -n $((count-1))


# wait for a specified process to end before running a command:
while pgrep mplay-bin;  do sleep 1;  done; echo DONE

# ffmpeg high quality screen capture: 

ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :1+0,36 -f pulse -i default -ac 1 -acodec pcm_s16le -vcodec prores_ks -profile:v 1 -qscale:v 8 -vendor apl0 -pix_fmt yuv422p10le -s 1920x1080 -r 48 $filename

# ffmpeg convert frame sequence to mp4: 

ffmpeg -framerate 24 -start_number 1001 -i 'rudy_splat.%04d.png' -vf format=yuv420p rudy_splat.mp4

# swap super and alt keys for mac-configured keyboard:

setxkbmap -option altwin:swap_alt_win

# rename a file sequence to a new version by string substitution
# in a multithreaded for loop:

old=”v008”
new=”v009”
for filename in *.jpg; do mv $filename  ${filename/$old/$new}& done


# download all the files from a web page:
wget --recursive --no-parent http://example.com

