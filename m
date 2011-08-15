Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33610 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1HOG7m (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Aug 2011 02:59:42 -0400
Message-ID: <4E48C3D9.4020000@fusionio.com>
Date: Mon, 15 Aug 2011 08:59:37 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] stats: Add a function to report completion latency percentiles
References: <1313175153-5355-1-git-send-email-yjhong@google.com> <4E45AF96.4070606@kernel.dk> <CAC8teKW=oXw5LSsH_4rVdOtCkunoSEDo-jS_FUbVgFgjnrzzjw@mail.gmail.com> <4E48C2C1.60307@kernel.dk>
In-Reply-To: <4E48C2C1.60307@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Yu-ju Hong <yjhong@google.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-Ju Hong <yuju.hong@gmail.com>

On 2011-08-15 08:54, Jens Axboe wrote:
> On 2011-08-15 05:56, Zhu Yanhai wrote:
>> Hi,
>> This commit breaks the calculation of iops.
>> Before this commit, the iops from group_report is 1467, see below:
>>
>> chenyun@test023057.sqa.cm4 fio]$ sudo ./fio ~/iotest/readdev
>> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> ...
>> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> fio 1.57
>> Starting 10 threads
>> Jobs: 10 (f=10): [rrrrrrrrrr] [100.0% done] [5929K/0K /s] [1447 /0
>> iops] [eta 00m:00s]
>> thread16: (groupid=0, jobs=10): err= 0: pid=19538
>>   read : io=176212KB, bw=5871.6KB/s, iops=1467 , runt= 30011msec
>> [cut here]
>>
>>
>> After this commit, the reported iops is 266, which is only one thread's output,
>> not group_reporting, see below:
>>
>> [chenyun@test023057.sqa.cm4 fio]$ sudo ./fio ~/iotest/readdev
>> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> ...
>> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>> fio 1.57
>> Starting 10 threads
>> Jobs: 10 (f=10): [rrrrrrrrrr] [100.0% done] [6033K/0K /s] [1473 /0
>> iops] [eta 00m:00s]
>> thread16: (groupid=0, jobs=10): err= 0: pid=19692
>>   read : io=351720KB, bw=1065.7KB/s, iops=266 , runt=330046msec
>> [cut here]
> 
> The patch does indeed appear to have broken output for more than 1
> thread in general, even without group_reporting things are not right. It
> also crashes here for me now:

Zhu, does this work for you?

diff --git a/fio.h b/fio.h
index 6766351..c741162 100644
--- a/fio.h
+++ b/fio.h
@@ -217,7 +217,7 @@ struct thread_stat {
 	unsigned int io_u_complete[FIO_IO_U_MAP_NR];
 	unsigned int io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	unsigned int io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	unsigned int io_u_plat [2][FIO_IO_U_PLAT_NR];
+	unsigned int io_u_plat[3][FIO_IO_U_PLAT_NR];
 	unsigned long total_io_u[3];
 	unsigned long short_io_u[3];
 	unsigned long total_submit;

-- 
Jens Axboe

