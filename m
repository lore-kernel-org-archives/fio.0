Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106ADEB64DC
	for <fio@archiver.kernel.org>; Sun, 25 Jun 2023 21:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjFYV5z (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 25 Jun 2023 17:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFYV5y (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 25 Jun 2023 17:57:54 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A171A6
        for <fio@vger.kernel.org>; Sun, 25 Jun 2023 14:57:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fa96fd79f0so4816775e9.3
        for <fio@vger.kernel.org>; Sun, 25 Jun 2023 14:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687730271; x=1690322271;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O0eIn/i/M5RHun4WSJCTRWV0EFDMCnG30MSYKeTDCZo=;
        b=fSFroaf+lTCyx2xV6tqI20AYZ3qSUN3ZmAQuuDk9APg5aazeHFyeU8pCpICTWlGXD3
         5H32yYL6r1ZNTP2245esfNFALCJBqe04JY1CSo5itkvH1IDRd63wMbFwM0gp6G+6n5F3
         OUlmWSpBNlYFRVAueLT9hPmWL7PB034BVc+7cW+8q2pz8t+bG6UWdsNYokWO8/qzfBvS
         o2nyu3EvuI0QmDaBtIzu29YGOBto5C6UkL1laMWjsbiUM4CQSXtAJkCZ6WRJbkSY94ub
         0AdumENxeqUIuZgkG+x5EH3M4zfkZbsQG3PH9XCmWfRmblrdi5uDTlTLy3Ij+D+MrI0i
         24Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687730271; x=1690322271;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O0eIn/i/M5RHun4WSJCTRWV0EFDMCnG30MSYKeTDCZo=;
        b=jxkH4UlgYsDAz6XjXSQgudRRIULF+hVv8seny1F/TASla/EkaJOP7anOdl9Kx9yjh5
         DX1kT4+6z0TVmqH7cVHdsFnjNZq8DwBuqviJD0ufzT3BZ+7XIYtPARvIWrvWNW6LNoRy
         ATVx4suq8b4ojWSKKwRbk1JOBuTD6oF6jr+jp91JZShYwwugbVBsUibed4fj+MSkIlzW
         xkNultflsyQJbS8pvJ4tXtgEBWgAi6OBlq6ngPeRiaqj4rIK5AEFeQuAdlN7RGCxAG7J
         7+yjAShae22DR+EaBitGHwOYsugwrsmOoXsigIqT9qV05Y699j7OcShAuKCHlw0jUsfk
         SUZQ==
X-Gm-Message-State: AC+VfDyRIp9TlkMqfM5iuf/4Y9vOyD0QX4v0mf94oYWIwYaZE9cUtIBg
        saMvzrv0u0B09MasqyDvgVZX4+n/V/RKdbQUs6amfChaG48=
X-Google-Smtp-Source: ACHHUZ6JKS3r5aa5uxHYlUATGViyu/qtdDca7577gpxhxQ4xC7QkfVHvulDAuKY7nOoxx+0vuAagDKuMtxqFpmjntEs=
X-Received: by 2002:a05:600c:22c6:b0:3f9:b244:c294 with SMTP id
 6-20020a05600c22c600b003f9b244c294mr23124316wmg.35.1687730271402; Sun, 25 Jun
 2023 14:57:51 -0700 (PDT)
MIME-Version: 1.0
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Mon, 26 Jun 2023 05:57:40 +0800
Message-ID: <CAJNi4rNuudfMQEQqGN4SbLB72CwpyoAZ05EkmdLAKAY9d2f7vg@mail.gmail.com>
Subject: Question about the internals of the file IO latency
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I found that the latency output from fio (running in my own embedded
board) increases when the size is also increased, the output is:

fio --direct=0 --iodepth=1  --thread --rw=read --ioengine=sync --bs=4k
--size=16M --numjobs=1 --runtime=30 --group_reporting
--filename=/tmp/f0 --name=dummy

f0: Laying out IO file (1 file / 16MiB)


f0: (groupid=0, jobs=1): err= 0: pid=3: Mon Jun 26 05:41:47 2023

  read: IOPS=15.6k, BW=61.1MiB/s (64.0MB/s)(16.0MiB/262msec)

    clat (usec): min=51, max=181, avg=55.75, stdev= 5.63

     lat (usec): min=52, max=182, avg=56.62, stdev= 5.67

    clat percentiles (usec):

     |  1.00th=[   52],  5.00th=[   53], 10.00th=[   53], 20.00th=[   54],

     | 30.00th=[   55], 40.00th=[   55], 50.00th=[   56], 60.00th=[   56],

     | 70.00th=[   57], 80.00th=[   57], 90.00th=[   58], 95.00th=[   60],

     | 99.00th=[   85], 99.50th=[   92], 99.90th=[  108], 99.95th=[  127],

     | 99.99th=[  182]

  lat (usec)   : 100=99.73%, 250=0.27%

  cpu          : usr=35.25%, sys=0.00%, ctx=0, majf=0, minf=0

  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%

     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%

     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%

     issued rwts: total=4096,0,0,0 short=0,0,0,0 dropped=0,0,0,0

     latency   : target=0, window=0, percentile=100.00%, depth=1


Run status group 0 (all jobs):

   READ: bw=61.1MiB/s (64.0MB/s), 61.1MiB/s-61.1MiB/s
(64.0MB/s-64.0MB/s), io=16.0MiB (16.8MB), run=262-262msec

fio --direct=0 --iodepth=1  --thread --rw=read --ioengine=sync --bs=4k
--size=32M --numjobs=1 --runtime=30 --group_reporting
--filename=/tmp/f0 --name=dummy

f0: Laying out IO file (1 file / 32MiB)


f0: (groupid=0, jobs=1): err= 0: pid=3: Mon Jun 26 05:43:47 2023

  read: IOPS=12.4k, BW=48.4MiB/s (50.8MB/s)(32.0MiB/661msec)

    clat (usec): min=64, max=420, avg=72.39, stdev= 8.85

     lat (usec): min=65, max=421, avg=73.27, stdev= 8.87

    clat percentiles (usec):

     |  1.00th=[   67],  5.00th=[   68], 10.00th=[   68], 20.00th=[   69],

     | 30.00th=[   70], 40.00th=[   71], 50.00th=[   72], 60.00th=[   73],

     | 70.00th=[   74], 80.00th=[   75], 90.00th=[   76], 95.00th=[   78],

     | 99.00th=[  115], 99.50th=[  131], 99.90th=[  163], 99.95th=[  169],

     | 99.99th=[  420]

   bw (  KiB/s): min=48840, max=48840, per=98.52%, avg=48840.00,
stdev= 0.00, samples=1

   iops        : min=12210, max=12210, avg=12210.00, stdev= 0.00, samples=1

  lat (usec)   : 100=98.57%, 250=1.42%, 500=0.01%

  cpu          : usr=23.03%, sys=0.00%, ctx=0, majf=0, minf=0

  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%

     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%

     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%

     issued rwts: total=8192,0,0,0 short=0,0,0,0 dropped=0,0,0,0

     latency   : target=0, window=0, percentile=100.00%, depth=1


Run status group 0 (all jobs):

   READ: bw=48.4MiB/s (50.8MB/s), 48.4MiB/s-48.4MiB/s
(50.8MB/s-50.8MB/s), io=32.0MiB (33.6MB), run=661-661msec

Does anyone help explain why the latency increases when the size
changes from 16M to 32M? Thanks!
