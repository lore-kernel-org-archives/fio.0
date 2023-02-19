Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCAEC61DA4
	for <fio@archiver.kernel.org>; Sun, 19 Feb 2023 05:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBSFm1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 19 Feb 2023 00:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjBSFmR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 19 Feb 2023 00:42:17 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6CC13DFF
        for <fio@vger.kernel.org>; Sat, 18 Feb 2023 21:41:54 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l2-20020a05600c1d0200b003e1f6dff952so34542wms.1
        for <fio@vger.kernel.org>; Sat, 18 Feb 2023 21:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V4AFl3Zpfzhgs2hAsIoi3Y3/tN+m9N1LG8wAREdOD9Y=;
        b=mSOkluqz2d8KCuMlPYslTgZniTeotKUOtTXxVMiImRyEZnNdgRrh8qDkvQZpdlweG1
         Ixshe99R3y1Ez0Ko35K4PMukCErH+bBUo6EAN4/ZGQ3xUVAFZ+QryN+Cy3Dp88FJ9tlG
         U5seVSWGS2kUfZPQGzlZLaETcx18cUZli6wnI+WM++0p7Dz+yROcb4ZRC6tFn5ogXpuM
         pHM9qhW97/jC9sHvghlTc2Gy4oQLbg5qBM76lCD9ntrcq/qziNc63Jod2vCj1XyYkgmy
         4g0NYok0BSB2rL7s0l9UJNf9rBsladgYv4hb78wdXmbvI6pqOY/kI2dIujfznZPH6aZz
         RJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4AFl3Zpfzhgs2hAsIoi3Y3/tN+m9N1LG8wAREdOD9Y=;
        b=Sa7FSPCD0OXaM53k3EmP9kcRFjNriNw3Bmf3+XeIIPsNA+eRjQm4o8Hdugx5sbVsS6
         AGONNhqXjJYpdGedSpuCKew7ndJ8WgPxoZeBwikbHbNuyrY2SQyYbXDra6UvjYF6fG64
         cs1iN18APQbbAbP8SwBYEOST/0bKlSysJE8ZVPFhGrrP2pAqOOy4XOhEKE3spRvkC1/b
         5FA3OUiv54v/c/mawienBGdrx9f0gx3pEJcrG6fPetti6seiE6VHvlLy2RMHCl7lcJob
         r/lBkeKetZItHklb7iJR4QPtSsbgTn3HO0beQLTqtk/8RZvNieGBfrWtYdKjI45vyONx
         lJhA==
X-Gm-Message-State: AO0yUKUnM7qFU6dNuq+Tv5HvmfZEPJ3E7tsAr7g+S5lT49omwGOyqSOD
        /i1JkXHcxNN3kXBoV2qhM85rKCpytwqUnV5ABnle691lq/A=
X-Google-Smtp-Source: AK7set9X550qXNZarQCEOcKe/MliOjyniDyhllwnri8fhsWSouphnNvA+Qxg7Vkbnr227uXF/RQ30CcRc9wkqehvxQ4=
X-Received: by 2002:a05:600c:470d:b0:3dd:2823:e1a4 with SMTP id
 v13-20020a05600c470d00b003dd2823e1a4mr1296090wmo.153.1676785308174; Sat, 18
 Feb 2023 21:41:48 -0800 (PST)
MIME-Version: 1.0
From:   seyed mohammad <seymad.f1@gmail.com>
Date:   Sun, 19 Feb 2023 09:12:03 +0330
Message-ID: <CAMtsHkrJbk8GCrAvfAzKAASYOkaudNX0--mdnWHQ=nnAzhnH0w@mail.gmail.com>
Subject: Problems with interpreting FIO output
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I've run a random read/write FIO test with 400 jobs to benchmark a
RAID setup. The output IOPS and the iops statistics (the average/avg)
are divergent; how can this be interpreted? Should these two values
converge?

Test results for read:
job1: (groupid=0, jobs=400): err= 0: pid=25204:
  read: IOPS=199k, BW=778MiB/s (816MB/s)(23.8GiB/31279msec)
    slat (usec): min=3, max=1401.7k, avg=1423.58, stdev=38712.03
    clat (usec): min=60, max=2683.7k, avg=86310.45, stdev=289174.76
     lat (usec): min=70, max=2683.7k, avg=87730.40, stdev=291369.20
    clat percentiles (usec):
     |  1.00th=[    239],  5.00th=[    562], 10.00th=[    717],
     | 20.00th=[    816], 30.00th=[    865], 40.00th=[    906],
     | 50.00th=[    947], 60.00th=[    988], 70.00th=[   1057],
     | 80.00th=[   1156], 90.00th=[   2147], 95.00th=[ 935330],
     | 99.00th=[1266680], 99.50th=[1300235], 99.90th=[1350566],
     | 99.95th=[1384121], 99.99th=[1803551]
   bw (  MiB/s): min=  228, max= 3556, per=100.00%, avg=1553.73,
stdev= 2.08, samples=12469
   iops        : min=58376, max=910489, avg=397711.45, stdev=532.63,
samples=12469

Test results for write:
 write: IOPS=85.1k, BW=334MiB/s (350MB/s)(10.2GiB/31279msec); 0 zone resets
    slat (usec): min=7, max=1397.5k, avg=1430.09, stdev=38675.97
    clat (usec): min=14, max=2684.1k, avg=97398.93, stdev=306662.71
     lat (usec): min=28, max=2684.1k, avg=98825.72, stdev=308705.23
    clat percentiles (usec):
     |  1.00th=[    314],  5.00th=[    635], 10.00th=[    717],
     | 20.00th=[    791], 30.00th=[    840], 40.00th=[    881],
     | 50.00th=[    922], 60.00th=[    971], 70.00th=[   1057],
     | 80.00th=[   1270], 90.00th=[  10290], 95.00th=[1044382],
     | 99.00th=[1266680], 99.50th=[1300235], 99.90th=[1350566],
     | 99.95th=[1384121], 99.99th=[1769997]
   bw (  KiB/s): min=98765, max=1568174, per=100.00%, avg=681623.43,
stdev=924.60, samples=12469
   iops        : min=24675, max=391998, avg=170363.71, stdev=231.14,
samples=12469


The FIO job:
[global]
name=4k random read 4 ios
ioengine=libaio
direct=1
readwrite=randrw
rwmixread=70
iodepth=64
buffered=0
size=400M
runtime=30
time_based
randrepeat=0
norandommap
refill_buffers
ramp_time=10
bs=4k
numjobs=400
group_reporting=1
