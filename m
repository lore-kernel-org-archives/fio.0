Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:44252 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFDTkK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Jun 2018 15:40:10 -0400
Received: by mail-ua0-f169.google.com with SMTP id f30-v6so21214095uab.11
        for <fio@vger.kernel.org>; Mon, 04 Jun 2018 12:40:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACQ+FiWZyzRuOUcu1B+Wc2bvQmGtvCRfsroU+rrzm=r2wbr9tw@mail.gmail.com>
References: <CACQ+FiWZyzRuOUcu1B+Wc2bvQmGtvCRfsroU+rrzm=r2wbr9tw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 4 Jun 2018 20:39:38 +0100
Message-ID: <CALjAwxgkxrdVVZJX8H0Jzk_HdMmVem5Ju61sM6xHLkK4o8px+A@mail.gmail.com>
Subject: Re: fio libhdfs - loadFileSystems error while running FIO in CDH5.14.0
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Fabrice Bacchella <fbacchella@spamcop.net>, Manish Mandlik <manishm@fb.com>
Cc: learn pvt <learnpvt2050@gmail.com>, fio <fio@vger.kernel.org>

CC'ing Fabrice and Manish...

On 4 June 2018 at 19:36, learn pvt <learnpvt2050@gmail.com> wrote:
> Hi,
>
> I am trying to configure the 'libhdfs' in my CHD5.14.0 cluster but
> getting some issues.
>
> I have two node CDH-cluster and its working fine as I checked with TestDFSIO.
> I set the FIO_LIBHDFS_INCLUDE, FIO_LIBHDFS_LIB, 'hadoop classpath' in
> environment.
>
> Installed FIO on Master and configured it with enabling libhdfs while
> 'configure'.
>
> Created hdfs.fio file as
> [global]
> runtime=10
> [hdfs]
> rw=read
> namenode=xx.xx.x.xxx
> hostname=server1
> port=9000
> hdfsdirectory=/tmp
> chunk_size=1m
> hdfs_use_direct=1
> ioengine=libhdfs
> size=20m
> bs=256k
> single_instance=1
>
> Ran the fio job(sudo fio hdfs.fio) which resulted into errors as
>
> fio-3.6-33-g540e
> Starting 1 process
> loadFileSystems error
> hdfsBuilderConnect forceNewInstance=0, nn=server1, port=9000,
> kerbTicketCachePath=(NULL), userName=(NULL) error
> hdfsExists: constructNewObjectOfPath error
> hdfs: invalid working directory /tmp: Unknown error 255
> fio: failed to init engine data: 255
> Run status group 0 (all jobs)
>
> I tried many things but could not configure libhdfs to work correctly
> with FIO on my CDH.  Any suggestion would be appreciated!
> Thanks in advance.
> Note: /tmp directory is present at the hdfs level.
>
> Thanks,
> LP

-- 
Sitsofe | http://sucs.org/~sits/
