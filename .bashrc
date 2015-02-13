
# set clean command prompt
PS1="\t \$  "

# PATH

# Modify path so that /usr/local/bin is ahead of /usr/bin
path_tmp=`echo "$PATH" | /usr/bin/sed 's:/usr/local/bin\:::'`
PATH="$HOME/bin:/usr/local/bin:$path_tmp"
PATH="/usr/local/assembly-cell/current:/usr/local/clcservercmdline/current:/usr/local/sratoolkit/current:/Applications/CLCGenomicsServer/current:/usr/texbin:$PATH"
export PATH


# JAVA Tools
PICARD="java -Xmx1024M -jar /Users/theresa/bin/picard/current/"
export PICARD

# set aliases
source $HOME/.aliases






