Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix client/server "all clients" reporting
References: <BN3PR0401MB145797A13CE4C82EF8B131018F1E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <70fe820b-b0cb-4e10-e867-95ca6f4b1f58@kernel.dk>
Date: Fri, 5 Jan 2018 12:01:09 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145797A13CE4C82EF8B131018F1E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 1/3/18 4:20 PM, Jeff Furlong wrote:
> In commit e883cb3501de0f99297282c18842d50aaa7fa531, the default significant figures was added.  The default value was preserved for local jobs and when client/server was used if jobs=1, but not when client/server was used if jobs > 1.  This patch restores some reporting outputs ("all clients" output for IOPS and BW) when client/server is used if > 1 jobs, for example:
> 
> OLD:
> All clients: (groupid=0, jobs=2): err= 0: pid=0: Wed Jan  3 14:30:13 2018
>    read: IOPS=0, BW=0 (0)(0B/5001msec)                                               <--ZERO VALUES
>     slat (nsec): min=762, max=108579, avg=1058.97, stdev=221.30
>     clat (nsec): min=254, max=4544.2k, avg=11297.64, stdev=8284.14
>      lat (usec): min=9, max=4545, avg=12.41, stdev= 8.30
>    bw (  KiB/s): min=290192, max=347160, per=49.35%, avg=303613.33, stdev=11582.87, samples=18
>    iops        : min=72548, max=86790, avg=75903.33, stdev=2895.72, samples=18
> 
> NEW:
> All clients: (groupid=0, jobs=2): err= 0: pid=0: Wed Jan  3 15:08:33 2018
>    read: IOPS=147k, BW=575Mi (603M)(2876MiB/5001msec)	<--CORRECT VALUES
>     slat (nsec): min=841, max=61945, avg=1304.83, stdev=232.75
>     clat (nsec): min=544, max=4487.2k, avg=11736.68, stdev=9123.64
>      lat (usec): min=10, max=4489, avg=13.10, stdev= 9.13
>    bw (  KiB/s): min=260945, max=305976, per=49.99%, avg=294350.22, stdev=9192.53, samples=18
>    iops        : min=65236, max=76494, avg=73587.56, stdev=2298.13, samples=18

Applied, thanks Jeff.

-- 
Jens Axboe


