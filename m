Return-Path: <axboe@kernel.dk>
Subject: Re: write_iops_log doesn't show any iops
References: <npf960$31m$1@blaine.gmane.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ad10d39d-9ef7-8cec-fd90-552e8805ef45@kernel.dk>
Date: Mon, 22 Aug 2016 11:32:56 -0600
MIME-Version: 1.0
In-Reply-To: <npf960$31m$1@blaine.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Saeed <ionictea@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/22/2016 10:27 AM, Saeed wrote:
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
>
> Strange but my write_iops_log log file doesn't contain any IOP data.
> What column should the iops data be in and what could be the reason why
> I'm getting any iop stats?
>
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 1, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
> 2, 1, 1, 4096
>
> FIO 2.12 job:
> [global]
> ioengine=libaio
> direct=1
> filename=/dev/sdc
> group_reporting
> numjobs=1
> time_based=1
> per_job_logs=0
> write_bw_log=results
> write_iops_log=results
> write_lat_log=results
>
> [fill]
> rw=randwrite
> bs=8K
> runtime=120
> iodepth=1
> stonewall
>
> [read]
> rw=randread
> bs=8k
> iodepth=16
> runtime=480
> stonewall

Can you try the current -git version?

-- 
Jens Axboe

