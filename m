Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34773 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdBBWd3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Feb 2017 17:33:29 -0500
Received: by mail-vk0-f53.google.com with SMTP id r136so1482563vke.1
        for <fio@vger.kernel.org>; Thu, 02 Feb 2017 14:33:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADMvz73wESUZh_0ZVAK-m28GAsjhA2ss_Tixr=fMVmHzMNsMUA@mail.gmail.com>
References: <CADMvz72k8xgfw9uR=-2GbDqcrGV6OPOQZ6EFHEGTf4ydzNvYTw@mail.gmail.com>
 <CADMvz73UANC74K=owpoLDpYae8=fs_UkJ6DSAvO8jGttRc+mgQ@mail.gmail.com> <CADMvz73wESUZh_0ZVAK-m28GAsjhA2ss_Tixr=fMVmHzMNsMUA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 2 Feb 2017 22:32:48 +0000
Message-ID: <CALjAwxi+EsVgaHLozUt6VhqFPjpuPSHzw4xu0zgWEX2jQ=wWwg@mail.gmail.com>
Subject: Re: fio over hdfs
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: ankit patel <ankitpatel.edu@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

A look through https://github.com/axboe/fio/blob/master/configure
suggests for things related to HDFS suggests the following:
* Have you made sure the environment variables JAVA_HOME ,
FIO_LIBHDFS_INCLUDE , FIO_LIBHDFS_LIB are set correctly before running
configure?
* Have you added the --enable-libhdfs ./configure parameter?

On 2 February 2017 at 22:22, ankit patel <ankitpatel.edu@gmail.com> wrote:
> Hello All
>
> I am trying to install FIO on my hadoop cluster and I aimed to measure
> storage BW and latency through HDFS
> https://github.com/axboe/fio/issues/301
>
> while doing ./configure step i see
>  "HDFS engine                   no"
>
> followed by an error when I tried to use libhdfs with fio;
> ./fio --name=random-writers --ioengine=libhdfs --iodepth=4
> --rw=randwrite --bs=32k --direct=0 --size=64m --numjobs=4
> fio: engine libhdfs not loadable
> fio: failed to load engine libhdfs
> fio: file:ioengines.c:91, func=dlopen, error=libhdfs: cannot open
> shared object file: No such file or directory
>
> can you help me with how can i enable fio vi hdfs

-- 
Sitsofe | http://sucs.org/~sits/
