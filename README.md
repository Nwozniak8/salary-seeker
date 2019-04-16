# salary-seeker

The jobs listed on seek.com.au usually hide the salary range. You can use salary range search filters, but this is tedious and still vague.

This tool modifies URL parameters and brute-forces the salary range of the job through a binary search algorithm.
```
bash-3.2# ./salary-seeker.sh
    | usage: ./salary-seeker.sh <job id>
    | job id can be found in the URL of the job, e.g. https://www.seek.com.au/job/38035537 <--- here
    | example: ./salary-seeker.sh 38035537
```
<p align="center">
<img src=https://github.com/b3n-j4m1n/salary-seeker/raw/master/demo.gif>
</p>

If you are anything like me, when on a serious job hunt I consider 50+ applications. I was running this script constantly and wanted to store the results somewhere. I was also running it locally on a Linux Subsystem on windows and got a bit sick of using nano to edit the script. 

This script is better optimised to be run multiple times, asking for an Job ID and then storing the results in a csv, including a link to the original job.
