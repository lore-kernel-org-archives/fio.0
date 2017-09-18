Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:49287 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdIRIyv (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 04:54:51 -0400
Received: by mail-wm0-f42.google.com with SMTP id e71so563053wmg.4
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 01:54:51 -0700 (PDT)
MIME-Version: 1.0
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Mon, 18 Sep 2017 11:54:49 +0300
Message-ID: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
Subject: fio-3.0-61-g9acb0 engine libaio not loadable Centos7.3x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello Guys,

I'm using the following config:

[global]
rw=randrw
numjobs=${NUMJOBS}
blocksize=${BLOCKSIZE}
iodepth=${IODEPTH}
rwmixread=${RWMIXREAD}
ioengine=${IOENGINE}
direct=1
refill_buffers
norandommap
randrepeat=0
group_reporting
filesize=5G
runtime=180
time_based

[RAND_VOL1]
filename=${AUTOMATION_MNT_DIR1}/file


After moving from 2.99 to v3.0.61 I got:

DEBUG: ROUND PARAMS: job=8 ioDepth=1 blockSize=4k rwmixread=0 ioEngine=libaio
ERROR: fio: engine libaio not loadable
ERROR: fio: failed to load engine
DEBUG: fio: file:ioengines.c:91, func=dlopen, error=libaio: cannot
open shared object file: No such file or directory

libaio and libaio-devel are both installed on latest , any Idea ?

-- 
Thanks,
Udi-Yehuda Tamar.
