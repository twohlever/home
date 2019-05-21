
# set clean command prompt
PS1="\n\t \$  "

## source things that don't belong in a github commit
source $HOME/.bashrc_secret

# Homebrew
export CPPFLAGS="-I/usr/local/opt/dyld-headers/include"


##### PATH ####

# Modify path so that /usr/local/bin is ahead of /usr/bin
path_tmp=`echo "$PATH" | /usr/bin/sed 's:/usr/local/bin\:::'`
PATH="$HOME/bin:$HOME/Dropbox/QIAGEN/bin:/usr/local/bin:$path_tmp"


# Add boost to PATH -- needed for tracy
export PATH="/usr/local/opt/icu4c/bin:/usr/local/opt/icu4c/sbin:$PATH"
export LDFLAGS="-L/usr/local/opt/icu4c/lib"
export CPPFLAGS="-I/usr/local/opt/icu4c/include"


# Add applications PATH
PATH="/usr/local/assembly-cell/current:/usr/local/clcservercmdline/current:/usr/local/sratoolkit/current:/Applications/CLCGenomicsServer/current:/usr/texbin:/Applications/GenomicsCloudEngine/current:$HOME/Library/Python/2.7/bin:$PATH"
export PATH




#### Environment Variables ####


# Genomics Cloud Engine (GCE)
export AWS_REGION="us-west-2"


# JAVA Tools
# PICARD="java -Xmx1024M -jar /Users/$USER/bin/picard/current/"
# export PICARD

export CLASSPATH=/usr/local/Cellar/varscan/2.3.7/share/java/VarScan.v2.3.7.jar:$CLASSPATH


# set aliases
source $HOME/.aliases


PERL_MB_OPT="--install_base \"/Users/$USER/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/$USER/perl5"; export PERL_MM_OPT;
