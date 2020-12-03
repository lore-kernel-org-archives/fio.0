Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgLCRYf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Dec 2020 12:24:35 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED56C061A4E
        for <fio@vger.kernel.org>; Thu,  3 Dec 2020 09:23:55 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id p8so2688482wrx.5
        for <fio@vger.kernel.org>; Thu, 03 Dec 2020 09:23:55 -0800 (PST)
Received: from [10.0.0.67] ([144.208.199.197])
        by smtp.gmail.com with ESMTPSA id c9sm131169wrp.73.2020.12.03.09.23.52
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:23:52 -0800 (PST)
From: Peter Sabaini <peter@sabaini.at>
Subject: Fio verify crc32 fault
Message-ID: <0de8d04b-bcaa-415a-4587-c5bd7f674079@sabaini.at>
Date: Thu, 3 Dec 2020 18:23:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hey,

I've got a fio verify run on an NVMe that gives me a crc32 verification fault, however it's not reproducible -- when rerunning on the same NVMe it comes back fine. 

Also I'm getting a funny "error=Invalid or incomplete multibyte or wide character" error reported, see below.

Any hints for this?

Many thanks,
peter.

Test output

Running command: sudo -n fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test_verify --bs=4M --iodepth=64 --size=95% --verify=crc32c-intel --runtime=7200s --filename=/dev/nvme0n1 --readwrite=randwrite

fio_test_verify: (g=0): rw=randwrite, bs=4M-4M/4M-4M/4M-4M, ioengine=libaio, iodepth=64
fio-2.2.10
Starting 1 process
crc32c: verify failed at file /dev/nvme0n1 offset 480499466240, length 4194304
       Expected CRC: 5afe4d21
       Received CRC: db867b6c

fio_test_verify: (groupid=0, jobs=1): err=84 (file:io_u.c:1842, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character): pid=5437: Thu Nov 26 12:22:11 2020
  read : io=320324MB, bw=2662.2MB/s, iops=665, runt=120287msec
  write: io=1769.9GB, bw=1800.3MB/s, iops=450, runt=1006702msec
  cpu          : usr=54.13%, sys=4.95%, ctx=815675, majf=0, minf=63136
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued    : total=r=80081/w=453085/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: io=320324MB, aggrb=2662.2MB/s, minb=2662.2MB/s, maxb=2662.2MB/s, mint=120287msec, maxt=120287msec
  WRITE: io=1769.9GB, aggrb=1800.3MB/s, minb=1800.3MB/s, maxb=1800.3MB/s, mint=1006702msec, maxt=1006702msec

Disk stats (read/write):
  nvme0n1: ios=2565084/14498835, merge=5/0, ticks=122248144/1021942068, in_queue=1142848760, util=100.00%

--------------------------------------------------------------------------------


