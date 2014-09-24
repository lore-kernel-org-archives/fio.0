Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53285 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaIXBCc (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Sep 2014 21:02:32 -0400
Received: by mail-vc0-f173.google.com with SMTP id le20so6081257vcb.4
        for <fio@vger.kernel.org>; Tue, 23 Sep 2014 18:02:32 -0700 (PDT)
MIME-Version: 1.0
From: Akash Verma <akashv@google.com>
Date: Tue, 23 Sep 2014 18:02:12 -0700
Message-ID: <CAFFT=UkPhmUHD0EAH1_KDviB9909=NwqNSeCXWiOz=0Fp6phhA@mail.gmail.com>
Subject: If loops= is specified, zone state is unexpectedly retained across iterations.
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Allen Schade <aschade@google.com>

I'm wondering if this is desired behavior or accidental. If I use this
control file:

[sdb-zoned-and-looped]
rw=write
bs=4k
size=24k
zonesize=12k
zonerange=512k
zoneskip=512k
ioengine=sync
direct=1
thread=1
loops=10
filename=/dev/sdb
write_iolog=sdb_iolog.txt

sdb_iolog.txt shows:
fio version 2 iolog
/dev/sdb add
/dev/sdb open
/dev/sdb write 0 4096
/dev/sdb write 4096 4096
/dev/sdb write 8192 4096
/dev/sdb write 1048576 4096
/dev/sdb write 1052672 4096
/dev/sdb write 1056768 4096
/dev/sdb close
/dev/sdb open
/dev/sdb write 1048576 4096
/dev/sdb write 1052672 4096
/dev/sdb write 1056768 4096
/dev/sdb write 2097152 4096
/dev/sdb write 2101248 4096
/dev/sdb write 2105344 4096
...

I'd expect each iteration of the loop to be identical, rather than
resuming from the zone offset of the previous iteration. Would it be
okay to change this behavior?
