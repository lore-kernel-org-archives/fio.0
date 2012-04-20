Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41010 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2DTR1Z (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 13:27:25 -0400
Received: by vcqp1 with SMTP id p1so6555265vcq.19
        for <fio@vger.kernel.org>; Fri, 20 Apr 2012 10:27:24 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Apr 2012 10:27:24 -0700
Message-ID: <CAKa9NmuEcJu7U+M8s4O2C0QPHzpMQE9a0zctfcahP=Q-qq9UCA@mail.gmail.com>
Subject: fio causing kernel panic due to zero size requests
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

Recently we saw an issue where fio created kernel panic because of 0
size requests.
Pasting the stack trace below.

<d>Pid: 13846, comm: fio Tainted: P M 2.6.38.4-
<d>RIP: 0010:[<ffffffff8111d90d>] [<ffffffff8111d90d>]
__blockdev_direct_IO+0x6a7/0x9ce
<d>RSP: 0018:ffff8823fb7e9c18 EFLAGS: 00010246
<d>RAX: 0000000000000000 RBX: ffffea007d55d460 RCX: 000000000000000a
<d>RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff8812342b80e0
<d>RBP: ffff8823fb7e9cd8 R08: 0000000000000001 R09: 0000000000000000
<d>R10: 0000000000000000 R11: ffffea0000000000 R12: ffff881233d64400
<d>R13: 0000000000000003 R14: ffff881233d64498 R15: ffff8812342b80e0
<d>FS: 00007f048cddb6e0(0000) GS:ffff88007e200000(0000) knlGS:0000000000000000
<d>CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<d>CR2: 000000000040d040 CR3: 000000238ea69000 CR4: 00000000000406f0
<d>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<d>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fio (pid: 13846, threadinfo ffff8823fb7e8000, task ffff882432ead120)
<0>Stack:
<c> ffff8823fb7e9c68<c> ffffffff814478ce<c> ffff882300000001<c>
ffff8823cf614000<c>
<c> ffff882300000004<c> ffffffff814478ce<c> fffffffffffffc00<c>
00000000814478ce<c>
<c> ffff8823fb7e8000<c> 0000000000000400<c> 0000000a00000001<c>
ffff8823fb7e8000<c>

Checking that function it's

0xffffffff8111d90d is in __blockdev_direct_IO (fs/direct-io.c:955).

and that points to following line in direct-io.c:

 955             BUG_ON(this_chunk_bytes == 0);

We also tested with following patch from kernel.org

f9b5570 fs: simplify handling of zero sized reads in __blockdev_direct_IO

That resolved the panic problem.

Can you please add check to fio that it should error out OR skip 0
size accesses ?

Thanks,

Vikram.
