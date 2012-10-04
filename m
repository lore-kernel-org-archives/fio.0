Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36170 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2JDWcC (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Oct 2012 18:32:02 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so908068wgb.1
        for <fio@vger.kernel.org>; Thu, 04 Oct 2012 15:32:01 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Oct 2012 17:32:01 -0500
Message-ID: <CAOAYhmASWTiFvV7QR2jvJt1QBkfOxA6+B+vXWUBbQq+m7p=x-w@mail.gmail.com>
Subject: FIO 2.0.9 Windows - Job IOPS limitation
From: Keith Orsak <orsak.keith@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

OS: Windows 2008 R2 Enterprise Edition
CPU: Intel X5660 2.8GHz (6-core)
Memory: 24GB
Device Under Test: 350GB SLC PCIe 2.0 x8

I seem to be running into a Job IOPS limitation in Windows.  When I
run a deep queue (iodepth=66 for example) the IOPS seem to be pegged
out around 200K.  If I split the iodepth between two jobs I can get
around 250K IOPS with the device I am testing which is what I would
expect to see.  Here is the command that I am currently using:

 fio --filename=\\.\PHYSICALDRIVE1 --ioengine=windowsaio --direct=1
--rw=randrw --bs=4K --rwmixread=70 --iodepth=66 --randrepeat=0
--norandommap --name=test --runtime=1000000 --time_based
--group_reporting

When I ran two jobs I simply added the numjobs=2 attribute in and
reduced iodepth to 33.

This is probably more of an enhancement request than an actual issue
but having to split the queue between two jobs makes it difficult to
get datapoints on even numbered queues beyond a certain point.

-Keith
