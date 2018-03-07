Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Reduce LOG_MSEC_SLACK
References: <BN3PR0401MB14570E710A7D5CC1E30FAE968FD90@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b9a9a66f-fce0-873c-e99f-2c81673ccf63@kernel.dk>
Date: Tue, 6 Mar 2018 17:45:57 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14570E710A7D5CC1E30FAE968FD90@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/6/18 4:16 PM, Jeff Furlong wrote:
> Hi All,
> Starting in fio 2.99, there is an odd problem when --ramp_time is used with --write_iops_log.  The reported IOPs for the first ~200s or so are artificially inflated by fio, always monotonically increasing until about 200s, then resets to normal.  With fio 2.99, disabling --ramp_time avoids the issue.  And, with fio 2.21, using --ramp_time and --write_iops_log does not create the problem.  Consider a job:
> 
> # fio --name=test --ioengine=libaio --direct=1 --rw=randread --iodepth=1 --size=100% --bs=4k --filename=/dev/nvme1n1 --runtime=300s --ramp_time=10s --write_iops_log=test --log_avg_msec=1000
> 
> See the attached plot for fio induced IOPs during the first ~200s.  Using a longer runtime makes identifying the issue easier if the DUT is consistently performing.
> 
> One simple method to resolve this inflation is by reducing the LOG_MSEC_SLACK from 10 milliseconds to 1 millisecond, given that we now operate some time structures to the nanosecond level (so 10ms of slack seems excessive).  Below I also fixup some data type issues to match existing types (avoids typecasts or potential compiler warnings):

Thanks, seems reasonable enough to reduce the slack, 10ms is a lot.

-- 
Jens Axboe


