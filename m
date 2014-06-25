Return-Path: <axboe@kernel.dk>
Message-ID: <53AAE8DA.90002@kernel.dk>
Date: Wed, 25 Jun 2014 09:20:58 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Block size of zero in log files
References: <ab186420ecb140c887b85f36fcdde766@BLUPR02MB453.namprd02.prod.outlook.com>
In-Reply-To: <ab186420ecb140c887b85f36fcdde766@BLUPR02MB453.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Hinson, Roger" <Roger_Hinson@intuit.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-06-24 18:33, Hinson, Roger wrote:
>                  Hi,
>
>                  I'm new to using FIO.  I'm using FIO 2.1.10, although I had the same problem with FIO 2.1.7.  The log files are not listing the blocksize.  I looked around and can't find anything obvious that I'm doing wrong, although I see posts with it working for people.  Has anyone seen and solved this?
>
> Here is a snippet from my FIO config file.
>
> [global]
> thread
> group_reporting=1
> direct=1
> norandommap=0
> randrepeat=0
> refill_buffers
> buffer_compress_percentage=0
> ioengine=libaio
> #filename=/dev/dm-0:/dev/dm-1:/dev/dm-2:/dev/dm-3:/dev/dm-4:/dev/dm-5
>
> log_avg_msec=1000
>
> [128kB_SeqWr_dm0_1stPass]
> write_bw_log=128kB_SeqWr_dm0_1stPass
> write_lat_log=128kB_SeqWr_dm0_1stPass
> write_iops_log=128kB_SeqWr_dm0_1stPass
> filename=/dev/dm-0
> bs=128k
> rw=write
> numjobs=1
> iodepth=8
>
> [128kB_SeqWr_dm1_1stPass]
> write_bw_log=128kB_SeqWr_dm1_1stPass
> write_lat_log=128kB_SeqWr_dm1_1stPass
> write_iops_log=128kB_SeqWr_dm1_1stPass
> filename=/dev/dm-1
> bs=128k
> rw=write
> numjobs=1
> iodepth=8
>
> and a snippet of a log file
>
> tail -5 128kB_SeqWr_dm0_1stPass_bw.log
>
> 10767282, 171175, 1, 0
> 10768286, 167055, 1, 0
> 10769288, 172508, 1, 0
> 10770292, 170629, 1, 0
> 10770926, 174754, 1, 0

When you are looking over an averaged window (log_avg_msec), you no 
longer have a 1:1 between log entry and IO. So you lose the blocksize 
information.


-- 
Jens Axboe


