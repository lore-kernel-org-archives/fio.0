Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:39939 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdLaNGo (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 31 Dec 2017 08:06:44 -0500
Received: by mail-vk0-f46.google.com with SMTP id w75so27059622vkd.7
        for <fio@vger.kernel.org>; Sun, 31 Dec 2017 05:06:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB14666D5091EECA44B869957E8F3D0@CY1PR0401MB1466.namprd04.prod.outlook.com>
References: <CY1PR0401MB14666D5091EECA44B869957E8F3D0@CY1PR0401MB1466.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 31 Dec 2017 13:06:13 +0000
Message-ID: <CALjAwxjnWvD3-54jTSLKnTQ_U15WrVF2FaOeDhg3CQUqRJnzBw@mail.gmail.com>
Subject: Re: fio lat reporting
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jeff,

On 5 December 2017 at 00:01, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> In commit "Add support for doing total latency percentiles" (b599759ba565e7f2f573af364e6da4fe6d556a90), the total latency percentiles option was added.  However, some workloads appear broken:
>
> # fio --name=test --ioengine=libaio --direct=1 --rw=randread --iodepth=1 --size=100% --bs=4k --filename=/dev/nvme0n1 --runtime=5s --write_lat_log=test --disable_lat=0 --disable_clat=1 --disable_slat=1 --lat_percentiles=1
> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
> fio-3.2-66-g67bfe
> Starting 1 process
> Jobs: 1 (f=1): [r(1)][100.0%][r=351MiB/s,w=0KiB/s][r=89.9k,w=0 IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=6879: Mon Dec  4 15:46:04 2017
>    read: IOPS=89.7k, BW=351MiB/s (368MB/s)(1753MiB/5001msec)
>      lat (usec): min=9, max=2259, avg=10.67, stdev= 7.66
>      lat percentiles (nsec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
>      | 30.00th=[    0], 40.00th=[    0], 50.00th=[    0], 60.00th=[    0],
>      | 70.00th=[    0], 80.00th=[    0], 90.00th=[    0], 95.00th=[    0],
>      | 99.00th=[    0], 99.50th=[    0], 99.90th=[    0], 99.95th=[    0],
>      | 99.99th=[    0]
>
> In the above, we try to enable only lat log, so disable clat and slat.  The summary output shows lat, but the values are zero.

I guess the code that collects those percentiles is always looking at
whether clat is enabled...

> # fio --name=test --ioengine=libaio --direct=1 --rw=randread --iodepth=1 --size=100% --bs=4k --filename=/dev/nvme0n1 --runtime=5s --write_lat_log=test --disable_lat=0 --disable_clat=0 --disable_slat=1 --lat_percentiles=1
> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
> fio-3.2-66-g67bfe
> Starting 1 process
> Jobs: 1 (f=1): [r(1)][100.0%][r=356MiB/s,w=0KiB/s][r=91.1k,w=0 IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=6956: Mon Dec  4 15:47:43 2017
>    read: IOPS=87.8k, BW=343MiB/s (360MB/s)(1715MiB/5001msec)
>     clat (nsec): min=561, max=2258.3k, avg=9941.30, stdev=6660.37
>      lat (usec): min=9, max=2259, avg=10.88, stdev= 7.52
>      lat percentiles (nsec):
>      |  1.00th=[10304],  5.00th=[10304], 10.00th=[10304], 20.00th=[10304],
>      | 30.00th=[10432], 40.00th=[10432], 50.00th=[10432], 60.00th=[10432],
>      | 70.00th=[10432], 80.00th=[10944], 90.00th=[11072], 95.00th=[14784],
>      | 99.00th=[15296], 99.50th=[15424], 99.90th=[16064], 99.95th=[17024],
>      | 99.99th=[24704]
>
> In the above, we force clat on, and now the lat values are non-zero in the summary output.
>
> In the commit for stat.c, I see:
>
>         if (ts->lat_percentiles)
>                 add_clat_percentile_sample(ts, nsec, ddir);
>
> Does that seem correct?

Yes it looks correct - it's just the function is a bit misnamed. fio
stores all its latency percentile information in the same place since
you can only have either completion percentiles or total percentiles
but not both at the same time.

After digging about for a while it looks like the problem stems from
the wrong sample count being used in stat.c:

 419 static void show_ddir_status(struct group_run_stats *rs, struct
thread_stat *ts,
 420                              int ddir, struct buf_output *out)
 421 {
[...]
 461
 462         if (ts->clat_percentiles || ts->lat_percentiles) {
 463                 show_clat_percentiles(ts->io_u_plat[ddir],
 464                                         ts->clat_stat[ddir].samples,
 465                                         ts->percentile_list,
 466                                         ts->percentile_precision,
 467                                         ts->clat_percentiles, out);

fio is always using the clat_stat samples count rather than choosing
the count based on the type of percentile being requested.
https://github.com/axboe/fio/pull/505 should hopefully address this
(and disables percentile gathering if that type of latency has been
disabled).

-- 
Sitsofe | http://sucs.org/~sits/
