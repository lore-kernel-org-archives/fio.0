Return-Path: <fio-owner@vger.kernel.org>
Received: from web80807.mail.mud.yahoo.com ([209.191.72.111]:23932 "HELO
	web80807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751378Ab0BHWD6 (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 8 Feb 2010 17:03:58 -0500
Message-ID: <600237.15205.qm@web80807.mail.mud.yahoo.com>
Date: Mon, 8 Feb 2010 13:57:16 -0800 (PST)
From: charles zhuang <cjiazhuang@yahoo.com>
Subject: libaio ioengine cause initiator crash
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I am using fio libaio ioengine to benchmark on stgt iser target stack (http://stgt.sourceforge.net/). I found out that using bs size at 2k and under (2k, 1k, 512) keeps causing the iser initiator crash at different places. The initiator kernel stack dump at various places, with some of them has aio_* call involved. Most of the oops message looks like:
Oops: 0000 [1] SMP
last sysfs file: /block/sdb/stat
...

The easiest way I can produce this problem is after the initiator log in to iser stack, run following command from initiator (where /dev/sdb is the exported disk from target):
> fio --rw=read --bs=2k --numjobs=32 --iodepth=64 --sync=0 --direct=1 --randrepeat=0 --group_reporting --ioengine=libaio --filename=/dev/sdb --name=test --loops=100 --size=524288000 --runtime=30 --softrandommap=1

If I change "--bw=2k" to "--bs=4k" and over, it runs fine.

Initially I am only looking at the iser target (stgt) side. But now I suspect it's something to do with the initiator page coherency size, which I believe is 4k. 

Jens and other,  can you provide some insights for this? Thanks for any help.

Thanks,
Charles


      
