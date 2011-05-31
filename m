Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.fullrate.dk ([90.185.1.42]:54960 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab1EaS3J (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 May 2011 14:29:09 -0400
Received: from arvinserver1.home.troels.arvin.dk (1608ds2-ksa.0.fullrate.dk [90.184.71.151])
	by smtp.fullrate.dk (Postfix) with ESMTP id 13A579CE3E
	for <fio@vger.kernel.org>; Tue, 31 May 2011 20:22:11 +0200 (CEST)
Received: from localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 07114108122
	for <fio@vger.kernel.org>; Tue, 31 May 2011 20:22:10 +0200 (CEST)
Received: from arvinserver1.home.troels.arvin.dk ([127.0.0.1])
	by localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id y2dkRaJoZYpp for <fio@vger.kernel.org>;
	Tue, 31 May 2011 20:22:08 +0200 (CEST)
Received: from kurt-IV.home.troels.arvin.dk (kurt-IV.home.troels.arvin.dk [192.168.1.9])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 934F8108106
	for <fio@vger.kernel.org>; Tue, 31 May 2011 20:22:08 +0200 (CEST)
Message-ID: <4DE531D0.40600@arvin.dk>
Date: Tue, 31 May 2011 20:22:08 +0200
From: Troels Arvin <troels@arvin.dk>
MIME-Version: 1.0
Subject: Unaligned AIO/DIO
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

Running fio 1.55 on RHEL 6.1 x86_64 with a multipath FC storage backend 
on an EXT4 file system.

Some minutes after starting fio, I see the following in syslog:
kernel: EXT4-fs (dm-28): Unaligned AIO/DIO on inode 4063238 by fio; 
performance will be poor.

Should I be worried? Is there something wrong with my storage layout?
Or am I using fio in strange way?

My job file:

[changed-from-iometer-file-access-server]
bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
rw=randrw
rwmixread=70
direct=1
size=10g
ioengine=libaio
iodepth=256
write_bw_log
write_lat_log
numjobs=6

-- 
Regards,
Troels Arvin <troels@arvin.dk>
http://troels.arvin.dk/
