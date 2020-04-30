Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgD3UwB (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 30 Apr 2020 16:52:01 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14621C035494
        for <fio@vger.kernel.org>; Thu, 30 Apr 2020 13:52:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id g4so835945ljl.2
        for <fio@vger.kernel.org>; Thu, 30 Apr 2020 13:52:00 -0700 (PDT)
MIME-Version: 1.0
From: Elliott Balsley <elliott@altsystems.com>
Date: Thu, 30 Apr 2020 13:51:48 -0700
Message-ID: <CABO+gV9UbBAb1DEtf7zzNnTwUhiSAsSVcm5wCbFHC_ZvRi-tyA@mail.gmail.com>
Subject: Monitoring disk i/o in Windows
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

I built a Windows 2019 server with an NVMe storage pool and I'm using
fio to test performance.  Results from fio are in line with my
expectations for this hardware, but I noticed something strange with
Windows Performance Monitor.  The physical disk r/w throughput
counters are roughly double what they should be.  This holds true for
various different iodepth, numjobs, and block size options.  Logical
Disk throughput counters are accurate.  In this screenshot, fio shows
11.1GiB/s and the physical disk shows about 22.2 GiB/s.  Is there a
logical explanation for this?  Or is there a better disk monitoring
tool to use, something like iostat for Windows?

https://i.postimg.cc/zqrW8ZPk/windows-fio.png?dl=1

The storage pool is created as a simple stripe with no parity or
mirroring and formatted as ReFS.

Thanks,
Elliott

