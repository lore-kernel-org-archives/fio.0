Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:36517 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbcGUIui (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Jul 2016 04:50:38 -0400
Received: by mail-vk0-f46.google.com with SMTP id n129so58719172vke.3
        for <fio@vger.kernel.org>; Thu, 21 Jul 2016 01:50:37 -0700 (PDT)
MIME-Version: 1.0
From: Vishrut Mehta <vishrut.mehta009@gmail.com>
Date: Thu, 21 Jul 2016 14:20:36 +0530
Message-ID: <CAFmMYWVfD5kDEHR-KtJLyUEX_n0iKAwkGq1Q-kZ=kb43Q3jb0w@mail.gmail.com>
Subject: [libhdfs][librbd][fio] Cannot benchmark readwrite mixed workload for
 lilibhdfs and librbd
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

I am using libhdfs to generate io workload. I am trying to benchmark
hdfs and ceph performance in IO workloads, But I am stuck accessing
mixed read and write workloads. I have tried running them separately
in two different jobs for hdfs as follows:
hdfs.fio

[global]
namenode=10.4.xx.xx
port=9000
hdfsdirectory=/user/hduser
ioengine=libhdfs

[hdfs-write]
chunck_size=3m
readwrite=write
filesize=9m
nrfiles=2
openfiles=1

[hdfs-read]
chunck_size=1m
readwrite=read
filesize=1m
nrfiles=1

But when I change the readwrite parameter to rw, I get hdfs error as below:
[hdfs-write]
chunck_size=3m
readwrite=rw
filesize=9m
nrfiles=2
openfiles=1

Error shown is:
Cannot write into a non-OutputStream object!

Can someone help me, how you can generate random mixed read-write
workload for both libhdfs and librbd ?

Regards,
