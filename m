Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix Windows local time
References: <BN3PR0401MB145737D9588B5617B1017ED48F0A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <36f56abf-2f2c-bfeb-4de0-0b07a3a564ec@kernel.dk>
Date: Thu, 14 Dec 2017 09:10:25 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145737D9588B5617B1017ED48F0A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/13/2017 06:19 PM, Jeff Furlong wrote:
> The fio summary output shows when the job completed, but references system time on Windows.  On Linux, local time (such as with time zone specifics) is referenced.  This patch converts Windows system time to local time.
> 
> Before:
> fio-3.2-72-ge80d-dirty
> Starting 1 thread
> Jobs: 1 (f=0): [f(1)][100.0%][r=69.6MiB/s,w=0KiB/s][r=17.8k,w=0 IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=1360: Wed Dec 13 23:21:16 2017 <--System Time
> 
> After:
> fio-3.2-72-ge80d-dirty
> Starting 1 thread
> Jobs: 1 (f=0): [f(1)][100.0%][r=73.2MiB/s,w=0KiB/s][r=18.7k,w=0 IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=8088: Wed Dec 13 15:22:07 2017 <--Local Time

Applied, thanks Jeff.

-- 
Jens Axboe


