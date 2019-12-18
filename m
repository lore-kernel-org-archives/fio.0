Return-Path: <fio-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:37271 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbfLRTC0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Dec 2019 14:02:26 -0500
From: "Ober, Frank" <frank.ober@intel.com>
Subject: polled IO and 5.x kernels
Date: Wed, 18 Dec 2019 19:02:09 +0000
Message-ID: <SN6PR11MB266941490E6BC6FD2B3CB8028B530@SN6PR11MB2669.namprd11.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "Rajendiran, Swetha" <swetha.rajendiran@intel.com>, "Liang, Mark" <mark.liang@intel.com>, "Derrick, Jonathan" <jonathan.derrick@intel.com>, "Vyas, Satvik M" <satvik.m.vyas@intel.com>, "Knapp, Anthony J" <anthony.j.knapp@intel.com>

Hi fio community,=20
On 4.x kernels we used to be able to do:
# echo 1 > /sys/block/nvme0n1/queue/io_poll

And then run a polled_io job in fio with pvsync2 as our ioengine, with the =
hipri flag set.

On 5.x kernels we see the following error trying to write the device settin=
gs>>>
-bash: echo: write error: Invalid argument

This is verifiable on 5.3, 5.4 kernels with fio 3.16 builds.

What is the background on what has changed because Jens wrote this note bac=
k in 2015, which did work once upon a time.
But now things have changed, but none of us here in the Intel SSD group and=
 OSS Driver team really know why.

https://lwn.net/Articles/663543/

More documentation can be found here: https://stackoverflow.com/questions/5=
5223883/echo-write-error-invalid-argument-while-setting-io-poll-for-nvme-ss=
d/

Here is a good sample A / B test:
[global]
direct=3D1
filename=3D/dev/nvme1n1
log_avg_msec=3D500
time_based
percentile_list=3D1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:99.9:99.95:99.9=
9:99.999:99.9999


[rand-read-4k-qd1]
runtime=3D120
bs=3D4K
iodepth=3D1
numjobs=3D1
cpus_allowed=3D0
ioengine=3Dio_uring
hipri
rw=3Drandread
Works!

[global]
direct=3D1
filename=3D/dev/nvme1n1
log_avg_msec=3D500
time_based
percentile_list=3D1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:99.9:99.95:99.9=
9:99.999:99.9999


[rand-read-4k-qd1]
runtime=3D120
bs=3D4K
iodepth=3D1
numjobs=3D1
cpus_allowed=3D0
ioengine=3Dpvsync2
hipri
rw=3Drandread
Does not work... you do not see the CPU spin up to 100% (kernel/sys usage) =
on hipri with pvsync2 on a 5.x kernel. =20

Why not?

And what changed here?

Is it possible to get a new LWN article?
Thank you!
Frank Ober


