Return-Path: <fio-owner@vger.kernel.org>
Received: from larry.its.auckland.ac.nz ([130.216.12.34]:41330 "EHLO
	mailhost.auckland.ac.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260Ab0BOKrl (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Feb 2010 05:47:41 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mailhost.auckland.ac.nz (Postfix) with ESMTP id 3AEDB1A8AE
	for <fio@vger.kernel.org>; Mon, 15 Feb 2010 23:47:33 +1300 (NZDT)
Received: from mailhost.auckland.ac.nz ([127.0.0.1])
	by localhost (larry.its.auckland.ac.nz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4qdb-at3STKO for <fio@vger.kernel.org>;
	Mon, 15 Feb 2010 23:47:33 +1300 (NZDT)
Received: from [130.216.7.13] (vpn13.net.auckland.ac.nz [130.216.7.13])
	by mailhost.auckland.ac.nz (Postfix) with ESMTP id 88D3F1A8AC
	for <fio@vger.kernel.org>; Mon, 15 Feb 2010 23:47:32 +1300 (NZDT)
Message-ID: <4B792645.8020109@auckland.ac.nz>
Date: Mon, 15 Feb 2010 23:47:33 +1300
From: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>
MIME-Version: 1.0
Subject: fio doesn't seem to generate IO
References: <4B72792C.5030709@auckland.ac.nz>
In-Reply-To: <4B72792C.5030709@auckland.ac.nz>
Content-Type: multipart/mixed;
 boundary="------------070509040906010007040100"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------070509040906010007040100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi everyone,

I am having a problem using iolog files to generate I/O. The attached 
test_fio file and spc_bsu0_str3 iolog files should run together to 
generate 6 reads and 10 writes on /mnt/xphost/asu1. Fio runs via

fio test_fio

and generates the following output that looks good

stream0: (groupid=0, jobs=1): err= 0: pid=19187
  read : io=24,576B, bw=18,745B/s, iops=4, runt=  1311msec
    clat (usec): min=35, max=564, avg=125.17, stdev=214.99
    bw (KB/s) : min=   12, max=   31, per=119.44%, avg=21.50, stdev=13.44
  write: io=40,960B, bw=31,243B/s, iops=7, runt=  1311msec
    clat (usec): min=25, max=72, avg=49.00, stdev=12.35
    bw (KB/s) : min=   25, max=   25, per=83.33%, avg=25.00, stdev= 0.00
  cpu          : usr=0.00%, sys=0.31%, ctx=27, majf=0, minf=22
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
     issued r/w: total=6/10, short=0/0
     lat (usec): 50=62.50%, 100=31.25%, 750=6.25%


Run status group 0 (all jobs):
   READ: io=24KB, aggrb=18KB/s, minb=18KB/s, maxb=18KB/s, mint=1311msec, 
maxt=1311msec
  WRITE: io=40KB, aggrb=30KB/s, minb=31KB/s, maxb=31KB/s, mint=1311msec, 
maxt=1311msec

Also, if I use inotifywatch shows the correct number of access and 
modify (read and write) on /mnt/xphost/asu1. However, iotop shows that 
only 8KB of reads and 8KB of writes have been performed by the IO 
generating process...! I have run soe other tests and fio shows much 
better performance than expected because it is only generating a small 
fraction of the requested IO. I have been tinkering with the fio code, 
so I'm worried I broke something and would like to know what. Can anyone 
help?

Kind regards, Mike

--------------070509040906010007040100
Content-Type: text/plain;
 name="test_fio"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test_fio"

[global]
#ioengine=libaio
ioengine=sync
rw=randrw
#directory=/home/mosu001
read_iolog=spc_bsu0_str3
#refill_buffers=1
#direct=1
[stream0]

--------------070509040906010007040100
Content-Type: text/plain;
 name="spc_bsu0_str3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="spc_bsu0_str3"

fio version 2 iolog
/mnt/xphost/asu1 add
/mnt/xphost/asu2 add
/mnt/xphost/asu3 add
/mnt/xphost/asu1 open
/mnt/xphost/asu2 open
/mnt/xphost/asu3 open
Until wait 118 0
/mnt/xphost/asu1 read 187572 4096
Until wait 123 0
/mnt/xphost/asu1 write 187348 4096
Until wait 255 0
/mnt/xphost/asu1 write 187282 4096
Until wait 290 0
/mnt/xphost/asu1 read 187091 4096
Until wait 310 0
/mnt/xphost/asu1 read 187564 4096
Until wait 335 0
/mnt/xphost/asu1 write 187565 4096
Until wait 350 0
/mnt/xphost/asu1 write 187345 4096
Until wait 566 0
/mnt/xphost/asu1 write 187219 4096
Until wait 571 0
/mnt/xphost/asu1 write 187475 4096
Until wait 621 0
/mnt/xphost/asu1 read 187539 4096
Until wait 960 0
/mnt/xphost/asu1 read 187492 4096
Until wait 1218 0
/mnt/xphost/asu1 write 187164 4096
Until wait 1251 0
/mnt/xphost/asu1 read 187539 4096
Until wait 1284 0
/mnt/xphost/asu1 write 187500 4096
Until wait 1374 0
/mnt/xphost/asu1 write 187217 4096
Until wait 1422 0
/mnt/xphost/asu1 write 186252 4096
/mnt/xphost/asu1 close
/mnt/xphost/asu2 close
/mnt/xphost/asu3 close

--------------070509040906010007040100--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


