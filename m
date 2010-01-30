Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:49468 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0A3EzN (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 29 Jan 2010 23:55:13 -0500
Received: by pxi12 with SMTP id 12so2309898pxi.33
        for <fio@vger.kernel.org>; Fri, 29 Jan 2010 20:55:11 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 21:55:11 -0700
Message-ID: <f3177b9e1001292055v5a1ba090ne0e7e1c78db2b819@mail.gmail.com>
Subject: Is --rwmixread not interpreted correctly from the command line?
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

What am I doing wrong in this incantation?

I was under the impression that everything preceding the first
"--name" was like a "globals" section in a command file, yet, no
matter what number follows "--rwmixread" in the following incantation,
it allways does a 50/50 mix:

fio  --rw=randrw --bs=8k --rwmixread=0 --iodepth=256
--output=/tmp/fio.out.txt --group_reporting --sync=0 --direct=1
--randrepeat=0 --softrandommap=1 --ioengine=libaio --loops=10000
--runtime=60 \
  --name=test0 --filename=/dev/sda --numjobs=2 --size=16091503001 \
  --name=test1 --filename=/dev/sdb --numjobs=2 --size=16091503001 \
  --name=test2 --filename=/dev/sdc --numjobs=2 --size=16091503001 \
  --name=test3 --filename=/dev/sdd --numjobs=2 --size=16091503001 \
  --name=test4 --filename=/dev/sde --numjobs=2 --size=16091503001 \
  --name=test5 --filename=/dev/sdf --numjobs=2 --size=16091503001 \
  --name=test6 --filename=/dev/sdg --numjobs=2 --size=16091503001 \
  --name=test7 --filename=/dev/sdh --numjobs=2 --size=16091503001

How do I get the --rwmixread to work up-front?

Thanks,

Chris
