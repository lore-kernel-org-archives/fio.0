Return-Path: <axboe@kernel.dk>
Message-ID: <54288BA4.50906@kernel.dk>
Date: Sun, 28 Sep 2014 16:28:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Confirming test parameters
References: <68dcaec92df442db80f34a518dd05cc3@BLUPR02MB453.namprd02.prod.outlook.com>
In-Reply-To: <68dcaec92df442db80f34a518dd05cc3@BLUPR02MB453.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Hinson, Roger" <Roger_Hinson@intuit.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-09-28 15:45, Hinson, Roger wrote:
> 	Hey all,
>
> 	I'm setting up a test to simulate what we're actually seeing on one of our storage arrays.  Can you take a look and provide me some feedback?
>
> 	The array usage is for two workload types:
>
> 	Type 1:
> 	Random Read % - 45
> 	Random Write % - 55
> 	Sequential Read % - 1
> 	Sequential Write % - 3
> 	R/W Ratio - 45:55
> 	Random Block Size - 4K
> 	Sequential Block Size - 64K
>
> 	Type 2:
> 	Random Read % - 1
> 	Random Write % - 13
> 	Sequential Read % - 2
> 	Sequential Write % - 84
> 	R/W Ratio - 3:97
> 	Random Block Size - 4K
> 	Sequential Block Size - 32K	
>
> 	I came up with this:
>
> [global]
> group_reporting=1
> thread
> iodepth=8
> ioengine=libaio
> direct=1
> refill_buffers
> randrepeat=1
> randseed=100
> random_distribution=zipf:1.01
> runtime=1200
> time_based
> bs_is_seq_rand
>
> [45read55write_dm0_numjobs_2]
> write_bw_log=4555_dm0_2
> write_lat_log=4555_dm0_2
> write_iops_log=4555_dm0_2
> filename=/dev/mapper/mpathq
> rw=randrw
> rwmixread=45
> rwmixwrite=55
> percentage_random=96
> bs=64K,4K
> buffer_compress_percentage=50
> buffer_compress_chunk=512
> numjobs=2
>
> [3read97write_dm1_numjobs_2]
> write_bw_log=397_dm1_2
> write_lat_log=397_dm1_2
> write_iops_log=397_dm1_2
> filename=/dev/mapper/mpathr
> rw=randrw
> rwmixread=3
> rwmixwrite=97
> percentage_random=14
> bs=32K,4K
> buffer_compress_percentage=50
> buffer_compress_chunk=512
> numjobs=2

This looks like a pretty good approximation. Note that percentage_random 
can take all data directions into account. So if you have a workload 
that is:

read sequential: 57%
write sequential: 95%

you could do:

percentage_random=43,5

and have that just work.

-- 
Jens Axboe


