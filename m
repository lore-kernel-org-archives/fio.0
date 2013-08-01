Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:11076 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3HAJ5t (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Aug 2013 05:57:49 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id DCFCA381AC
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 11:57:47 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id D90DE58D8844
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 11:57:47 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rbAVD5HEW2qt for <fio@vger.kernel.org>;
	Thu,  1 Aug 2013 11:57:47 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 86CC4766C61
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 11:57:47 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id o-oOpa0JnpsQ for <fio@vger.kernel.org>;
	Thu,  1 Aug 2013 11:57:47 +0200 (CEST)
Received: from localhost.localdomain (unknown [185.23.92.11])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 32AF4742011
	for <fio@vger.kernel.org>; Thu,  1 Aug 2013 11:57:47 +0200 (CEST)
Message-ID: <51FA311A.7010608@enovance.com>
Date: Thu, 01 Aug 2013 11:57:46 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: How can we report being OOM kiiled ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm currently facing a weird issue with fio 2.0.8.

I'm running the following job that is supposed to write and last at 
least 300 seconds.
It just exit almost immediately. After a short search, I saw that I got 
OOM killed.
[1732289.080181] Killed process 3175 (fio) total-vm:225292kB, 
anon-rss:131440kB, file-rss:0kB

My first though was, oh... fio did something wrong while it was just 
killed in the head. Is there any way to report that we got killed ? That 
would be very valuable to know that fio got stopped too early and result 
are incomplete.

cheers,

[global]
ioengine=libaio
invalidate=1
ramp_time=5
iodepth=32
runtime=300
time_based
direct=1

[write-vdb-4m-para]
bs=4m
stonewall
filename=/dev/vdb
rw=write
write_bw_log=vm1-1-4m-vdb-write-para.results
write_iops_log=vm1-1-4m-vdb-write-para.results


I'm used to run it but since a few, it does perform like :

[root@host] fio vm1-1-4m-parallel-write-vdb.fio
write-vdb-4m-para: (g=0): rw=write, bs=4M-4M/4M-4M, ioengine=libaio, 
iodepth=32
2.0.8
Starting 1 process
fio: pid=3147, got signal=9

write-vdb-4m-para: (groupid=0, jobs=1): err= 0: pid=3147
   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
   IO depths    : 1=2.2%, 2=4.3%, 4=8.7%, 8=17.4%, 16=34.8%, 32=32.6%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=0/w=46/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):

Disk stats (read/write):
   vdb: ios=0/376, merge=0/0, ticks=0/24204, in_queue=24204, util=33.25%
fio: file hash not empty on exit

