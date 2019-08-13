Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk1-f172.google.com ([209.85.222.172]:36782 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfHMNFC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Aug 2019 09:05:02 -0400
Received: by mail-qk1-f172.google.com with SMTP id d23so4737348qko.3
        for <fio@vger.kernel.org>; Tue, 13 Aug 2019 06:05:02 -0700 (PDT)
Received: from [192.168.29.187] (68-116-163-217.dhcp.oxfr.ma.charter.com. [68.116.163.217])
        by smtp.gmail.com with ESMTPSA id z187sm843146qke.99.2019.08.13.06.05.00
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 06:05:01 -0700 (PDT)
From: Michael Green <mishagreen@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: each thread writing to own dir/file
Message-Id: <26895A4F-7835-45B0-9B90-A3140AE7A1CB@gmail.com>
Date: Tue, 13 Aug 2019 09:04:59 -0400
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello collective wisdom,

I'd like to run a parallel, a hundred threads per node write job on a =
cluster of tens of nodes where each thread writes to its own dir/file, =
that is each file in its own directory. The file system is a parallel, =
shared one. Assuming the file system is mounted under  /fs_mount_point =
this is how I'd like it to look like:

host1
|- /fs_mount_point/<host1_ip>/$jobnum/$filenum (i.e.  =
/fs_mount_point/1.2.3.4/0/0)
|- /fs_mount_point/<host1_ip>/$jobnum/$filenum (i.e.  =
/fs_mount_point/1.2.3.4/1/0)
|- /fs_mount_point/<host1_ip>/$jobnum/$filenum (i.e.  =
/fs_mount_point/1.2.3.4/2/0)
...
host2
|- /fs_mount_point/<host2_ip>/$jobnum/$filenum (i.e.  =
/fs_mount_point/1.2.3.5/0/0)
|- /fs_mount_point/<host2_ip>/$jobnum/$filenum (i.e.  =
/fs_mount_point/1.2.3.5/1/0)
|- /fs_mount_point/<host2_ip>/$jobnum/$filenum (i.e.  =
/fs_mount_point/1.2.3.5/2/0)
...
and so on

I'm running fio daemon on all the client nodes and invoking jobs from =
the 1st node001 with something like=20
fio --client=3Dhost_list fio.job --section=3D<section>

the fio.job that I started with looked like this:

[global]
group_reporting
ioengine=3Dposixaio
direct=3D1
directory=3D/mnt/fio
filename_format=3D$jobnum.$filenum
# Time options
clocksource=3Dgettimeofday
runtime=3D30
time_based=3D1
ramp_time=3D5
iodepth=3D1
create_serialize=3D0
# Run jobs serially
stonewall

[lat_4k_rw]
rw=3Drandrw
rwmixread=3D0
bs=3D4k
size=3D1GB
numjobs=3D120

This job file creates all the files in the same directory with names =
like:
/mnt/fio/<host_ip1>.0.0
/mnt/fio/<host_ip1>.1.0
/mnt/fio/<host_ip1>.2.0
..
/mnt/fio/<host_ip2>.0.0
/mnt/fio/<host_ip2>.1.0
/mnt/fio/<host_ip2>.2.0
.. and so on

To achieve the desired (or close to desired) outcome, I've =
unsuccessfully  tried the following:

1. filename_format=3D$jobnum/$filenum
2. IP=3D<host_ip> fio --server --daemonize and then use ${IP} variable =
in the job file: filename_format=3D${IP}/$jobnum/$filenum but it seems =
that the variables specified in filename_format argument aren't really =
expanded on the remote daemon.

Any suggestions are welcome.

--
Michael

