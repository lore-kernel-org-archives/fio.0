Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:7903 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab3BDWmI convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 4 Feb 2013 17:42:08 -0500
Received: from vmwexceht05-prd.hq.netapp.com (vmwexceht05-prd.hq.netapp.com [10.106.77.35])
	by smtp1.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id r14Mg7d8005881
	for <fio@vger.kernel.org>; Mon, 4 Feb 2013 14:42:07 -0800 (PST)
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Simulating Real Random I/O with FIO
Date: Mon, 4 Feb 2013 22:42:06 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6E5583@SACEXCMBX02-PRD.hq.netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

I am doing a performance POC and I need to simulate 100% true random workload. I am using Fibre Channel and Windows 2008R2.

I have 8 LUNs (125GB each) and my configuration file is:

[workload]
bs=8k
ioengine=windowsaio
iodepth=3
numjobs=35
direct=1
runtime=120
size=1024g
filename=\\.\PhysicalDrive1
filename=\\.\PhysicalDrive2
filename=\\.\PhysicalDrive3
filename=\\.\PhysicalDrive4
filename=\\.\PhysicalDrive5
filename=\\.\PhysicalDrive6
filename=\\.\PhysicalDrive7
filename=\\.\PhysicalDrive8
zonesize=1024m
zoneskip=3g
rw=randrw
rwmixread=80
rwmixwrite=20
thread
unified_rw_reporting=1
group_reporting=1
randrepeat=0
norandommap

Questions:

1) I am assuming the working set is the size parameter that is 1TB. Is that correct?
2) What is the correlaction of the zonesize and zoneskip with the randomness? Adding those will help with the randomness of the workload or not? 
3) If I use zonesize=1024m and zoneskip=3g I have like 100K IOPS (coming from cache not disks) and if I use zonesize=10g and zoneskip=26g I have more realistic numbers. Could someone explain which is the a good example to use zonesize and zoneskip?
4) Is it possible with fio to specify per disk randomness area: For example: disk1 - start blocks 456 till blocks 3456, disk2 - start blocks 4567 to 103456

Thank you very much

All the best

neto


