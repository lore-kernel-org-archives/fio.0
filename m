Return-Path: <fio-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbaHEFJP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 5 Aug 2014 01:09:15 -0400
From: "Zhu, Zhengyun" <zhengyun.zhu@intel.com>
Subject: bug report
Date: Tue, 5 Aug 2014 05:08:52 +0000
Message-ID: <9E8FC62FFD81D74BA20610CD2B890B843DF4F8@SHSMSX101.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


Hi,

When I am using fio to do some tests, I find a problem.

I am using a client with a 10Gb NIC to do the test case of sequential read,=
 and the configuration file is below:

//version 2.0.8
global]
iodepth=3D256
runtime=3D600
ioengine=3Dlibaio
direct=3D1
size=3D30g
filename=3D/dev/vdb
ramp_time=3D10

[seq-read-64k]
rw=3Dread
bs=3D64k
iodepth_batch_submit=3D8
iodepth_batch_complete=3D8


we know the bandwidth can reach nearly 1100MB/s without the parameter of ra=
te. It will finish fio in about 30 seconds, because the size is 30g.

first, when I set ramp_time to 10, the fio result is below:

seq-read-64k: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D26840
=EF=BF=BD read : io=3D20016MB, bw=3D1105.8MB/s, iops=3D17677 , runt=3D 1810=
2msec

second, when I set ramp_time to 35, the fio result is below:

seq-read-64k: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D26861
=EF=BF=BD read : io=3D30720MB, bw=3D1102.3MB/s, iops=3D17636 , runt=3D 2787=
0msec

According to these, we can summary:

1. When we set ramp_time less than the time of fio finish read(we call it f=
ftime for short), then
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Runt =3D fftime - ramptime
2. When we set ramp_time greater than the time of fio finish read(we call i=
t fftime for short), then
=EF=BF=BD Runt =3D fftime
My requirement is:
=EF=BF=BD I want to use ramp time to warm up 50 seconds, and then collect i=
ostat data, but fio has finished after 30 seconds, so I will collect all em=
pty data.

Could we not calculate time and io size during ramp time in runt time, or d=
o I have some mistakes to understand it?
