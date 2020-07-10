Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgGJVNL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Jul 2020 17:13:11 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06AC08C5DC
        for <fio@vger.kernel.org>; Fri, 10 Jul 2020 14:13:11 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id z63so6669730qkb.8
        for <fio@vger.kernel.org>; Fri, 10 Jul 2020 14:13:11 -0700 (PDT)
MIME-Version: 1.0
From: Kurt Dorsey <batlin@gmail.com>
Date: Fri, 10 Jul 2020 16:12:59 -0500
Message-ID: <CAJzzwJz7a=z6x0pOQeyFB3p0=Ou2A=hb_F4vRLbYoHoWA0mGxw@mail.gmail.com>
Subject: Fio SG Engine not allowing iodepth > 16
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am trying to utilize the Fio SG engine and am finding it errors out
with an iodepth > 16.
I have no issues running multiple jobs to get the effected outstanding
IO to the device higher than 16 but it would be really nice
(especially for Sequential IO) to be able to run it on a single job.

Is there a way to allow for iodepths > 16 for the sg engine?

/usr/local/bin/fio --group_reporting=1 --name=4K_Random_Writes_32qd
--filename=/dev/sg12 --iodepth=32 --rw=randrw --rwmixwrite=100
--percentage_random=100 --bs=4K --random_generator=tausworthe64
--randrepeat=0 --runtime=600 --ramp_time=0 --time_based --numjobs=1
--ba=4k --ioengine=sg --norandommap --buffered=0 --thread=0 --direct=0
4K_Random_Writes_32qd: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W)
4096B-4096B, (T) 4096B-4096B, ioengine=sg, iodepth=32
fio-3.19-dirty
Starting 1 process
fio: pid=67809, err=33/file:engines/sg.c:676, func=xfer,
error=Numerical argument out of domain

4K_Random_Writes_32qd: (groupid=0, jobs=1): err=33
(file:engines/sg.c:676, func=xfer, error=Numerical argument out of
domain): pid=67809: Fri Jul 10 18:00:13 2020
  cpu          : usr=0.00%, sys=0.00%, ctx=2, majf=0, minf=55
  IO depths    : 1=5.9%, 2=11.8%, 4=23.5%, 8=47.1%, 16=11.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,17,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):

