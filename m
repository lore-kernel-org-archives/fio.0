Return-Path: <axboe@kernel.dk>
Message-ID: <53471606.3010505@kernel.dk>
Date: Thu, 10 Apr 2014 16:07:02 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: No IOPS reported when "REPLAY_NO_STALL" is not set
References: <CAEyTGCeu0P3uG1X3ObBfDF7pUrwa2hqbvvLyws2W4DSNH+UeuQ@mail.gmail.com>
In-Reply-To: <CAEyTGCeu0P3uG1X3ObBfDF7pUrwa2hqbvvLyws2W4DSNH+UeuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/10/2014 12:25 PM, Lakshmi wrote:
> Hi Jens,
>
>   I am seeing a strange problem. I have a 47KB Blkparsed binary file
> and I tried replaying it with and without the "replay_no_stall"
> option.
>
> With the "replay_no_stall" option, I am seeing some IOPS
> happening.Please see below.
> WITH "REPLAY_NO_STALL=1"
> =====================================================
> job9: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.1.7
> Starting 1 process
> Jobs: 1 (f=2): [M] [-.-% done] [1064KB/72KB/0KB /s] [266/18/0 iops]
> [eta 00m:00s]
> job9: (groupid=0, jobs=1): err= 0: pid=34226: Thu Apr 10 12:00:54 2014
>    read : io=3792.0KB, bw=1126.3KB/s, iops=281, runt=  3367msec
>      clat (usec): min=88, max=8536, avg=3546.19, stdev=1469.46
>       lat (usec): min=88, max=8536, avg=3546.35, stdev=1469.47
> =====================================================
> However, when I don't set the "REPLAY_NO_STALL" option, I see 0
> IOPS.Please see below
> job9: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio-2.1.7
> Starting 1 process
>
> job9: (groupid=0, jobs=1): err= 0: pid=33979: Thu Apr 10 10:39:42 2014
>    read : io=3792.0KB, bw=2004B/s, iops=0, runt=1937594msec
>      clat (usec): min=87, max=14320, avg=4763.37, stdev=2001.45
>       lat (usec): min=87, max=14320, avg=4763.52, stdev=2001.50
> ===========================================================
>
> My starting time in the blkparsed binary file is 26.040173218 seconds
> and last time is 26.150699031.
>
> Attached is the binary file I am using to replay.
>
> I understand replay_no_stall option doesnt respect the timestamps, but
> without this option the job should be executing with the delays, and
> not sure why no OPS are reported.
>
> Any idea what is causing this strange behavior?Please help.

It reports no IOPS, because it's slow enough to not register any. The 
first trace in the file is at timestamp 0.00 relative, and the last one 
is at 31110.250640101. Check for yourself with:

cat file_54657438_1000lines.bin | blkparse - | less

-- 
Jens Axboe


