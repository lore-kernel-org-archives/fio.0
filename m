Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DB733F9
	for <fio@vger.kernel.org>; Wed, 23 Apr 2025 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428281; cv=none; b=hY20QH1UeEb+Up8Owl317B3zRlVrpDjBOFQ0tAqUoCIRQyqIc7nihA85nJ93I/4ACREsNNgC6ZLC9nDP44OUicagypNjl2RXtCU6G5xZovge84PB58VTDGR1S3w5V9zhG5vUo5gtEYBiHKgThPS8puQuP7JU7DlZdinD2OQauIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428281; c=relaxed/simple;
	bh=f3dhT3rpgtB2mMpBqsF8ykTgEX7Z2YINt1UYTFnJlAs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=cpTOhagSGRCGd6U5eodErkfyfroLDGXggz45wHfmC+9Ts0wBpUFX6d778BDboC630txziDesZDPSjw0WeeO21muqkApKHU/p0KOJwPIIEhPwVWiTQdvRXBcjU5dn8HX7HfxnRY1Q2bWF/O5NahY8ye8v4NEmg4+bHd31Kawu3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbIKjvMK; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbIKjvMK"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c0b5065557so271185a.3
        for <fio@vger.kernel.org>; Wed, 23 Apr 2025 10:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745428279; x=1746033079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JS2msATwk++sO1JvsSxXYjgV55WCWtASi2M88V5b1N0=;
        b=UbIKjvMK0YOy8+QDZOYLb4AQkVBjNXSr0kR7QrmwdESmx7l6igcRMItUH9gpBkJphm
         oVH005F7k6++TV+NM0EwCDtt783W7yH09GOtrW8DnDweTfQgIn3M3ADB9IUEp5ZSr6TY
         UZqjQYxZdHVNf9tCMNBzeO0YDlCppj8hZVCIbQyNNiviDdUlr+ycTFyojmlqoNxFdOjB
         2vwWK1Egpi1FYUVNA0FInhbidqJnyn98ryUq6iMenLhyvPpNDBSGg9RlWbqxLiZR7/2+
         igmOO3OQxjISKCAt9YFyEy7nJKc7324vfjTtCe6rLDLm+aaea0xPrp2Sa6gKP2FtqDuj
         7sjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745428279; x=1746033079;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JS2msATwk++sO1JvsSxXYjgV55WCWtASi2M88V5b1N0=;
        b=NVgNhFYCzXBW/lG//5SVrqgTel2wMVvBHhiD+b7pJ2YJCDJsngiXoaY3vZAfVLFOa3
         ttIWCczDtYdcwkuXOAzlRvgtQyvkZBtnC5KJ1fV6Ko600v6B8BoB9AhGP07KfCwTEmfL
         OdZncrC8ZCA+BnUPFh5wINcE1zKYz8c9WsPazFHTbWpEVHMJqZe5fy6GIOMcuNZIxMjD
         /5fTjMY00oJqTQKA5ENxs3Pu9FSRmxMYq8CGRK5Rx7hZ0BKvc58+X+p2Cb3RknVG6yXc
         llub+6beyQGD8QR5wpCu0NwZNsFr1vVunYerW8zfCBLFHgr6IQzlgqj9SHCT0aqiPBFf
         BylA==
X-Forwarded-Encrypted: i=1; AJvYcCU5tsauoic/TkGWZYdcl83GP3uOF3In3XJ4DwevtC2rH7J/P4ahnG61gcQETAx8Gs6LJi4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm8gfJACCMtJLmwmLab/0OFsZnLP7MBgzmzD4vLBv1jCE6Xsg2
	w+p91oC/DGH0VUU421EYOFTeuZuNs4HqvLJj/p/14EdIIaDr3r05wNWclKkt
X-Gm-Gg: ASbGncsXckQA3wFC1EFqG4/y3+mHcAwX6OBZ5t4cw2SnSbkLnhHga1PEbrNM6uwJClW
	Ms2Bhg/Cd2MjcN7MjqD2pBmqLKdkDyXwjGxfOWe57dvpe7Rqp75AcRI/p/7JUxVGOfwrFHsFEhX
	ho+Ll5jAJEIxOinJVydrzEN3SDYuaFZvtA5U9XNkV4OcRyv3dLDNlRpnYFKX4CmTuKgci0sgWq5
	uXZEuRUmUZJoySxTCBR4xwUesfXoJwCoP5rRTlq3KPyUnmehCXfXGmhmwSql+Le49BukmE0S+r8
	PfeCrtzpE+otpk2Tb9xKA5tuo5czW9LUET/tKTZTq1+YE16T90AIgAARVhaC2GsIgbkCg1ilnnQ
	GBBXx91w41iCj5wnV
X-Google-Smtp-Source: AGHT+IFEUSmDQPC6qI1vxLnI4QsJCU8fe35zUN6vGHLWsO0eWauSSwiY1Wq0HvxUSeqsG4BcY3ijog==
X-Received: by 2002:a05:6214:234b:b0:6e4:501d:4129 with SMTP id 6a1803df08f44-6f4b4788e78mr21235696d6.11.1745428278719;
        Wed, 23 Apr 2025 10:11:18 -0700 (PDT)
Received: from [192.168.1.201] (pool-108-48-176-137.washdc.fios.verizon.net. [108.48.176.137])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4be9134e7sm266576d6.53.2025.04.23.10.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 10:11:18 -0700 (PDT)
Message-ID: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
Date: Wed, 23 Apr 2025 13:11:17 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
From: Sean Anderson <seanga2@gmail.com>
Subject: [BUG] active zones exceeded error with max_open_zones
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm getting an "active zones exceeded" error when running fio with
--rw=randwrite mode:

# fio --bs=4k --rw=randwrite --norandommap --fsync=1 --number_ios=16384 --name=flushes --direct=1 --zonemode=zbd --max_open_zones=1978 --filename=/dev/my_zone_dev
flushes: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
fio-3.39
Starting 1 process
active zones exceeded error, dev my_zone_dev, sector 189520 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 0
fio: io_u error on file /dev/my_zone_dev: Value too large for defined data type: write offset=97034240, buflen=4096
/dev/my_zone_dev: Exceeded max_active_zones limit. Check conditions of zones out of I/O ranges.
fio: pid=2549, err=75/file:io_u.c:1976, func=io_u error, error=Value too large for defined data type

flushes: (groupid=0, jobs=1): err=75 (file:io_u.c:1976, func=io_u error, error=Value too large for defined data type): pid=2549: Wed Apr 23 17:01:03 2025
   write: IOPS=262, BW=1050KiB/s (1075kB/s)(9092KiB/8661msec); 0 zone resets
     clat (usec): min=983, max=20564, avg=3645.67, stdev=4347.94
      lat (usec): min=984, max=20564, avg=3645.75, stdev=4347.94
     clat percentiles (usec):
      |  1.00th=[  996],  5.00th=[ 1012], 10.00th=[ 1029], 20.00th=[ 1418],
      | 30.00th=[ 1434], 40.00th=[ 1434], 50.00th=[ 1450], 60.00th=[ 1450],
      | 70.00th=[ 1467], 80.00th=[ 5669], 90.00th=[12256], 95.00th=[12780],
      | 99.00th=[15008], 99.50th=[15533], 99.90th=[16712], 99.95th=[17171],
      | 99.99th=[20579]
    bw (  KiB/s): min=  500, max= 1205, per=100.00%, avg=1052.88, stdev=195.04, samples=17
    iops        : min=  125, max=  301, avg=262.88, stdev=48.79, samples=17
   lat (usec)   : 1000=1.76%
   lat (msec)   : 2=74.05%, 4=1.10%, 10=4.75%, 20=18.25%, 50=0.04%
   fsync/fdatasync/sync_file_range:
     sync (usec): min=50, max=11641, avg=160.03, stdev=798.31
     sync percentiles (usec):
      |  1.00th=[   53],  5.00th=[   57], 10.00th=[   66], 20.00th=[   73],
      | 30.00th=[   81], 40.00th=[   82], 50.00th=[   83], 60.00th=[   84],
      | 70.00th=[   85], 80.00th=[   87], 90.00th=[  178], 95.00th=[  208],
      | 99.00th=[  603], 99.50th=[ 1549], 99.90th=[11600], 99.95th=[11600],
      | 99.99th=[11600]
   cpu          : usr=0.00%, sys=49.31%, ctx=2823, majf=0, minf=181
   IO depths    : 1=200.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=0,2274,0,2273 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=1050KiB/s (1075kB/s), 1050KiB/s-1050KiB/s (1075kB/s-1075kB/s), io=9092KiB (9310kB), run=8661-8661msec

Disk stats (read/write):
   my_zone_dev: ios=170/4498, sectors=1336/17992, merge=0/0, ticks=0/118, in_queue=230, util=47.80%

The issue seems to be that fio writes to a bunch of zones but never
finishes them because they're not full yet:

# blkzone report -c 16 /dev/my_block_dev
   start: 0x000000000, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000020, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000040, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000060, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000080, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x0000000a0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x0000000c0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x0000000e0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000100, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000120, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000140, len 0x000020, cap 0x00001f, wptr 0x000008 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000160, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x000000180, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x0000001a0, len 0x000020, cap 0x00001f, wptr 0x000010 reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x0000001c0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]
   start: 0x0000001e0, len 0x000020, cap 0x00001f, wptr 0x000000 reset:0 non-seq:0, zcond: 1(em) [type: 2(SEQ_WRITE_REQUIRED)]

This issue doesn't seem to occur with --rw=write because sequential
writes fill up zones and they get finished automatically.

--Sean
