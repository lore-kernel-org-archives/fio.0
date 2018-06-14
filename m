Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:36348 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754616AbeFNRib (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 14 Jun 2018 13:38:31 -0400
Received: by mail-ot0-f171.google.com with SMTP id c15-v6so8036209otl.3
        for <fio@vger.kernel.org>; Thu, 14 Jun 2018 10:38:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgkxrdVVZJX8H0Jzk_HdMmVem5Ju61sM6xHLkK4o8px+A@mail.gmail.com>
References: <CACQ+FiWZyzRuOUcu1B+Wc2bvQmGtvCRfsroU+rrzm=r2wbr9tw@mail.gmail.com>
 <CALjAwxgkxrdVVZJX8H0Jzk_HdMmVem5Ju61sM6xHLkK4o8px+A@mail.gmail.com>
From: learn pvt <learnpvt2050@gmail.com>
Date: Thu, 14 Jun 2018 23:08:30 +0530
Message-ID: <CACQ+FiWTF3gMKDRhWMCNvyBj0Wc0cF0G2DJkcYnCeykWSCR02Q@mail.gmail.com>
Subject: Re: fio libhdfs - loadFileSystems error while running FIO in CDH5.14.0
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Fabrice Bacchella <fbacchella@spamcop.net>, Manish Mandlik <manishm@fb.com>, fio <fio@vger.kernel.org>

Hi All,

I am getting same errors while running fio using libhdfs on
open-source hadoop-2.6.0.

I also installed the 'hadoop-2.6.0-src' package and built it using the
Maven (mvn compile)

After compiling, I got the following executables created under
/hadoop/sources/hadoop-2.6.0-src/hadoop-hdfs-project/hadoop-hdfs/target/native/:
test_libhdfs_ops   test_libhdfs_threaded   test_libhdfs_write
test_native_mini_dfs   test_libhdfs_read   test_libhdfs_vecsum
test_libhdfs_zerocopy

Using these binaries I was able to write/read files in my hadoop-cluster.
/usr/local/hadoop/sources/hadoop-2.6.0-src/hadoop-hdfs-project/hadoop-hdfs/target/native$./test_libhdfs_write
test-file 100M 10M

But if I try to run FIO using 'ioengine=libhdfs' then it fails with
the same errors mentioned in earlier email.

As executables are able to utilize the 'libhdfs.so' correctly, it
seems like FIO is not utilizing it as it should.

I have configured the classpaths and other required settings as
mentioned in earlier email.

Please let me know if some additional configurations are required to
run FIO using libhdfs engine.

Thanks,
LP

On Tue, Jun 5, 2018 at 1:09 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> CC'ing Fabrice and Manish...
>
> On 4 June 2018 at 19:36, learn pvt <learnpvt2050@gmail.com> wrote:
>> Hi,
>>
>> I am trying to configure the 'libhdfs' in my CHD5.14.0 cluster but
>> getting some issues.
>>
>> I have two node CDH-cluster and its working fine as I checked with TestDFSIO.
>> I set the FIO_LIBHDFS_INCLUDE, FIO_LIBHDFS_LIB, 'hadoop classpath' in
>> environment.
>>
>> Installed FIO on Master and configured it with enabling libhdfs while
>> 'configure'.
>>
>> Created hdfs.fio file as
>> [global]
>> runtime=10
>> [hdfs]
>> rw=read
>> namenode=xx.xx.x.xxx
>> hostname=server1
>> port=9000
>> hdfsdirectory=/tmp
>> chunk_size=1m
>> hdfs_use_direct=1
>> ioengine=libhdfs
>> size=20m
>> bs=256k
>> single_instance=1
>>
>> Ran the fio job(sudo fio hdfs.fio) which resulted into errors as
>>
>> fio-3.6-33-g540e
>> Starting 1 process
>> loadFileSystems error
>> hdfsBuilderConnect forceNewInstance=0, nn=server1, port=9000,
>> kerbTicketCachePath=(NULL), userName=(NULL) error
>> hdfsExists: constructNewObjectOfPath error
>> hdfs: invalid working directory /tmp: Unknown error 255
>> fio: failed to init engine data: 255
>> Run status group 0 (all jobs)
>>
>> I tried many things but could not configure libhdfs to work correctly
>> with FIO on my CDH.  Any suggestion would be appreciated!
>> Thanks in advance.
>> Note: /tmp directory is present at the hdfs level.
>>
>> Thanks,
>> LP
>
> --
> Sitsofe | http://sucs.org/~sits/
