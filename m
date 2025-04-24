Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D081A9B40
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 03:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464213; cv=none; b=a0LsmM05mRWOJvLkWSt5gZPYY1MD80CcvlS/aGtlhJA9kA7tO6jkyQ+Xm47RBVUeYnDefacYwkmZElk55qrq8kCh8f23z7XnZkDo3f1YDJEfkLdoaJqxd3epXP1BqZUmtBgbNQv/gKtIrostVSwabAyI1tzOiSUYLdLtWybcs7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464213; c=relaxed/simple;
	bh=dKD4J779ZSBodXxxO3NP+EnyxeuYyds0MYVHcChPvAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AM7Zkna89j3l816vEWMyMQLYvBERqKr9McqXx45trgKaHSDRKq33E41/Ov0ff8zdNuflOZno752Go11PPm8V15+Nk5UQlY3GssLvypEKY30YaKolcdEKrzd48If9fyeR4DpLZF/KQa5FAFXWbKCOrBqdIp7jzbM15LFNBq4Ahjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEqhPhxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEqhPhxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7FAC4CEE2;
	Thu, 24 Apr 2025 03:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745464212;
	bh=dKD4J779ZSBodXxxO3NP+EnyxeuYyds0MYVHcChPvAA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=hEqhPhxr5DhE/2rlojO1fEM3/iCRRaZQ+jyZMEXtJc6/iwvzLOq+5JFhkLxpXmlOX
	 d3/dT2R6wsog/HLUMeH1DT1hoIisw9SSFa7gRI+zls8Gx1nZZDnSfD9/ZW2ryiRuWt
	 RXEugnv9ScV20vCGQDihGlOWuHC2qk4RxPQTEdRyILmzLySYfbWTvzsGi33m2h2W4w
	 1br5MRUFlxmUTyZSr9nEkg1kAeaJMprVopXs85MrbytHRVWQplnJVB+37wck/5y/vU
	 CshTe3WDgiGb8h5WUy1E94i3ZfdHOFcimVn88HdjISLnml5oO8Q10fvUaYBTQWFv3e
	 PUCmdrraDLnKw==
Message-ID: <2a232db8-280a-4a76-aade-916499fd524d@kernel.org>
Date: Thu, 24 Apr 2025 12:10:10 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] active zones exceeded error with max_open_zones
To: Sean Anderson <seanga2@gmail.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/25 02:11, Sean Anderson wrote:
> Hi,
> 
> I'm getting an "active zones exceeded" error when running fio with
> --rw=randwrite mode:
> 
> # fio --bs=4k --rw=randwrite --norandommap --fsync=1 --number_ios=16384 --name=flushes --direct=1 --zonemode=zbd --max_open_zones=1978 --filename=/dev/my_zone_dev

--max_open_zones=1978 is an extremely large value that likely exceeds the drive
capabilities, which is what fio is telling you.
What are your drive maximum open and active zones limits ?

cat /sys/block/my_zone_dev/queue/max_open_zones
cat /sys/block/my_zone_dev/queue/max_active_zones

fio will use the min_not_zero of these 2 values as the maximum number of zones
that can be written simultaneously. Especially if your drive has an active zone
limit, you *cannot* write to more zones than that limit at the same time.
fio will default to max_open_zones=min_not_zero(drive max open, drive max
active) and for a random write workload, it will:
- pick zones randomly up to max_open_zones
- direct write IOs to a randomly chosen zone in the current set of open zones
and when an open zone becomes full, randomly pick another zone to replace it.

For your workload, if you want to measure the maximum "random" write performance
of your disk, simply do NOT specify --max_open_zones=. fio will pick the best
possible number for you.


> flushes: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
> fio-3.39
> Starting 1 process
> active zones exceeded error, dev my_zone_dev, sector 189520 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 0
> fio: io_u error on file /dev/my_zone_dev: Value too large for defined data type: write offset=97034240, buflen=4096
> /dev/my_zone_dev: Exceeded max_active_zones limit. Check conditions of zones out of I/O ranges.
> fio: pid=2549, err=75/file:io_u.c:1976, func=io_u error, error=Value too large for defined data type
> 
> flushes: (groupid=0, jobs=1): err=75 (file:io_u.c:1976, func=io_u error, error=Value too large for defined data type): pid=2549: Wed Apr 23 17:01:03 2025
>    write: IOPS=262, BW=1050KiB/s (1075kB/s)(9092KiB/8661msec); 0 zone resets
>      clat (usec): min=983, max=20564, avg=3645.67, stdev=4347.94
>       lat (usec): min=984, max=20564, avg=3645.75, stdev=4347.94
>      clat percentiles (usec):
>       |  1.00th=[  996],  5.00th=[ 1012], 10.00th=[ 1029], 20.00th=[ 1418],
>       | 30.00th=[ 1434], 40.00th=[ 1434], 50.00th=[ 1450], 60.00th=[ 1450],
>       | 70.00th=[ 1467], 80.00th=[ 5669], 90.00th=[12256], 95.00th=[12780],
>       | 99.00th=[15008], 99.50th=[15533], 99.90th=[16712], 99.95th=[17171],
>       | 99.99th=[20579]
>     bw (  KiB/s): min=  500, max= 1205, per=100.00%, avg=1052.88, stdev=195.04, samples=17
>     iops        : min=  125, max=  301, avg=262.88, stdev=48.79, samples=17
>    lat (usec)   : 1000=1.76%
>    lat (msec)   : 2=74.05%, 4=1.10%, 10=4.75%, 20=18.25%, 50=0.04%
>    fsync/fdatasync/sync_file_range:
>      sync (usec): min=50, max=11641, avg=160.03, stdev=798.31
>      sync percentiles (usec):
>       |  1.00th=[   53],  5.00th=[   57], 10.00th=[   66], 20.00th=[   73],
>       | 30.00th=[   81], 40.00th=[   82], 50.00th=[   83], 60.00th=[   84],
>       | 70.00th=[   85], 80.00th=[   87], 90.00th=[  178], 95.00th=[  208],
>       | 99.00th=[  603], 99.50th=[ 1549], 99.90th=[11600], 99.95th=[11600],
>       | 99.99th=[11600]
>    cpu          : usr=0.00%, sys=49.31%, ctx=2823, majf=0, minf=181
>    IO depths    : 1=200.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued rwts: total=0,2274,0,2273 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    WRITE: bw=1050KiB/s (1075kB/s), 1050KiB/s-1050KiB/s (1075kB/s-1075kB/s), io=9092KiB (9310kB), run=8661-8661msec
> 
> Disk stats (read/write):
>    my_zone_dev: ios=170/4498, sectors=1336/17992, merge=0/0, ticks=0/118, in_queue=230, util=47.80%
> 
> The issue seems to be that fio writes to a bunch of zones but never
> finishes them because they're not full yet:
> 
> # blkzone report -c 16 /dev/my_block_dev
>    start: 0x000000000, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000020, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000040, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000060, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000080, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x0000000a0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x0000000c0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x0000000e0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000100, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000120, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000140, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000160, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x000000180, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x0000001a0, len 0x000020, cap 0x00001f, wptr 0x000010 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x0000001c0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
>    start: 0x0000001e0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
> 
> This issue doesn't seem to occur with --rw=write because sequential
> writes fill up zones and they get finished automatically.
> 
> --Sean


-- 
Damien Le Moal
Western Digital Research
