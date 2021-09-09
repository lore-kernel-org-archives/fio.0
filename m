Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CAEC433F5
	for <fio@archiver.kernel.org>; Thu,  9 Sep 2021 10:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF989611B0
	for <fio@archiver.kernel.org>; Thu,  9 Sep 2021 10:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhIIKNB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Sep 2021 06:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhIIKNB (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Sep 2021 06:13:01 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D50C061575
        for <fio@vger.kernel.org>; Thu,  9 Sep 2021 03:11:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x27so2658887lfu.5
        for <fio@vger.kernel.org>; Thu, 09 Sep 2021 03:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AymCzF26eQhLQ+yCN/zd+8d5+ChapDi2KuyydUAed/E=;
        b=SwXxM0caVDeQKY+bcS3xRY0BYyiA2vUDEYAQUslA/gAGTfnm23Yov8bxzAiwScuKx0
         egjmJrZI/YlE3ik7A0q80OL3xcdlGQJSZy74WouKKfNvbn7tYUexAdT1vBgmZQe3szYL
         4HDBba64iHIA6TCiF+2dYYGVBg5LffwxacWuYY9lOtkBai/DpKmYG1wYKj+cq5toWKYg
         71DFHcG9SEvqqq3SyjEGXLK00rAwVvKtK318etTjI3pMAQ2dgsN4EbIx8xUFuKoM1gsI
         TQxECemq/kEOEV0x8jpSiUuvg7IuD4hCF5cAYVFX6hAqrN6hvdi0dg4mEZm6F7GRmQNV
         mSNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AymCzF26eQhLQ+yCN/zd+8d5+ChapDi2KuyydUAed/E=;
        b=rJ/hKozRTrAtjmq95/WsVTE2DC9ms9mcx0MmAs2hejjvz4Oqq2XCasPJ8QEcXqT9uy
         gSBnakEt4ugBn5PqdsrV0Qqr+PmwkynR+jrEl09XRF0ksfeR60EciO0s+f6HvTnL2Jk9
         nc9PSrBVhelfLJGwLFEdOkcbXeK3TtmynxTGlhBWdB3o3pifBeF3KJJ7tFcoK2HEpt3h
         QwnXubynq3WZmB4savd0IKOKg6+74XPaOo0tXBwFoza8vLilkooK6SIjZGRvBpdpUg4J
         dUGQmujxDM26z/o9L28UFc6sYMbELGwybttu9OJ55kaSVFS6+yCHNmgYyFaVuab8iWsX
         ZHaA==
X-Gm-Message-State: AOAM530krutNF1ss5JdMtHQD/3YpxEXcikP7hldX3u1f5IZXdKSpfM1m
        504H0b6uGm38LI13yuepElL7N+61+QWTpQ==
X-Google-Smtp-Source: ABdhPJxqvBmgJwPwUKeWo4JAWWpElLkppuBYKmYSWwq0c/oM1JdH+Y2h4rCtNM/OjAYA240kyNfGuw==
X-Received: by 2002:ac2:495e:: with SMTP id o30mr1751670lfi.674.1631182309806;
        Thu, 09 Sep 2021 03:11:49 -0700 (PDT)
Received: from localhost.localdomain ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id a17sm150457lfb.91.2021.09.09.03.11.48
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 03:11:49 -0700 (PDT)
To:     fio@vger.kernel.org
From:   Dmitry Antipov <dantipov@cloudlinux.com>
Subject: Weird errors initializing I/O engines
Message-ID: <7c937a02-0349-7b17-2bcd-89cf32c0f371@cloudlinux.com>
Date:   Thu, 9 Sep 2021 13:11:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As of git head at 25425cb4a5531b1b3f26eba4e49866d944e0f1fb, I'm observing
weird errors initializing all simple I/O engines except 'vsync'. Example:

$ ./fio --ioengine=sync --create_on_open=1 --time_based --runtime=10 --numjobs=1 --rw=read --bs=1k --size=1M --name=test-read-1k --filename=fio-1M
test-read-1k: (g=0): rw=read, bs=(R) 1024B-1024B, (W) 1024B-1024B, (T) 1024B-1024B, ioengine=sync, iodepth=1
fio-3.28-11-g2542-dirty
Starting 1 process
fio: pid=13034, err=5/file:backend.c:479, func=full resid, error=Input/output error

test-read-1k: (groupid=0, jobs=1): err= 5 (file:backend.c:479, func=full resid, error=Input/output error): pid=13034: Thu Sep  9 13:04:51 2021
   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=16
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=1,0,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):

Disk stats (read/write):
   sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

The same thing happens with 'psync', 'pvsync' and 'pvsync2', but 'vsync' seems to work:

$ ./fio --ioengine=vsync --create_on_open=1 --time_based --runtime=10 --numjobs=1 --rw=read --bs=1k --size=1M --name=test-read-1k --filename=fio-1M
test-read-1k: (g=0): rw=read, bs=(R) 1024B-1024B, (W) 1024B-1024B, (T) 1024B-1024B, ioengine=vsync, iodepth=1
fio-3.28-11-g2542-dirty
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=627MiB/s][r=642k IOPS][eta 00m:00s]
test-read-1k: (groupid=0, jobs=1): err= 0: pid=13105: Thu Sep  9 13:06:54 2021
   read: IOPS=627k, BW=612MiB/s (642MB/s)(6122MiB/10001msec)
     clat (nsec): min=423, max=67325, avg=821.73, stdev=1436.87
      lat (nsec): min=477, max=67448, avg=896.28, stdev=1492.29
     clat percentiles (nsec):
      |  1.00th=[  434],  5.00th=[  442], 10.00th=[  450], 20.00th=[  458],
      | 30.00th=[  466], 40.00th=[  474], 50.00th=[  490], 60.00th=[  516],
      | 70.00th=[  740], 80.00th=[ 1096], 90.00th=[ 1240], 95.00th=[ 1656],
      | 99.00th=[ 3184], 99.50th=[13888], 99.90th=[21632], 99.95th=[23936],
      | 99.99th=[29824]
    bw (  KiB/s): min=408604, max=650082, per=99.91%, avg=626337.05, stdev=53380.19, samples=19
    iops        : min=408604, max=650082, avg=626337.47, stdev=53380.34, samples=19
   lat (nsec)   : 500=55.10%, 750=15.20%, 1000=5.43%
   lat (usec)   : 2=21.09%, 4=2.40%, 10=0.24%, 20=0.39%, 50=0.14%
   lat (usec)   : 100=0.01%
   cpu          : usr=60.91%, sys=38.47%, ctx=43, majf=0, minf=13
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
      issued rwts: total=6269388,0,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
    READ: bw=612MiB/s (642MB/s), 612MiB/s-612MiB/s (642MB/s-642MB/s), io=6122MiB (6420MB), run=10001-10001msec

Disk stats (read/write):
   sda: ios=0/64, merge=0/29, ticks=0/149, in_queue=156, util=0.19%

BTW, should 'fio-1M' file be empty after running the workload?

I'm running Fedora 34, recently updated to kernel version 5.13.14, and
seems has no issues with underlying filesystem where FIO is running.

Dmitry
