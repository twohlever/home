
# set clean command prompt
PS1="\t \$  "

# PATH

# Modify path so that /usr/local/bin is ahead of /usr/bin
path_tmp=`echo "$PATH" | /usr/bin/sed 's:/usr/local/bin\:::'`
PATH="$HOME/bin:/usr/local/bin:$path_tmp"
PATH="/usr/local/assembly-cell/current:/usr/local/clcservercmdline/current:/usr/local/sratoolkit/current:/Applications/CLCGenomicsServer/current:/usr/texbin:$PATH"

# Add python library to path
PATH="$HOME/Library/Python/2.7/bin:$PATH"
export PATH




# JAVA Tools
PICARD="java -Xmx1024M -jar /Users/theresa/bin/picard/current/"
export PICARD

export CLASSPATH=/usr/local/Cellar/varscan/2.3.7/share/java/VarScan.v2.3.7.jar:$CLASSPATH



# set aliases
source $HOME/.aliases







PERL_MB_OPT="--install_base \"/Users/theresawohlever/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/theresawohlever/perl5"; export PERL_MM_OPT;
