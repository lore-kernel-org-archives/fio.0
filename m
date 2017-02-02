Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:32930 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdBBWWe (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Feb 2017 17:22:34 -0500
Received: by mail-ua0-f173.google.com with SMTP id i68so1432732uad.0
        for <fio@vger.kernel.org>; Thu, 02 Feb 2017 14:22:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADMvz73UANC74K=owpoLDpYae8=fs_UkJ6DSAvO8jGttRc+mgQ@mail.gmail.com>
References: <CADMvz72k8xgfw9uR=-2GbDqcrGV6OPOQZ6EFHEGTf4ydzNvYTw@mail.gmail.com>
 <CADMvz73UANC74K=owpoLDpYae8=fs_UkJ6DSAvO8jGttRc+mgQ@mail.gmail.com>
From: ankit patel <ankitpatel.edu@gmail.com>
Date: Thu, 2 Feb 2017 14:22:02 -0800
Message-ID: <CADMvz73wESUZh_0ZVAK-m28GAsjhA2ss_Tixr=fMVmHzMNsMUA@mail.gmail.com>
Subject: Fwd: fio over hdfs
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello All

I am trying to install FIO on my hadoop cluster and I aimed to measure
storage BW and latency through HDFS
https://github.com/axboe/fio/issues/301

while doing ./configure step i see
 "HDFS engine                   no"

followed by an error when I tried to use libhdfs with fio;
./fio --name=random-writers --ioengine=libhdfs --iodepth=4
--rw=randwrite --bs=32k --direct=0 --size=64m --numjobs=4
fio: engine libhdfs not loadable
fio: failed to load engine libhdfs
fio: file:ioengines.c:91, func=dlopen, error=libhdfs: cannot open
shared object file: No such file or directory

can you help me with how can i enable fio vi hdfs

--
Ankit Patel
