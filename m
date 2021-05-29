Return-Path: <fio-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22395 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhE2PEX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 29 May 2021 11:04:23 -0400
From: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Subject: Too Many Open Files
Date: Sat, 29 May 2021 15:02:41 +0000
Message-ID: <DM6PR11MB475596F3188D1B1EE8D9F54FA9219@DM6PR11MB4755.namprd11.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I have a 72-core server running CentOS 8, kernel 4.18.0-240, with FIO 3.27.=
=A0 I have 12 NVMe drives, each with 12 partitions, and am trying to run mu=
ltiple jobs for each partition, with numjobs=3D16 and iodepth=3D32.=A0 I ge=
t a too many open files error from FIO.=A0 Which is fine, that's a lot of t=
hreads.=A0 If I change numjobs to 8, same error, if I change it to 4, FIO r=
uns.  Is there a hard or dynamic limit in FIO, and if so, what is it, or ho=
w is it calculated?  Thanks!

[global]
ioengine=3Dlibaio
direct=3D1
randrepeat=3D0
thread=3D1
time_based=3D1
ramp_time=3D300
runtime=3D900
group_reporting=3D1
norandommap
iodepth=3D32
numjobs=3D4
bs=3D4k
rw=3Drandread
[job-2-1]
filename=3D/dev/nvme2n1p1
[job-2-2]
filename=3D/dev/nvme2n1p2
[job-2-3]
filename=3D/dev/nvme2n1p3
[job-2-4]
filename=3D/dev/nvme2n1p4
[job-2-5]
filename=3D/dev/nvme2n1p5
[job-2-6]
filename=3D/dev/nvme2n1p6

(goes on like that for 12 drives * 12 partitions per drive)

