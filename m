Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53942 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DJJEX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Apr 2012 05:04:23 -0400
Received: by vcqp1 with SMTP id p1so2365214vcq.19
        for <fio@vger.kernel.org>; Tue, 10 Apr 2012 02:04:23 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 14:34:23 +0530
Message-ID: <CAMZBPnepbgTSTfW5JA2UYZ=NxXi_==tSVeWKXF_KCYD=FTs2sQ@mail.gmail.com>
Subject: Running FIO on Windows on given partition or raw device
From: Neependra Khare <neependra.khare@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I want to run FIO on a given partition on Windows.  To do this I use
the "mountvol" command and get the volume names and
their mount points and then use them for "filename" option with FIO

For example for "E:\" get following from "mountvol" command.

    \\?\Volume{1277e70d-79a7-11e1-9fed-f04da2ef6fc9}\
        E:\

Then I run following commands:-

$ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
--iodepth=32 --blocksize=4096 --ioengine=windowsaio
--filename=\\.\Volume{1277e70d-79a7-11e1-9fed-f04da2ef6fc9}
--name=hddBaseline --stonewall

$ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
--iodepth=32 --blocksize=4096 --ioengine=windowsaio  --filename=E:\
--name=hddBaseline --stonewall

$ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
--iodepth=32 --blocksize=4096 --ioengine=windowsaio
--filename=E:\filename --name=hddBaseline --stonewall

In all these cases I do not see any IO happening on "E" drive using
"perfmon". All the IO happens on the root drive("C").

On Linux I can use "/dev/sda" , "/dev/sda1" etc.

I was expecting same on Windows.
Any help or pointers would be great.

--
Regards,
Neependra
www.neependra.net
