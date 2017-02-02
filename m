Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:32832 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdBBXFR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Feb 2017 18:05:17 -0500
Received: by mail-vk0-f41.google.com with SMTP id k127so1995237vke.0
        for <fio@vger.kernel.org>; Thu, 02 Feb 2017 15:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADMvz70d1eeRiiz0zwMTWOLqz4nu93TxUitM_fTo_KY_qpuWqA@mail.gmail.com>
References: <CADMvz72k8xgfw9uR=-2GbDqcrGV6OPOQZ6EFHEGTf4ydzNvYTw@mail.gmail.com>
 <CADMvz73UANC74K=owpoLDpYae8=fs_UkJ6DSAvO8jGttRc+mgQ@mail.gmail.com>
 <CADMvz73wESUZh_0ZVAK-m28GAsjhA2ss_Tixr=fMVmHzMNsMUA@mail.gmail.com>
 <CALjAwxi+EsVgaHLozUt6VhqFPjpuPSHzw4xu0zgWEX2jQ=wWwg@mail.gmail.com> <CADMvz70d1eeRiiz0zwMTWOLqz4nu93TxUitM_fTo_KY_qpuWqA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 2 Feb 2017 23:04:46 +0000
Message-ID: <CALjAwxgsx3_vs+AL9ZVHnOT-jXybKpgjUWnohfSmk4Wiz3NGyw@mail.gmail.com>
Subject: Re: fio over hdfs
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: ankit patel <ankitpatel.edu@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

You should only need the --enable-libhdfs part and not the stuff after
the brackets on the configure line.

I don't use the HDFS so I can't say much but perhaps there are some
clues in https://github.com/axboe/fio/blob/master/configure#L1544 ?

On 2 February 2017 at 22:58, ankit patel <ankitpatel.edu@gmail.com> wrote:
> I have   --enable-libhdfs) libhdfs="yes"
> but following variables are empty.
> can you help me identify their meaning and figure our where it needs
> to be pointed?
>
>
> #echo "FIO_HDFS_CPU=$FIO_HDFS_CPU"
> FIO_HDFS_CPU=
> #   echo "JAVA_HOME=$JAVA_HOME"
> JAVA_HOME=/opt/jdk
> #echo "FIO_LIBHDFS_INCLUDE=$FIO_LIBHDFS_INCLUDE"
> FIO_LIBHDFS_INCLUDE=
> #   echo "FIO_LIBHDFS_LIB=$FIO_LIBHDFS_LIB"
> FIO_LIBHDFS_LIB=
>
>
>
>
> On Thu, Feb 2, 2017 at 2:32 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hi,
>>
>> A look through https://github.com/axboe/fio/blob/master/configure
>> suggests for things related to HDFS suggests the following:
>> * Have you made sure the environment variables JAVA_HOME ,
>> FIO_LIBHDFS_INCLUDE , FIO_LIBHDFS_LIB are set correctly before running
>> configure?
>> * Have you added the --enable-libhdfs ./configure parameter?
>>
>> On 2 February 2017 at 22:22, ankit patel <ankitpatel.edu@gmail.com> wrote:
>>> Hello All
>>>
>>> I am trying to install FIO on my hadoop cluster and I aimed to measure
>>> storage BW and latency through HDFS
>>> https://github.com/axboe/fio/issues/301
>>>
>>> while doing ./configure step i see
>>>  "HDFS engine                   no"
>>>
>>> followed by an error when I tried to use libhdfs with fio;
>>> ./fio --name=random-writers --ioengine=libhdfs --iodepth=4
>>> --rw=randwrite --bs=32k --direct=0 --size=64m --numjobs=4
>>> fio: engine libhdfs not loadable
>>> fio: failed to load engine libhdfs
>>> fio: file:ioengines.c:91, func=dlopen, error=libhdfs: cannot open
>>> shared object file: No such file or directory
>>>
>>> can you help me with how can i enable fio vi hdfs
>>
>> --
>> Sitsofe | http://sucs.org/~sits/
>
>
>
> --
> Thanks,
> Ankit Patel



-- 
Sitsofe | http://sucs.org/~sits/
