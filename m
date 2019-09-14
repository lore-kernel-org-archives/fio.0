Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39806 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfINQW3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Sep 2019 12:22:29 -0400
Received: by mail-wm1-f43.google.com with SMTP id v17so5246272wml.4
        for <fio@vger.kernel.org>; Sat, 14 Sep 2019 09:22:28 -0700 (PDT)
MIME-Version: 1.0
From: Elliott Balsley <elliott@altsystems.com>
Date: Sat, 14 Sep 2019 09:22:16 -0700
Message-ID: <CABO+gV-fpuOi6u8w8-L5G+sZ7KhvPy9SC3hqXh+q6PReVTxbCA@mail.gmail.com>
Subject: Disk slows down while empting write buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am trying to figure out why end_fsync causes the overall disk write
to take longer.  I'm aware that without this option, the test may
return before all data is flushed to disk, but I am monitoring actual
disk writes with iostat.  At the beginning of the test, iostat shows
165MBps writing to each disk, and fio shows over 3000MBps (because
it's writing to the buffer, and the buffer is simultaneously going to
disk).
Near the end, fio drops to 0MBps which means it's waiting for fsync to
finish.  At this time, iostat drops to 120MBps per disk.

fio --name=w --rw=write --bs=1M --size=30G --directory=/mnt/stripe --end_fsync=1

If I instead run this command with end_fsync=0 then iostat shows
steady 165MBps the whole time.

I have observed this issue on CentOS with an mdadm soft RAID with XFS.
And also on FreeBSD with a ZFS pool.  If I instead run it on a single
disk formatted XFS then it does not use the cache at all, it just
writes steady at 165MBps, I'm not sure why that is.

I'd appreciate any insights to this.
-Elliott

