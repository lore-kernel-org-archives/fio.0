Return-Path: <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
References: <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
 <BN3PR0401MB1457463C7131E975F7ED0812F7370@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1CkoXrkK2PowRkSyby6zbb+ngWFAD-AariWcp64FNTZNw@mail.gmail.com>
 <BN3PR0401MB145725E84C509D7F14BC2C2FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <BN3PR0401MB14573F44F190D9B11CCF836FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <805ada82-a3be-5b0f-226c-258d7e6f7711@kernel.dk>
 <CAJ9yE1CXNBvGFnJ1FNnodRKanXrqMgEfJsBrCz1dXBcNq4Qwxg@mail.gmail.com>
 <BN3PR0401MB1457787C3D5632BD79FFFC5BF7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1AYiuwX2tZbybqQw25YtGC8U40_JRz_iFQWypei_EVcMg@mail.gmail.com>
 <BN3PR0401MB1457883E34BC695500DEAF57F7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <20160722144702.GA7328@kernel.dk>
 <87c24164-a129-c6cd-b9bf-49ae52f7034f@kernel.dk>
 <39517e39-daeb-29ed-a4e3-8d5e759d9382@kernel.dk>
 <BN3PR0401MB14578638FC8BA420D42FACFCF70A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <587a3a61-3cfc-0e29-21bb-4a5f77a2c5ae@kernel.dk>
Date: Fri, 22 Jul 2016 12:55:05 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14578638FC8BA420D42FACFCF70A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Karl Cronburg <kcronbur@redhat.com>, Matthew Eaton <m.eaton82@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 07/22/2016 12:52 PM, Jeff Furlong wrote:
> Too late, I already put v2 patch through the process.  Some good, some bad.  The good is that no more dropped entries appear in the middle!  So for the iops and bw logs, I get results such as:
>
> 999, 293814, 0, 0
> 2000, 354857, 0, 0
> 3000, 383081, 0, 0
> ...
> 57000, 321946, 0, 0
> 58000, 321566, 0, 0
> 59000, 321596, 0, 0
>
> The first sample is slightly off, but well within a reasonable tolerance.  The last sample is always missing (runtime=60s).
>
> The bad is that the slat/clat/lat log is not doing averages any more, such as log_avg_msec=1000, but it's logging every value.
>
> # fio --name=test_job --ioengine=libaio --direct=1 --rw=randread --iodepth=256 --size=100% --numjobs=4 --bs=4k --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=60s --time_based --output=test_job

OK, I guess it's not perfect! I'll tackle that one.

-- 
Jens Axboe


