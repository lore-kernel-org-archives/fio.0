Return-Path: <axboe@kernel.dk>
Subject: Re: Feature Request, Job Info inserted into json output
References: <loom.20151209T170827-533@post.gmane.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5669B1A9.7000006@kernel.dk>
Date: Thu, 10 Dec 2015 10:08:57 -0700
MIME-Version: 1.0
In-Reply-To: <loom.20151209T170827-533@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Kurt Dorsey <Kurt_Dorsey@Dell.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/09/2015 09:10 AM, Kurt Dorsey wrote:
> Hi All,
>
> I have a feature request.   One of the things that is missing (in my
> opinion) from the json output is the actual fio job configuration.
>
> In the current state it outputs a json file with all the output from the
> jobs run.  One addition that would make it very helpful for parsing and
> comparing data (especially historical data  or data run by another
> engineer) is to have the actual job file as a key inside the json
> output.  This could be something as simple as just putting the parsed
> command line argument in
>
> fio --ioengine=libaio --buffered=0 --norandommap --log_avg_msec=10000 --
> direct=1 --ba=4k --ramp_time=0 --runtime=1800 --time_based --
> filename=/dev/sdg --name=8K_RR_QD1 --name=8K_RR_QD1 --bs=8k --
> rw=randread --iodepth=1 --write_iops_log=./8K_RR_qd1_
>
> Or even better would be a dictionary inside the json with every
> configuration parameter verbosely printed (like the below "jobinfo")
>
>
>
> {
>    "fio version" : "fio-2.1.10",
>    "jobs" : [
>      {
>        "jobname" : "8K_Random_Read",
>        "jobinfo" :{
>          "ioengine" : "libaio"
>          "buffered" : 0
>          "norandommap" : 1
>          "log_avg_msec" : 10000
>          "direct" : 1
>          "ba" : 4k
>          "ramp_time" : 0
>          "runtime" :1800
>          "time_based" : 1
>          "filename" : "/dev/sdc"
>          "name" : "8K_Random_Read"
>          "bs" : "8K"
>          "rw" : "randread"
>          "iodepth" : 1
>        }
>        "groupid" : 0,
>        "error" : 0,
>        "read" : {
>
>
> I understand it would add size to the output but I think it would really
> help.

That would be very useful, you're not the first to bring it up. I'll be 
happy to take patches to add this feature.

-- 
Jens Axboe


