Return-Path: <fio-owner@vger.kernel.org>
Received: from web161913.mail.bf1.yahoo.com ([98.139.211.221]:29021 "HELO
	web161913.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756055Ab1BQCVb (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 16 Feb 2011 21:21:31 -0500
Message-ID: <932143.86482.qm@web161913.mail.bf1.yahoo.com>
Date: Wed, 16 Feb 2011 18:14:50 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: uneven IOPS among HD
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have a couple of questions:

1) if it is normal (and if so, why) that while running a number of identical jobs (e.g 4), each bound to a different CPU (cpu_allowed=i) and each performing sequential (bs=512) reads on (e.g. 4) different HD, fio reports IOPS numbers that are highly unbalanced among HD with one HD reporting more than 7x of the IOPS of the minimum IOPS HD.
Different runs may show most of the IOPS on a different HD, so it's not that one HD is faster.

Here are some possibly interesting parameters:

ioengine=libaio
iodepth=32
direct=1

2) why increasing "iodepth' (eg to 512) decreses the IOPS results significantly (by 10x)?

thanks,
John  


      
