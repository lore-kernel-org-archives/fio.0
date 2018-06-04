Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:32798 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFDSgG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Jun 2018 14:36:06 -0400
Received: by mail-ot0-f173.google.com with SMTP id h6-v6so19864326otj.0
        for <fio@vger.kernel.org>; Mon, 04 Jun 2018 11:36:06 -0700 (PDT)
MIME-Version: 1.0
From: learn pvt <learnpvt2050@gmail.com>
Date: Tue, 5 Jun 2018 00:06:05 +0530
Message-ID: <CACQ+FiWZyzRuOUcu1B+Wc2bvQmGtvCRfsroU+rrzm=r2wbr9tw@mail.gmail.com>
Subject: fio libhdfs - loadFileSystems error while running FIO in CDH5.14.0
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am trying to configure the 'libhdfs' in my CHD5.14.0 cluster but
getting some issues.

I have two node CDH-cluster and its working fine as I checked with TestDFSIO.
I set the FIO_LIBHDFS_INCLUDE, FIO_LIBHDFS_LIB, 'hadoop classpath' in
environment.

Installed FIO on Master and configured it with enabling libhdfs while
'configure'.

Created hdfs.fio file as
[global]
runtime=10
[hdfs]
rw=read
namenode=xx.xx.x.xxx
hostname=server1
port=9000
hdfsdirectory=/tmp
chunk_size=1m
hdfs_use_direct=1
ioengine=libhdfs
size=20m
bs=256k
single_instance=1

Ran the fio job(sudo fio hdfs.fio) which resulted into errors as

fio-3.6-33-g540e
Starting 1 process
loadFileSystems error
hdfsBuilderConnect forceNewInstance=0, nn=server1, port=9000,
kerbTicketCachePath=(NULL), userName=(NULL) error
hdfsExists: constructNewObjectOfPath error
hdfs: invalid working directory /tmp: Unknown error 255
fio: failed to init engine data: 255
Run status group 0 (all jobs)

I tried many things but could not configure libhdfs to work correctly
with FIO on my CDH.  Any suggestion would be appreciated!
Thanks in advance.
Note: /tmp directory is present at the hdfs level.

Thanks,
LP
