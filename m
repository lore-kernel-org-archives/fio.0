Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] fio: fix interaction between offset/size limited
 threads and "max_open_zones"
References: <20200402192102.GA4335@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2637979d-4a04-552d-8dc1-b5d493d5ed4b@kernel.dk>
Date: Thu, 2 Apr 2020 13:34:11 -0600
MIME-Version: 1.0
In-Reply-To: <20200402192102.GA4335@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/2/20 1:21 PM, Alexey Dobriyan wrote:
> If thread bumps into "max_open_zones" limit, it tries to close/reopen some
> other zone before issuing IO. This scan is done over full list of block device's
> opened zones. It means that a zone which doesn't belong to thread's working
> area can be altered or IO can be retargeted at such zone.
> 
> If IO is retargeted then it will be dropped by "is_valid_offset()" check.
> 
> What happens with null block device testing is that one thread monopolises
> IO and others threads do basically nothing.
> 
> This config will reliably succeed now:
> 
> 	[global]
> 	zonemode=zbd
> 	zonesize=1M
> 	rw=randwrite
> 		...
> 	thread
> 	numjobs=2
> 	offset_increment=128M
> 
> 	[j]
> 	max_open_zones=2
> 	size=2M
> 
> Starting 2 threads
> zbd      7991  /dev/nullb0: zbd model string: host-managed
> zbd      7991  Device /dev/nullb0 has 1024 zones of size 1024 KB
> zbd      8009  /dev/nullb0: examining zones 0 .. 2
> zbd      8010  /dev/nullb0: examining zones 128 .. 130
> zbd      8009  /dev/nullb0: opening zone 0
> zbd      8010  /dev/nullb0: opening zone 128
> zbd      8009  /dev/nullb0: queued I/O (0, 4096) for zone 0
> zbd      8009  zbd_convert_to_open_zone(/dev/nullb0): starting from zone 128 (offset 1552384, buflen 4096)
> 
> 	retargeted for other thread's zone	(zone 0 => zone 128)
> 
> zbd      8010  /dev/nullb0: queued I/O (134217728, 4096) for zone 128
> zbd      8009  zbd_convert_to_open_zone(/dev/nullb0): returning zone 128
> zbd      8009  Dropped request with offset 134221824
> 
> 	and dropped
> 
> Note: quasi-randomness is kind of necessary to spread I/O. Imagine index 0
> is picked all the time, zone living there will be reopened constantly and
> get relatively little I/O.

Applied, thanks.

-- 
Jens Axboe


