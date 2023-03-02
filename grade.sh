CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'

rm -rf student-submission
git clone -q $1 student-submission
if [[ ! -f student-submission/ListExamples.java ]]
then
    echo "ListExamples.java not found"
    grade=0 
    echo "Grade: $grade"
    exit 1
fi
cp TestListExamples.java student-submission
cd student-submission
javac ListExamples.java
if [[ $? != 0 ]]
then
    grade=0 
    echo "Grade: $grade"
    exit 1
else 
    javac -cp $CPATH TestListExamples.java
    java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > results.txt
    numTests=`grep -oE "Tests run: [0-9]+," results.txt | grep -oE "[0-9]+"`
    numFailures=`grep -oE "Failures: [0-9]+" results.txt | grep -oE "[0-9]+"`
    if [[ $numTests -eq 0 ]]
    then
        grade=0
    else
        let grade=($numTests-$numFailures)*100/$numTests
    fi

    if grep -qE "OK \([0-9]+ test[s]?\)" results.txt
    then
        grade=100
    fi
fi
cat results.txt
echo "GRADE: $grade"