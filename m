Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41590 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHHHtl (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Aug 2014 03:49:41 -0400
Received: by mail-pd0-f172.google.com with SMTP id y13so694030pdi.31
        for <fio@vger.kernel.org>; Fri, 08 Aug 2014 00:49:40 -0700 (PDT)
Received: from [192.168.1.11] (c-50-184-121-221.hsd1.ca.comcast.net. [50.184.121.221])
        by mx.google.com with ESMTPSA id ib5sm2040420pbb.55.2014.08.08.00.49.39
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Aug 2014 00:49:40 -0700 (PDT)
Message-ID: <53E48112.9070800@gmail.com>
Date: Fri, 08 Aug 2014 00:49:38 -0700
From: Nicholas Krone <krone.nick@gmail.com>
MIME-Version: 1.0
Subject: Different percentages of job activity on a single drive, along with
 different i/o sizes for each drive
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm currently trying to use FIO for some drive endurance testing and I 
have a few questions that I was hoping you guys could answer.

I need to stress a drive with a split blocksize range and ensure write 
verifications. Here's a small job I drafted up:

For example, a 100GB drive to test

[global]
ioengine=noop
ioengine=libaio
iodepth=4
rw=randwrite
direct=1
bssplit=512b/4:1024b/1:1536b/1:2048b/1:2560b/1:3072b/1:3584b/1:4096b/67:8192b/10:16384b/7:32768b/3:65536b/3 

do_verify=1
verify=meta
verify_backlog=512
error_dump=1
verify_dump=1
verify_fatal=1

[50-pct-ratio]
offset=0
size=5%

[30-pct-ratio]
offset=6g
size=15%

[20-pct-ratio]
offset=21g
size=80%


0-5% - 50 PCT write access (5 GB I/O size)
6%-20% - 30 PCT write access (15 GB I/O size)
21%-100% - 20 PCT write acces (80 GB I/O size)

Will using 3 sets of size params in each job work out correctly? Also, 
If during one of the jobs, a write verification occurs, will all the 
jobs fully stop because it wouldn't make sense for any of the test to 
continue if any write errors occur.

I read about the flow counter and a way control activity between jobs 
but I'm really unclear as to how implement it and the example didn't 
really help me out.

[50-pct-ratio]
flow=-2

[30-pct-ratio]
flow=3

[20-pct-ratio]
flow=5

Am I on the right track on anything? Any help would be great.

