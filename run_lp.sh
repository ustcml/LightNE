#!/bin/bash
dim=128
network_name='train-test'
max_iter=50
gamma=0
ratio=1
rank=256
T=10
b=1
tratio=1
alg=binary
M=-1
out=false
gmf=false
usage()
{
  echo "Usage: run_lp [-T=window -b=negative -d=dim -M=cbn --rank=rank 
            --nname=network-name --out --gmf
		    --ratio=subspace-ratio --max-iter=max-iter 
			--gamma=gamma --train-ratio=tr --alg=algorithm] input"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n run_lp -o T:b:d:M: --long nname:,max-iter:,gamma:,ratio:,rank:,train-ratio:,alg:,out,gmf -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -T)       T="$2"           ; shift 2 ;;
    -b)       b="$2"           ; shift 2 ;;
    -d)       dim="$2"         ; shift 2 ;;
    -M)       M="$2"           ; shift 2 ;;
    --nname)  network_name="$2"; shift 2 ;;
	--max-iter) max_iter="$2"  ; shift 2 ;;
	--gamma)  gamma="$2"       ; shift 2 ;;
	--ratio)  ratio="$2"       ; shift 2 ;;
	--rank)   rank="$2"        ; shift 2 ;;
	--train-ratio) tratio="$2" ; shift 2 ;;
	--alg)    alg="$2"         ; shift 2 ;;
	--out)    out=true         ; shift 1 ;;
        --gmf)    gmf=true         ; shift 1 ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done
if [ $# -eq 0 ]; then
    usage
fi

echo "T            : $T"
echo "b            : $b "
echo "dim          : $dim"
echo "network-name : $network_name"
echo "max-iter     : $max_iter"
echo "gamma        : $gamma"
echo "ratio        : $ratio"
echo "rank         : $rank"
echo "train-ratio  : $tratio"
echo "algorithm    : $alg"
echo "gmf          : $gmf"
echo "output to file: $out"
echo "Parameters remaining are: $@"
input=$1
input_dir=$(dirname "${input}")

if [ "$out" = true  ]; then
output=$input_dir/lp_result_$alg.mat
echo "addpath(genpath('./AQ')); evaluate_lp('$input', 'output', '$output', 'nn', '$network_name', 'T', $T, 'b', $b, 'dim', $dim, 'ratio', $ratio, 'gamma', $gamma, 'max_iter', $max_iter, 'rank', $rank, 'train_ratio', $tratio, 'alg', '$alg', 'M', $M, 'g', $gmf); exit"
matlab -nodisplay -r "addpath(genpath('./AQ')); evaluate_lp('$input', 'output', '$output', 'nn', '$network_name', 'T', $T, 'b', $b, 'dim', $dim, 'ratio', $ratio, 'gamma', $gamma, 'max_iter', $max_iter, 'rank', $rank, 'train_ratio', $tratio, 'alg', '$alg', 'M', $M, 'g', $gmf); exit"
else
echo "addpath(genpath('./AQ')); evaluate_lp('$input', 'nn', '$network_name', 'T', $T, 'b', $b, 'dim', $dim, 'ratio', $ratio, 'gamma', $gamma, 'max_iter', $max_iter, 'rank', $rank, 'train_ratio', $tratio, 'alg', '$alg', 'M', $M, 'g', $gmf); exit"
matlab -nodisplay -r "addpath(genpath('./AQ')); evaluate_lp('$input', 'nn', '$network_name', 'T', $T, 'b', $b, 'dim', $dim, 'ratio', $ratio, 'gamma', $gamma, 'max_iter', $max_iter, 'rank', $rank, 'train_ratio', $tratio, 'alg', '$alg', 'M', $M, 'g', $gmf); exit"
fi


