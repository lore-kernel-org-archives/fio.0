Return-Path: <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
References: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
 <20160707183605.GB8567@kernel.dk>
 <CAJ9yE1Ayvzkq5iNYCWEfhzunA7pLoJrS-YBb9TtBR3RM1xyWDg@mail.gmail.com>
 <BN3PR0401MB1457BF2D349098BBF7F579A2F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <577ECD29.2090204@kernel.dk>
Date: Thu, 7 Jul 2016 15:44:09 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457BF2D349098BBF7F579A2F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, Karl Cronburg <kcronbur@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/07/2016 03:04 PM, Jeff Furlong wrote:
> I am still seeing dropped entries on a slightly different case:
>
> # fio -version
> fio-2.12-5-g0b2e
>
> # fio --name=test_job --ioengine=libaio --direct=1 --rw=randread --iodepth=256 --size=100% --numjobs=2 --bs=4k --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=60s --time_based --output=test_job
>
> # cat test_job_iops.1.log
> 1000, 375601, 0, 0
> 3000, 243539, 0, 0
> 4000, 462076, 0, 0

That's very odd. Is it just the 2000 that's dropped, or are there more?

-- 
Jens Axboe


