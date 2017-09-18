Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:47115 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbdIRI7A (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 04:59:00 -0400
Received: by mail-wm0-f54.google.com with SMTP id 13so619578wmq.2
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 01:59:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
References: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Mon, 18 Sep 2017 11:58:58 +0300
Message-ID: <CAOfm_=VkkHN6NOeTZH3ShrmYpumbaAKBJnf4dW-nMKiEmS6tzg@mail.gmail.com>
Subject: Re: fio-3.0-61-g9acb0 engine libaio not loadable Centos7.3x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I just retest it and in 2.99 all is working but v3 not
please elaborate

On Mon, Sep 18, 2017 at 11:54 AM, Udi-Yehuda Tamar <udi@excelero.com> wrote:
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



-- 
Thanks,
Udi-Yehuda Tamar.
