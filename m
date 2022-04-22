Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF34C4167B
	for <fio@archiver.kernel.org>; Fri, 22 Apr 2022 22:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiDVW2p (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiDVW20 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Apr 2022 18:28:26 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39FE245E69
        for <fio@vger.kernel.org>; Fri, 22 Apr 2022 14:57:13 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-e5c42b6e31so9975853fac.12
        for <fio@vger.kernel.org>; Fri, 22 Apr 2022 14:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=AqEqdoyNkJLHnt2tgvo4gn3tQGkctZh7h91eSYcQFdM=;
        b=DN6fJ5wITZ9zBbi4DqLq2Req8g9sV30qBG4X0W8aeBMippKJX2Wl5WAroRMKzZs7EZ
         8KoXZWjyKPb9C8TChVcBg6QMerxywO6ed8vZ4olNt1882bt5WZyjtRWVE1a39MzuJ84o
         rpbogXAQ+ISKtsP9JPTaJIWQddB2ziyN7LhEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=AqEqdoyNkJLHnt2tgvo4gn3tQGkctZh7h91eSYcQFdM=;
        b=3gjR0CU08r+DVnBFtcTzYW7iW6Do6gAZlpQM5OXS9PW3BLzvVk2zGOTbLJR4ANGEek
         r7MbxgpmZNgAnx4wax0g6umUeMGFY16aNY1tOSKOoG9FbR/Q2KJFV+bbC9p/XOzxrbv5
         1asYbHjGJTXJ9zacsQUBkE4bibVN0sx6n7hiEtCTU1Uw0TOVtwPX2FGEgLagUiMtXmyU
         cjY3TqkmcDVWswf2jEbAIY4G5MPTSSGIyGng9bgdGE7xZhvbnY68keTDAvtYRrGWFrw9
         vnXH3ZWBbVL7RtJDCrxpp/urXdfCJaNvB/H/BcKjrVWQ5MXliYom6w8NfH1capphfSDS
         JiuA==
X-Gm-Message-State: AOAM533THMIbrGNmjxD1vYcQ9psBxKuD71ru1/k4ro1EyF/fbgkCRifC
        skpMxbDzr1YW6KgaCiezIxw3O6/VoDSU3y2H0GVLDYUKnzfN2Y3g
X-Google-Smtp-Source: ABdhPJwotsxznvtMHWimBEW0ESi3FiAgpa+QeFHKV9W4f8N9pAirGQKGzqS20z1sX61u1AGHljEnTHcAMRfRe5tC7TU=
X-Received: by 2002:a05:6870:d691:b0:de:e1b7:8eed with SMTP id
 z17-20020a056870d69100b000dee1b78eedmr3004205oap.251.1650664633086; Fri, 22
 Apr 2022 14:57:13 -0700 (PDT)
MIME-Version: 1.0
From:   Elliott Balsley <ebalsley@netflix.com>
Date:   Fri, 22 Apr 2022 14:57:02 -0700
Message-ID: <CALajkdhAFm1WSKQpjPj9QLwcoiqFopDoHimsicqtKCqLOYDrBA@mail.gmail.com>
Subject: IO Depth lower than requested
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm testing some NVMe drives and I notice the IO Depth reported by fio
output is lower than what I specify in the job.  Is the command-line
output showing the attempted depth or the actual achieved depth?
Here's an example output where I tried iodepth=3D32.  The first line (IO
depths) shows a mix of 8 and 16.  The next 2 lines (submit and
complete) show 4.  What's the difference between the first and second
lines?  I was expecting "submit" to be 32 and "complete" to maybe be
lower based on hardware and OS limitations.  Oddly enough, if I
specify iodepth=3D4 then performance is actually a bit better (32K
instead of 35K) even though the submit/complete depths shown remain
the same.
Also =E2=80=94 is there a way to find out what is limiting this?  The Micro=
n
9300 Pro should support QD=3D512 according to its spec sheet.

% fio --randrepeat=3D1 --name=3Dtest --bs=3D4k --iodepth=3D32 --size=3D1G
--readwrite=3Drandread --directory /Volumes/Micron9300/elliott
--ioengine posixaio
test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=3Dposixaio, iodepth=3D32
fio-3.30
Starting 1 process
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D137MiB/s][r=3D35.1k IOPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6903: Fri Apr 22 12:25:34 20=
22
  read: IOPS=3D35.0k, BW=3D137MiB/s (143MB/s)(1024MiB/7498msec)
    slat (nsec): min=3D0, max=3D46000, avg=3D823.84, stdev=3D784.94
    clat (usec): min=3D179, max=3D874, avg=3D455.01, stdev=3D50.98
     lat (usec): min=3D180, max=3D875, avg=3D455.84, stdev=3D50.88
    clat percentiles (usec):
     |  1.00th=3D[  318],  5.00th=3D[  367], 10.00th=3D[  392], 20.00th=3D[=
  416],
     | 30.00th=3D[  433], 40.00th=3D[  445], 50.00th=3D[  457], 60.00th=3D[=
  469],
     | 70.00th=3D[  482], 80.00th=3D[  494], 90.00th=3D[  515], 95.00th=3D[=
  537],
     | 99.00th=3D[  578], 99.50th=3D[  594], 99.90th=3D[  652], 99.95th=3D[=
  668],
     | 99.99th=3D[  717]
   bw (  KiB/s): min=3D139419, max=3D140595, per=3D100.00%, avg=3D140110.71=
,
stdev=3D340.75, samples=3D14
   iops        : min=3D34854, max=3D35148, avg=3D35027.43, stdev=3D85.14, s=
amples=3D14
  lat (usec)   : 250=3D0.06%, 500=3D82.67%, 750=3D17.27%, 1000=3D0.01%
  cpu          : usr=3D19.97%, sys=3D13.74%, ctx=3D195959, majf=3D0, minf=
=3D28
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D43.4%, 16=3D56.6%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.9%, 16=3D0.1%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D262144,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D32

Run status group 0 (all jobs):
   READ: bw=3D137MiB/s (143MB/s), 137MiB/s-137MiB/s (143MB/s-143MB/s),
io=3D1024MiB (1074MB), run=3D7498-7498msec

Thanks,
Elliott
