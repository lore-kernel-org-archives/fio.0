Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.248.92.41] ([195.248.92.41]:48163 "EHLO mx2.itsystems.ch"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbbCLOdc convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 12 Mar 2015 10:33:32 -0400
Received: from [10.128.10.60] (port=22274 helo=keskonrix.itsystems.ch)
	by mx2.itsystems.ch with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <urs.schaltegger@itsystems.ch>)
	id 1YW4AO-0005Mf-1K
	for fio@vger.kernel.org; Thu, 12 Mar 2015 15:32:52 +0100
From: Urs Schaltegger <urs.schaltegger@itsystems.ch>
Subject: fio always writes null bytes whatever I do
Date: Thu, 12 Mar 2015 14:32:51 +0000
Message-ID: <4471f819ae264ec8bcb6bb1684effd53@keskonrix.itsystems.ch>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

fio always writes null bytes whatever I do. I need random data to avoid interference of deduplication solutions (within SSDs or using ZFS).

Windows 8.1 Enterprise x64

fio-2.2.6 (also tried 2.2.0/2.2.1/2.2.3)

fio --section=fiorandom --runtime=60 <FIOFile>

<FIOFile>:

[global]
ioengine=windowsaio
thread
group_reporting
time_based
clocksource=clock_gettime
direct=1
refill_buffers
size=1g
[fiorandom]
readwrite=randwrite
numjobs=4
iodepth=1
blocksize=8k
directory=D\:\


