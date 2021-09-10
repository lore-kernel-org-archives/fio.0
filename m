Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817F5C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Sep 2021 18:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A2F60F5D
	for <fio@archiver.kernel.org>; Fri, 10 Sep 2021 18:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhIJSj4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Sep 2021 14:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJSj4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Sep 2021 14:39:56 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E619EC061574
        for <fio@vger.kernel.org>; Fri, 10 Sep 2021 11:38:44 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id h20so2077080ilj.13
        for <fio@vger.kernel.org>; Fri, 10 Sep 2021 11:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=y90mzGgQTDYYABFGZGZKlaHJ8D1XL75xLd/G087QGuM=;
        b=2NqDa7wM8voKm2QfYyDOAnNJY7MDv1r8pQs2HISvglUfSmPdMIVV9VLKQuajH1wboJ
         SapGbO8F5kKwxmD7+aiBPFGToIQl7mwbS2BIekQILHKU7PIbl8BbjLS/kVPs0FY6LwDL
         H9J/G77k5vZxBvo6spSo/NczKiKXUKYzeCGLVUNGEqv7moHRe4ZCjSl4XHVlKE6hWi+/
         6UmEw/3G26lkANTn5DySYe/uhjJDqBGBmNZ100dvW/tWCHt2KUZB+bU6EcA3W5Cegjph
         MXXiYnOQN1KVN6Wu/xMWDqmeSP10e2zQB0n5GC7hDbtj9yjJ8TW1LKdY5mLoRsb3D/2y
         Pc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y90mzGgQTDYYABFGZGZKlaHJ8D1XL75xLd/G087QGuM=;
        b=wWV5mXOQ8OhzlnWOecO2KdRJ5mS/H+7sM+CMXuv0F9K19YBQHP8SE6+ES/X/OpeHKM
         LlwJIZ2REZVv6G+4N+1x5kz4vuHV00tzx6+P3WYjAbgYMX3xUxUNZHQuSqYLOc20BpPQ
         m5YFGNESmvIv7BQSIia5O5F7QnDRyieA92rONaoZf+e8rfx1EP4KU5znOjUDo2R4p0v+
         Wnp/VlrKIz8rJ7S4qHJMHAoYS0etxVKrzfMWTq4f07eAhX43bkY0/NWSxKXoE8Eg56My
         bzMW+2adcRsxo4K8xxibD2MHBuk2Wd1o/NomUMfj6pEbcV35KBa3IhONEMo9oWoiROnP
         9f0w==
X-Gm-Message-State: AOAM5315HCBVI/DD4Kr6Thdc8KJWrGd30j3gAEAoclpmc2IwoE31yh2S
        osGvaqRSd1RuupVwHNmAnD/11idIKYuRMqzyXtI=
X-Google-Smtp-Source: ABdhPJz8aTH7jVotyoBiqxEe6Fvri1tG3kLhiCP6UfzuLgjhErTqozuCOcG+4Isb1Z/GFOzUOIWVAw==
X-Received: by 2002:a92:b711:: with SMTP id k17mr7398514ili.247.1631299123996;
        Fri, 10 Sep 2021 11:38:43 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f3sm2719998ilu.85.2021.09.10.11.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 11:38:43 -0700 (PDT)
Subject: Re: Weird errors initializing I/O engines
To:     Dmitry Antipov <dantipov@cloudlinux.com>, fio@vger.kernel.org
References: <7c937a02-0349-7b17-2bcd-89cf32c0f371@cloudlinux.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <214f8c63-849a-a476-225f-531916239b92@kernel.dk>
Date:   Fri, 10 Sep 2021 12:38:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c937a02-0349-7b17-2bcd-89cf32c0f371@cloudlinux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/9/21 4:11 AM, Dmitry Antipov wrote:
> As of git head at 25425cb4a5531b1b3f26eba4e49866d944e0f1fb, I'm observing
> weird errors initializing all simple I/O engines except 'vsync'. Example:
> 
> $ ./fio --ioengine=sync --create_on_open=1 --time_based --runtime=10 --numjobs=1 --rw=read --bs=1k --size=1M --name=test-read-1k --filename=fio-1M
> test-read-1k: (g=0): rw=read, bs=(R) 1024B-1024B, (W) 1024B-1024B, (T) 1024B-1024B, ioengine=sync, iodepth=1
> fio-3.28-11-g2542-dirty
> Starting 1 process
> fio: pid=13034, err=5/file:backend.c:479, func=full resid, error=Input/output error
> 
> test-read-1k: (groupid=0, jobs=1): err= 5 (file:backend.c:479, func=full resid, error=Input/output error): pid=13034: Thu Sep  9 13:04:51 2021
>    cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=16
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued rwts: total=1,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
> 
> Disk stats (read/write):
>    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> 
> The same thing happens with 'psync', 'pvsync' and 'pvsync2', but 'vsync' seems to work:
> 
> $ ./fio --ioengine=vsync --create_on_open=1 --time_based --runtime=10 --numjobs=1 --rw=read --bs=1k --size=1M --name=test-read-1k --filename=fio-1M
> test-read-1k: (g=0): rw=read, bs=(R) 1024B-1024B, (W) 1024B-1024B, (T) 1024B-1024B, ioengine=vsync, iodepth=1
> fio-3.28-11-g2542-dirty
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=627MiB/s][r=642k IOPS][eta 00m:00s]
> test-read-1k: (groupid=0, jobs=1): err= 0: pid=13105: Thu Sep  9 13:06:54 2021
>    read: IOPS=627k, BW=612MiB/s (642MB/s)(6122MiB/10001msec)
>      clat (nsec): min=423, max=67325, avg=821.73, stdev=1436.87
>       lat (nsec): min=477, max=67448, avg=896.28, stdev=1492.29
>      clat percentiles (nsec):
>       |  1.00th=[  434],  5.00th=[  442], 10.00th=[  450], 20.00th=[  458],
>       | 30.00th=[  466], 40.00th=[  474], 50.00th=[  490], 60.00th=[  516],
>       | 70.00th=[  740], 80.00th=[ 1096], 90.00th=[ 1240], 95.00th=[ 1656],
>       | 99.00th=[ 3184], 99.50th=[13888], 99.90th=[21632], 99.95th=[23936],
>       | 99.99th=[29824]
>     bw (  KiB/s): min=408604, max=650082, per=99.91%, avg=626337.05, stdev=53380.19, samples=19
>     iops        : min=408604, max=650082, avg=626337.47, stdev=53380.34, samples=19
>    lat (nsec)   : 500=55.10%, 750=15.20%, 1000=5.43%
>    lat (usec)   : 2=21.09%, 4=2.40%, 10=0.24%, 20=0.39%, 50=0.14%
>    lat (usec)   : 100=0.01%
>    cpu          : usr=60.91%, sys=38.47%, ctx=43, majf=0, minf=13
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued rwts: total=6269388,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>     READ: bw=612MiB/s (642MB/s), 612MiB/s-612MiB/s (642MB/s-642MB/s), io=6122MiB (6420MB), run=10001-10001msec
> 
> Disk stats (read/write):
>    sda: ios=0/64, merge=0/29, ticks=0/149, in_queue=156, util=0.19%
> 
> BTW, should 'fio-1M' file be empty after running the workload?
> 
> I'm running Fedora 34, recently updated to kernel version 5.13.14, and
> seems has no issues with underlying filesystem where FIO is running.

Looks like an artifact of using create_on_open and depends on if the
engine uses lseek() to set the offset. I'll take a look in a bit,
for now I'd just recommend not using create_on_open.

-- 
Jens Axboe

