Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:58406 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GTKah convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 20 Jul 2012 06:30:37 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id B7B40DF757
	for <fio@vger.kernel.org>; Fri, 20 Jul 2012 12:30:35 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (hercules.tks.local [192.168.110.28])
	by iris.tks.local (Postfix) with ESMTP id 5BB36405D8
	for <fio@vger.kernel.org>; Fri, 20 Jul 2012 12:30:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 391666FC147
	for <fio@vger.kernel.org>; Fri, 20 Jul 2012 12:30:35 +0200 (CEST)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lj9E10+ntDRt for <fio@vger.kernel.org>;
	Fri, 20 Jul 2012 12:30:32 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [127.0.1.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id DE2B46FC146
	for <fio@vger.kernel.org>; Fri, 20 Jul 2012 12:30:32 +0200 (CEST)
Date: Fri, 20 Jul 2012 12:30:32 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <1375946309.2166899.1342780232840.JavaMail.root@thomas-krenn.com>
In-Reply-To: <5006F8E4.7090806@thomas-krenn.com>
Subject: Re: Problem using --offset: fix call to fadvise64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have now figured out the problem:
when testing with a whole partition "/dev/sdb1" and specifying an offset you have also to
specify a size via "--size". I thought that if I am using an offset with a partition Fio would carry out the test starting at the offset until the end of the partition. But this is not the case, you have to explicitly give the rest of partition's size starting from the offset.
This was my fault, Fio is doing everything correctly.

-Georg 

----- Ursprüngliche Mail -----
Von: "Georg Schönberger" <gschoenberger@thomas-krenn.com>
An: fio@vger.kernel.org
Gesendet: Mittwoch, 18. Juli 2012 19:56:52
Betreff: Problem using --offset: fix call to fadvise64



Hello everybody, 

I don't know if it is a bug but my usage of the offset parameter seems 
not to work correctly. In detail the offset call works, but at a certain 
size the call to "fadvise64" is no longer correct: 
Here is the working offset: 
# strace -o fio.out.working -f fio --rw=read --name=usb-stick --bs=1024k 
--direct=1 --filename=/dev/sdb1 --runtime=10 --time_based --offset=1024 
usb-stick: (g=0): rw=read, bs=1M-1M/1M-1M, ioengine=sync, iodepth=1 
fio-2.0.8-2-gd3987 
Starting 1 process 
Jobs: 1 (f=1): [R] [100.0% done] [19320K/0K /s] [18 /0 iops] [eta 00m:00s] 
usb-stick: (groupid=0, jobs=1): err= 0: pid=20570 
read : io=195584KB, bw=19492KB/s, iops=19 , runt= 10034msec 
[...] 
# grep fadvise fio.out.working 
20570 fadvise64(3, 1024, 20970496, POSIX_FADV_SEQUENTIAL) = 0 

With an offset more than half of the device, the overall device size is 
no longer correct (should be 20970496 again): 
# strace -o fio.out -f fio --rw=read --name=usb-stick --bs=1024k 
--direct=1 --filename=/dev/sdb1 --runtime=10 --time_based --offset=10485760 
usb-stick: (g=0): rw=read, bs=1M-1M/1M-1M, ioengine=sync, iodepth=1 
fio-2.0.8-2-gd3987 
Starting 1 process 
Run status group 0 (all jobs): 
Disk stats (read/write): 
sdb: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00% 
# grep fadvise fio.out 
20848 fadvise64(3, 10485760, 10485760, POSIX_FADV_SEQUENTIAL) = 0 

As the call to fadvise64 is not correct (instead of 10485760 as the 3rd 
parameter there should be 20970496) the job does not start. 
I am using the latest fio version: 
# fio --version 
fio-2.0.8-9-gfb9f0 

-Georg 
-- 
To unsubscribe from this list: send the line "unsubscribe fio" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at http://vger.kernel.org/majordomo-info.html 
