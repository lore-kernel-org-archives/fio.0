Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:22996 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbdBCHt5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 02:49:57 -0500
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: fio over hdfs
From: Fabrice Bacchella <fabrice.bacchella@orange.fr>
In-Reply-To: <CALjAwxgsx3_vs+AL9ZVHnOT-jXybKpgjUWnohfSmk4Wiz3NGyw@mail.gmail.com>
Date: Fri, 3 Feb 2017 08:49:54 +0100
Content-Transfer-Encoding: 8bit
Message-Id: <6A078B0C-97DA-40C8-A9E1-5143F1E6442E@orange.fr>
References: <CADMvz72k8xgfw9uR=-2GbDqcrGV6OPOQZ6EFHEGTf4ydzNvYTw@mail.gmail.com> <CADMvz73UANC74K=owpoLDpYae8=fs_UkJ6DSAvO8jGttRc+mgQ@mail.gmail.com> <CADMvz73wESUZh_0ZVAK-m28GAsjhA2ss_Tixr=fMVmHzMNsMUA@mail.gmail.com> <CALjAwxi+EsVgaHLozUt6VhqFPjpuPSHzw4xu0zgWEX2jQ=wWwg@mail.gmail.com> <CADMvz70d1eeRiiz0zwMTWOLqz4nu93TxUitM_fTo_KY_qpuWqA@mail.gmail.com> <CALjAwxgsx3_vs+AL9ZVHnOT-jXybKpgjUWnohfSmk4Wiz3NGyw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: ankit patel <ankitpatel.edu@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>

./configure --enable-libhdfs
...
configure: FIO_LIBHDFS_INCLUDE should be defined to libhdfs inlude path
configure: FIO_LIBHDFS_LIB should be defined to libhdfs library path

What else do you need ? All the explanations are given. Appart for a typo: include no inlude.


> Le 3 févr. 2017 à 00:04, Sitsofe Wheeler <sitsofe@gmail.com> a écrit :
> 
> You should only need the --enable-libhdfs part and not the stuff after
> the brackets on the configure line.
> 
> I don't use the HDFS so I can't say much but perhaps there are some
> clues in https://github.com/axboe/fio/blob/master/configure#L1544 ?
> 
> On 2 February 2017 at 22:58, ankit patel <ankitpatel.edu@gmail.com> wrote:
>> I have   --enable-libhdfs) libhdfs="yes"
>> but following variables are empty.
>> can you help me identify their meaning and figure our where it needs
>> to be pointed?
>> 
>> 
>> #echo "FIO_HDFS_CPU=$FIO_HDFS_CPU"
>> FIO_HDFS_CPU=
>> #   echo "JAVA_HOME=$JAVA_HOME"
>> JAVA_HOME=/opt/jdk
>> #echo "FIO_LIBHDFS_INCLUDE=$FIO_LIBHDFS_INCLUDE"
>> FIO_LIBHDFS_INCLUDE=
>> #   echo "FIO_LIBHDFS_LIB=$FIO_LIBHDFS_LIB"
>> FIO_LIBHDFS_LIB=
>> 
>> 
>> 
>> 
>> On Thu, Feb 2, 2017 at 2:32 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> Hi,
>>> 
>>> A look through https://github.com/axboe/fio/blob/master/configure
>>> suggests for things related to HDFS suggests the following:
>>> * Have you made sure the environment variables JAVA_HOME ,
>>> FIO_LIBHDFS_INCLUDE , FIO_LIBHDFS_LIB are set correctly before running
>>> configure?
>>> * Have you added the --enable-libhdfs ./configure parameter?
>>> 
>>> On 2 February 2017 at 22:22, ankit patel <ankitpatel.edu@gmail.com> wrote:
>>>> Hello All
>>>> 
>>>> I am trying to install FIO on my hadoop cluster and I aimed to measure
>>>> storage BW and latency through HDFS
>>>> https://github.com/axboe/fio/issues/301
>>>> 
>>>> while doing ./configure step i see
>>>> "HDFS engine                   no"
>>>> 
>>>> followed by an error when I tried to use libhdfs with fio;
>>>> ./fio --name=random-writers --ioengine=libhdfs --iodepth=4
>>>> --rw=randwrite --bs=32k --direct=0 --size=64m --numjobs=4
>>>> fio: engine libhdfs not loadable
>>>> fio: failed to load engine libhdfs
>>>> fio: file:ioengines.c:91, func=dlopen, error=libhdfs: cannot open
>>>> shared object file: No such file or directory
>>>> 
>>>> can you help me with how can i enable fio vi hdfs
>>> 
>>> --
>>> Sitsofe | http://sucs.org/~sits/
>> 
>> 
>> 
>> --
>> Thanks,
>> Ankit Patel
> 
> 
> 
> -- 
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

