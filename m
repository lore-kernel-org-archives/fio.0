Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f44.google.com ([209.85.217.44]:40207 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDTLOW (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 Apr 2019 07:14:22 -0400
Received: by mail-vs1-f44.google.com with SMTP id f22so4017082vso.7
        for <fio@vger.kernel.org>; Sat, 20 Apr 2019 04:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAJQBtg=eBdodQUD8f=b7qmZrHM-0NZKzDLcp9tPGduJncF9zCg@mail.gmail.com>
 <CANQz8Z+JKij4F2R5x=gpvRcMvuyTaGc3xwbLf=THs36c0QZy-A@mail.gmail.com>
In-Reply-To: <CANQz8Z+JKij4F2R5x=gpvRcMvuyTaGc3xwbLf=THs36c0QZy-A@mail.gmail.com>
From: Left Right <olegsivokon@gmail.com>
Date: Sat, 20 Apr 2019 11:14:08 +0300
Message-ID: <CAJQBtg=hof2+rKROTOU52Jd-sR=2XP4GdBrgvZhUjSD6b6SZcg@mail.gmail.com>
Subject: Re: The test screams DI, but the data seems OK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Peter Ushakov <ko3luhbka@gmail.com>, fio@vger.kernel.org

Hello Peter,

I see how that might be a problem, but then I hoped that maybe there's
a way to somehow overcome this? Unfortunately, this makes a several
hours difference per test (and few dozens of hours of difference per
set of tests).

I'm not really familiar with FIO's code, but if this wasn't possible
at the API level, but was still possible with a little modification of
the source code, I'd be interested to know that too.

Thanks!

On Sat, Apr 20, 2019 at 1:45 PM Peter Ushakov <ko3luhbka@gmail.com> wrote:
>
> Hello Oleg.
> As far as I know block size in both write and verify jobs must be the sam=
e or fio will fail during verification (I guess this is what are observing)=
. So if you need to test reading with different bs you should first perform=
 writing with that bs.
>
>
> =D1=81=D0=B1, 20 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 12:00, Left Righ=
t <olegsivokon@gmail.com>:
>>
>> Hello list!
>>
>> I'm writing tests for a product that is essentially an iSCSI server. I
>> had the test below written without time limit at first, but since that
>> would make the test very long, I decided to add the limit. Once that
>> happened, the test suggests that there is a data integrity problem.
>> Surprisingly, the byte it complains about always has the same value.
>> I.e. not only the DI error happens all the time, it is always
>> incorrect in the same way, and it's not some default value you would
>> normally expect (like, say, all unset bits)... All of this leads me to
>> question whether the test is at fault, and whether the test, as
>> written, makes sense:
>>
>>
>> [global]
>> ioengine=3Dlibaio
>> direct=3D1
>> loops=3D1
>> size=3D16G
>> numjobs=3D1
>> verify=3Dcrc32c
>> log_avg_msec=3D1
>> filename=3D/dev/sdc
>>
>> [4k-depth-1-prep]
>> bs=3D128k
>> iodepth=3D32
>> rw=3Dwrite
>> do_verify=3D0
>> stonewall=3D1
>>
>> [4k-depth-1]
>> bs=3D4k
>> runtime=3D30M
>> rw=3Drandread
>> iodepth=3D1
>> stonewall=3D1
>> do_verify=3D1
>> write_lat_log=3Dread-4k-depth1-lat
>> write_bw_log=3Dread-4k-depth1-bw
>> write_iops_log=3Dread-4k-depth1-iops
>>
>> My other worry is the different block sizes in the write and read
>> phases as well as iodepth. The parameters for write workload are this
>> way to speed it up (the product works better with higher concurrency
>> and bigger block sizes), but I need to test reading with different
>> block sizes.
>>
>> Thanks!
>>
>> Oleg

