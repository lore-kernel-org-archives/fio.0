Return-Path: <fio-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbbBTXKt convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 20 Feb 2015 18:10:49 -0500
From: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>
Subject: REPORT: High CPU utilization since 2.2.5
Date: Fri, 20 Feb 2015 23:10:43 +0000
Message-ID: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"
Content-ID: <DB185304FDE96E47A3F7B9D041F242F1@intel.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,
I=EF=BF=BDm running NVMe SSD benchmarks which are using multi-job configura=
tions in the most common scenarios.
I have noticed that since 2.2.5 release FIO has 3-4 times higher CPU utiliz=
ation on the same workload, same system, same kernel 3.18.
In fact I=EF=BF=BDm not able to achieve 450k IOPS on latest Core-i7 CPU due=
 to 100% utilization.
I tracked down the changes back, 2.1.14 is the most stable for me. Release =
had 2.2.0 the reporting issues, which were fixed in 2.2.5 but introduced hi=
gh CPU utilization instead.
Did anyone notice that too?

Configuration details are bellow:

[global]
name=3D4k random read 4 ios in the queue in 32 queues
filename=3D/dev/nvme0n1
ioengine=3Dlibaio
direct=3D1
bs=3D4k
rw=3Drandread
iodepth=3D4
numjobs=3D32
buffered=3D0
size=3D100%
runtime=3D0
randrepeat=3D0
norandommap
refill_buffers
[job1]


--
Andrey Kudryavtsev,
SSD Solution Architect
Intel Corp.
inet: 83564353
work: +1-916-356-4353
mobile: +1-916-221-2281
