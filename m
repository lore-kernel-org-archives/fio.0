Return-Path: <fio-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:50010 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZDZNo3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 26 Apr 2009 09:44:29 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1547068wfd.4
        for <fio@vger.kernel.org>; Sun, 26 Apr 2009 06:44:29 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 26 Apr 2009 07:44:29 -0600
Message-ID: <f3177b9e0904260644v578c4eb9m35c64ccf7b883479@mail.gmail.com>
Subject: What's the right way to measure latency?
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm trying to measure latency.  Is this the right incantation for "8KB
block write latency"?

fio --name=test --numjobs=1 --bs=8k --rw=randwrite --sync=0 --direct=1
--iodepth=1 --ioengine=libaio --loops=1 --size=16091503001
--filename=/dev/sdb

... I figure I can only measure latency w/ just one thread and no
outstanding I/O's.

The results show two latency numbers: clat and slat... what are these?

Thanks,

Chris
