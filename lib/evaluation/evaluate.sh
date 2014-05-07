# Arguments:
# $1 - number of tests
# $2 - name of in/out files - that is, $2.in $2.out $2.ok
# NOTE: Format for evaluation is $2-$i.in and $2-$i.ok
# $3 - compiler to use (any installed; expecting compiler to accept -o)
# $4 - file to evaluate
# $5 - result verifier (must take 2 arguments - $1 = file1 $2 = file 2; can be custom; must return 1 if the two files are identical (or the first file is otherwise correct) or 0 if the two files are different)
# $6 - Memory limit (in kb)
# $7 - Time limit (in seconds)
# Example: ./evaluate.sh 2 problematest g++ task15142.cpp defaultdiff 1024 1000
$pointstotal = 0
$testsnotfailed = 0
$errorencountered = 0
for i in {1..$1}
do
	sed -i 's/$2.in/$2-$i.in/g' $4 # replace the file name with the current test file
	$returnvalue = $3 $4 -o $4.eval # compile
	if [ $returnvalue == 1 ] # we have an error
	then
		$error = $?
		echo "Error received:$error"
		$errorencountered = 1
	else # compilation successful
		$iserror = ./timeout -t $7 -m $6 ./$4.eval # execute the program
		if($iserror) {
			echo $iserror
		}
	fi
	sed -i 's/$2-$i.in/$2.in/g' $4 # reverse operation to above
	if [ $errorencountered == 1 ]
	then
		break
	fi
done
rm $4.eval # delete temporary files