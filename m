Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:15854 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2IBOuP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 2 Sep 2012 10:50:15 -0400
Received: from vmwexceht03-prd.hq.netapp.com (vmwexceht03-prd.hq.netapp.com [10.106.76.241])
	by smtp1.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id q82EoF9K016001
	for <fio@vger.kernel.org>; Sun, 2 Sep 2012 07:50:15 -0700 (PDT)
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Using fio to mimicking Oracle workload pattern
Date: Sun, 2 Sep 2012 14:50:06 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240D6A24B4@SACEXCMBX02-PRD.hq.netapp.com>
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


I want to simulate some Oracle workload pattern using fio. I would like to do the following:


Archive LOGS: I would like to create x number of different file sizes. I have tried the following, but I am not sure if this is right about filesize option.

directory=/archive
size=10g
ioengine=libaio
nrfiles=5
iodepth=4
rw=write
filesize=500m
direct=1
threads=4
numjobs=1

Redo LOGS:  I have tried the following: sync I/O and block split (to simulate partial writes) - 60% 512 bytes and 40% 4096.

directory=/redo
size=1g
ioengine=libaio
nrfiles=5
iodepth=4
sync=1
rw=write
filesize=500m
bssplit=512/60:4k/40
direct=1
numjobs=1

FULL Table Scan: I have tried creating 3 files and read from them (randomly). I used ba=4096 to have block aligned and 1MB of block size (to simulate db_scattered_read). 

[tablescan]
directory=/u109/oradata/fio
nrfiles=3
openfiles=3
file_service_type=roundrobin
size=1g
iodepth=32
ba=4k
bs=1M
rw=randread
numjobs=2


Could you please help to check if the above files are correct? If they are, how can I double check if everything is working as expected (on fio output)?

Thank you very much

neto