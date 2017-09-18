Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:54816 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752106AbdIRKWg (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 06:22:36 -0400
Received: by mail-io0-f177.google.com with SMTP id h66so871345ioh.11
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 03:22:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
References: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 18 Sep 2017 13:21:55 +0300
Message-ID: <CAHndrBkj3euCega6mjP4Bq+XJ1-yRjDuN4U-BprLCyiOcGFpEQ@mail.gmail.com>
Subject: Re: fio-3.0-61-g9acb0 engine libaio not loadable Centos7.3x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Udi-Yehuda Tamar <udi@excelero.com>
Cc: fio@vger.kernel.org

Using libaio on current upstream works fine with me.
Assuming your ${IOENGINE} is "libaio", what does below print ?

# fio --enghelp | grep libaio

This part of the message is a bit confusing, as libaio isn't an
external ioengine, i.e. it should be found from the existing ones
rather than having have to dlopen it.
(But we have this logic for backward compatibility reason)

ERROR: fio: engine libaio not loadable
ERROR: fio: failed to load engine
DEBUG: fio: file:ioengines.c:91, func=dlopen, error=libaio: cannot
open shared object file: No such file or directory


2017-09-18 11:54 GMT+03:00 Udi-Yehuda Tamar <udi@excelero.com>:
> Hello Guys,
>
> I'm using the following config:
>
> [global]
> rw=randrw
> numjobs=${NUMJOBS}
> blocksize=${BLOCKSIZE}
> iodepth=${IODEPTH}
> rwmixread=${RWMIXREAD}
> ioengine=${IOENGINE}
> direct=1
> refill_buffers
> norandommap
> randrepeat=0
> group_reporting
> filesize=5G
> runtime=180
> time_based
>
> [RAND_VOL1]
> filename=${AUTOMATION_MNT_DIR1}/file
>
>
> After moving from 2.99 to v3.0.61 I got:
>
> DEBUG: ROUND PARAMS: job=8 ioDepth=1 blockSize=4k rwmixread=0 ioEngine=libaio
> ERROR: fio: engine libaio not loadable
> ERROR: fio: failed to load engine
> DEBUG: fio: file:ioengines.c:91, func=dlopen, error=libaio: cannot
> open shared object file: No such file or directory
>
> libaio and libaio-devel are both installed on latest , any Idea ?
>
> --
> Thanks,
> Udi-Yehuda Tamar.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
