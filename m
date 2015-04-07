Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34175 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbDGPlr (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Apr 2015 11:41:47 -0400
Received: by qgfi89 with SMTP id i89so22396545qgf.1
        for <fio@vger.kernel.org>; Tue, 07 Apr 2015 08:41:47 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Apr 2015 11:41:46 -0400
Message-ID: <CAGGT8x6z5vU+K=oQ3=R4s2N2xcq=aS5L+x42znaKzqxGjyE0=A@mail.gmail.com>
Subject: Latencies around 10 seconds for I/Os in a trace!!!
From: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I have made an I/O trace which includes "read", "write" and "wait" "
commands. When I replay the trace with high I/O depths (for example
32) I see around 10s (!!!!) of latency for completion of 99% of reads
and 6.5s latency for the writes. Does anyone know what exactly it
means and what is wrong here?
It is also notable that the average wait time between I/Os is around
14ms and its median is 8ms.

Here is my job file:

[global]
ioengine=libaio
direct=1
iodepth=32
log_offset=1
read_iolog=temp
write_bw_log=replay
write_lat_log=replay
write_iops_log=replay
[job]



and here is a part of my trace:

fio version 2 iolog
/dev/sdb add
/dev/sdb open
/dev/sdb wait 0 512
/dev/sdb read 52321808896 36352
/dev/sdb wait 89 512
/dev/sdb read 52478476288 131072
/dev/sdb wait 192 512
/dev/sdb read 52499185664 131072
/dev/sdb wait 208 512

Thanks in advance
