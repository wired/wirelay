#!/bin/bash
#
# FUNCTION: generate postfix string for use in kernel-dependent object path
# IN: Arg1: path to kernel source
#     Arg2: path to kernel objects outputs (as in make O=/.../objdir)
# OUT: KVSTR KVVER
BASE=$1
cd $BASE

log()
{
	echo -e $1;
}

generate_kdep_string()
{
	local ksrc="$1"
	local kobj="$2"

	# extract kernel versions from makefile in $ksrc
	local kversion=`grep -e '^VERSION' $ksrc/Makefile 2>/dev/null | awk '{print $3}'`
	local kpatchlevel=`grep -e '^PATCHLEVEL' $ksrc/Makefile 2>/dev/null | awk '{print $3}'`
	local ksublevel=`grep -e '^SUBLEVEL' $ksrc/Makefile 2>/dev/null | awk '{print $3}'`

	KVVER="${kversion}.${kpatchlevel}.${ksublevel}"

    #s016+s
    # retry extraction from makefile in $kobj
	if [[ "$kversion" != "2" || "$kpatchlevel" != "6" ]]; then
	    kversion=`grep -e '^VERSION' $kobj/Makefile 2>/dev/null | awk '{print $3}'`
	    kpatchlevel=`grep -e '^PATCHLEVEL' $kobj/Makefile 2>/dev/null | awk '{print $3}'`
	    ksublevel=`grep -e '^SUBLEVEL' $kobj/Makefile 2>/dev/null | awk '{print $3}'`

	    KVVER="${kversion}.${kpatchlevel}.${ksublevel}"
    fi
    #s016+e

	local regstr=""
	local memstr=""

	# on x86_64 kernels, register parameter and high memory is no longer supported and we do not
	# need it in the version string.
	if grep -e '^CONFIG_X86_64=y' $kobj/.config >/dev/null 2>&1; then
		KVSTR="x64"
	else
	# on x86 kernels, register parameter and high memory support are deciding factors
	# in the version string.

		# kernel 2.6.20 and later all use register parameter
		if [[ "$ksublevel" -ge "20" ]]; then
			regstr="REG"
		elif grep -e '^CONFIG_REGPARM=y' $kobj/.config >/dev/null 2>&1; then
			regstr="REG"
		else
			regstr=""
		fi

		if grep -e '^CONFIG_HIGHMEM4G=y' $kobj/.config >/dev/null 2>&1; then
			memstr="4G"
		elif grep -e '^CONFIG_HIGHMEM64G=y' $kobj/.config >/dev/null 2>&1; then
			memstr="64G"
		#s005, if high memory support is disabled, use 4G prebuilt objects
		elif grep -e '^CONFIG_NOHIGHMEM=y' $kobj/.config >/dev/null 2>&1; then
			memstr="4G"
		else
			log "generate_kdep_string: unknown highmem setting"
		fi

		KVSTR="${memstr}${regstr}"
	fi

	log "generate_kdep_string: KVSTR=$KVSTR"
	log "generate_kdep_string: KVVER=$KVVER"
	export KVSTR KVVER
}

select_kernel_best_match()
{
	local kver=`echo $KVVER | awk 'BEGIN{FS="."}{print $3}'`
	rm -f .kerns 
	# construct a list of kernel subversion
	#s001 for d in `find $BASE/src/kdep -type d -name '2.6.*' 2>/dev/null`; do
	for d in `find $BASE/kdep -type d -name '2.6.*' 2>/dev/null`; do
		echo `basename $d | awk 'BEGIN{FS="."}{print $3}'` >>.kerns 2>/dev/null
	done

	local largest=`sort -g .kerns | tail -n 1 2>/dev/null`
	local smallest=`sort -g .kerns | head -n 1 2>/dev/null`

	# find a best matching version to the running kernel
	if [ $kver -lt $smallest ]; then
		kver=$smallest
	elif [ $kver -gt $largest ]; then
		kver=$largest
	else 
		kver=$largest
		for k in `sort -g .kerns`; do
			if [ $kver -le $k ]; then
				kver=$k
				break
			fi
		done
	fi
	export KVVER="2.6.$kver"
}

# Select the most appropriate pre-built objects to use on target system
# and copy them into src directory to proceed to build ko.
select_module()
{
	kernelsrc=$1
	kernelobj=$2
	# retrieve KVSTR and KVVER
	generate_kdep_string $kernelsrc $kernelobj

	# copy prebuild files
	# s003, only copy if this directory exists
	if [ -e $BASE/prebuild/OBJ-$KVSTR ]; then
		\cp -rf $BASE/prebuild/OBJ-$KVSTR/* src/ >/dev/null 2>.err
        	if [[ "$?" != "0" ]]; then
                	dialog --backtitle "$BACKTITLE" --title \
			"ERROR: Failed to copy files" --textbox .err  20 $WIDTH
        	        clear
                	exit
	        fi									fi

	# if we do not have binary for this kernel, try the best match
	if [ ! -e $BASE/kdep/$KVVER ]; then
		# return best match kernel in KVVER
		select_kernel_best_match
	fi

	# copy kernel dependent prebuild files
	# s003, only copy if this directory exists
	if [ -e $BASE/kdep/$KVVER/OBJ-$KVSTR ]; then
		\cp -rf $BASE/kdep/$KVVER/OBJ-$KVSTR/* src/ >/dev/null 2>.err
        	if [[ "$?" != "0" ]]; then
                	dialog --backtitle "$BACKTITLE" --title \
			"ERROR: Failed to copy files" --textbox .err  20 $WIDTH
        	        clear
                	exit
	        fi
	fi
}

select_module $2 $3
