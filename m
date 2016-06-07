Return-Path: <axboe@kernel.dk>
Subject: Re: fio bw and iops logs broken
References: <BN3PR0401MB14570C741575E615FE199142F75C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57563A9F.8090906@kernel.dk>
Date: Mon, 6 Jun 2016 21:08:15 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14570C741575E615FE199142F75C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/06/2016 04:07 PM, Jeff Furlong wrote:
> Hi All,
> Somewhere between fio-2.11 and fio-2.11-14-gf031 the bw and iops logs no longer get written.
>
> # fio --name=test_job --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --numjobs=1 --bs=1m --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=10s --ramp_time=5s --output=test_job
>
> # ls -l
> -rw-r--r--  1 root root 1537 Jun  6 15:01 test_job
> -rw-r--r--  1 root root    0 Jun  6 15:01 test_job_bw.1.log
> -rw-r--r--  1 root root  199 Jun  6 15:01 test_job_clat.1.log
> -rw-r--r--  1 root root    0 Jun  6 15:01 test_job_iops.1.log
> -rw-r--r--  1 root root  200 Jun  6 15:01 test_job_lat.1.log
> -rw-r--r--  1 root root  254 Jun  6 15:01 test_job_slat.1.log
>
> See above file sizes of zero for the bw and iops logs.  However, lat/slat/clat are written.  Thoughts on which recent commit broke the functionality?  Thanks.

I'll take a look.

-- 
Jens Axboe


