Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:44835 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdIRLK0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 07:10:26 -0400
Received: by mail-wm0-f51.google.com with SMTP id 189so12699687wmh.1
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 04:10:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHndrB=W=G1ks1tcYm9w1tD7X44CVDy+BtrJ9Um0hTfMPR0bvg@mail.gmail.com>
References: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
 <CAHndrBkj3euCega6mjP4Bq+XJ1-yRjDuN4U-BprLCyiOcGFpEQ@mail.gmail.com>
 <CAOfm_=UZAoKf2BgU6S=eHAjonLWCBNxUUxeHF8hCTSi2k+W-sw@mail.gmail.com> <CAHndrB=W=G1ks1tcYm9w1tD7X44CVDy+BtrJ9Um0hTfMPR0bvg@mail.gmail.com>
From: Udi-Yehuda Tamar <udi@excelero.com>
Date: Mon, 18 Sep 2017 14:10:24 +0300
Message-ID: <CAOfm_=VdSQm6jypyTmifghtktLmWrx4gP-LR3nRYLygmJpTdHQ@mail.gmail.com>
Subject: Re: fio-3.0-61-g9acb0 engine libaio not loadable Centos7.3x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio@vger.kernel.org

thx I'll try to re-compile the code

On Mon, Sep 18, 2017 at 2:06 PM, Tomohiro Kusumi
<kusumi.tomohiro@gmail.com> wrote:
> fio checks libaio via test C code embedded in ./configure script when compiling,
> rather than whether you have certain RPMs in certain distro or not.
>
> See around L543 of ./configure where it says "linux-aio probe".
> It seems your environment failed to compile the test code embedded
> here, and $libaio flag has stayed "no".
>
> 2017-09-18 13:54 GMT+03:00 Udi-Yehuda Tamar <udi@excelero.com>:
>> Hey Tomohiro,
>> this is what I got as you can see libaio is missing but installed
>>
>>
>> root@host# rpm -qa | grep libaio
>> libaio-0.3.109-13.el7.x86_64
>> libaio-devel-0.3.109-13.el7.x86_64
>>
>>
>> root@host# ./fio --version
>> fio-3.0-50-gc032d
>> root@host# ./fio --enghelp | grep libaio
>> root@host# ./fio --enghelp
>> Available IO engines:
>> cpuio
>> mmap
>> sync
>> psync
>> vsync
>> pvsync
>> pvsync2
>> null
>> net
>> netsplice
>> ftruncate
>> posixaio
>> falloc
>> e4defrag
>> splice
>> mtd
>> sg
>> binject
>>
>> On Mon, Sep 18, 2017 at 1:21 PM, Tomohiro Kusumi
>> <kusumi.tomohiro@gmail.com> wrote:
>>> Using libaio on current upstream works fine with me.
>>> Assuming your ${IOENGINE} is "libaio", what does below print ?
>>>
>>> # fio --enghelp | grep libaio
>>>
>>> This part of the message is a bit confusing, as libaio isn't an
>>> external ioengine, i.e. it should be found from the existing ones
>>> rather than having have to dlopen it.
>>> (But we have this logic for backward compatibility reason)
>>>
>>> ERROR: fio: engine libaio not loadable
>>> ERROR: fio: failed to load engine
>>> DEBUG: fio: file:ioengines.c:91, func=dlopen, error=libaio: cannot
>>> open shared object file: No such file or directory
>>>
>>>
>>> 2017-09-18 11:54 GMT+03:00 Udi-Yehuda Tamar <udi@excelero.com>:
>>>> Hello Guys,
>>>>
>>>> I'm using the following config:
>>>>
>>>> [global]
>>>> rw=randrw
>>>> numjobs=${NUMJOBS}
>>>> blocksize=${BLOCKSIZE}
>>>> iodepth=${IODEPTH}
>>>> rwmixread=${RWMIXREAD}
>>>> ioengine=${IOENGINE}
>>>> direct=1
>>>> refill_buffers
>>>> norandommap
>>>> randrepeat=0
>>>> group_reporting
>>>> filesize=5G
>>>> runtime=180
>>>> time_based
>>>>
>>>> [RAND_VOL1]
>>>> filename=${AUTOMATION_MNT_DIR1}/file
>>>>
>>>>
>>>> After moving from 2.99 to v3.0.61 I got:
>>>>
>>>> DEBUG: ROUND PARAMS: job=8 ioDepth=1 blockSize=4k rwmixread=0 ioEngine=libaio
>>>> ERROR: fio: engine libaio not loadable
>>>> ERROR: fio: failed to load engine
>>>> DEBUG: fio: file:ioengines.c:91, func=dlopen, error=libaio: cannot
>>>> open shared object file: No such file or directory
>>>>
>>>> libaio and libaio-devel are both installed on latest , any Idea ?
>>>>
>>>> --
>>>> Thanks,
>>>> Udi-Yehuda Tamar.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Thanks,
>> Udi-Yehuda Tamar.



-- 
Thanks,
Udi-Yehuda Tamar.
