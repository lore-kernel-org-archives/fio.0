Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49855 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbaDHUEa (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Apr 2014 16:04:30 -0400
Received: by mail-bk0-f47.google.com with SMTP id w10so1172163bkz.6
        for <fio@vger.kernel.org>; Tue, 08 Apr 2014 13:04:29 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 16:04:29 -0400
Message-ID: <CAKO35LMpO7_=yGBVpLz7kd2n3YakVWOM8QzV3zWeh4F-_2yYoA@mail.gmail.com>
Subject: bug: fio only uses first file in filename
From: George Dowding <gdowding@nutanix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I've been using this command with fio-2.0.7. When I tried this with
fio-201.7 from git, it would only write to the first file in the
filename list.

./fio --filename=/dev/sdb:/dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg
--direct=1 --rw=randwrite --bs=4k --iodepth=128 --runtime=30
--group_reporting --name=file1 --ioengine=libaio

Linux perf-bench 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51
UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

It looks like this behavior changed as of bcd27f7.

Adding before and after output. If there is a different way this
should be run. I'm ok with that as I'd like to upgrade to the newer
version.

fio-68631b36e37.out
Disk stats (read/write):
  sdb: ios=83/67975, merge=0/0, ticks=104/607900, in_queue=608016, util=99.78%
  sdc: ios=83/67976, merge=0/0, ticks=96/616048, in_queue=616152, util=99.75%
  sdd: ios=74/67975, merge=0/0, ticks=76/629324, in_queue=629420, util=99.76%
  sde: ios=57/67975, merge=0/0, ticks=64/609128, in_queue=609196, util=99.76%
  sdf: ios=44/67975, merge=0/0, ticks=48/625372, in_queue=625424, util=99.74%
  sdg: ios=29/67975, merge=0/0, ticks=48/597756, in_queue=597828, util=99.77%

fio-bcd27f7ae1c.out
Disk stats (read/write):
  sdb: ios=73/151552, merge=0/106, ticks=68/3775036, in_queue=3776548,
util=99.57%
  sdc: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
  sdd: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
  sde: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
  sdf: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
  sdg: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%


Thanks,

-- 
George Dowding
Performance Engineer Nutanix
http://www.nutanix.com/
(919) 633-9669
