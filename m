Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51032 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2DTSU7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 14:20:59 -0400
Message-ID: <4F91A90A.8050901@kernel.dk>
Date: Fri, 20 Apr 2012 20:20:58 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio causing kernel panic due to zero size requests
References: <CAKa9NmuEcJu7U+M8s4O2C0QPHzpMQE9a0zctfcahP=Q-qq9UCA@mail.gmail.com> <4F91A1B8.2030901@kernel.dk> <CAKa9NmtBX_VgFL2K4nTD-0JPE3ni22y1HC2O8iU6nar6TOdzrA@mail.gmail.com>
In-Reply-To: <CAKa9NmtBX_VgFL2K4nTD-0JPE3ni22y1HC2O8iU6nar6TOdzrA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-20 20:13, Vikram Seth wrote:
> On Fri, Apr 20, 2012 at 10:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2012-04-20 19:27, Vikram Seth wrote:
>>> Hi Jens,
>>>
>>> Recently we saw an issue where fio created kernel panic because of 0
>>> size requests.
>>> Pasting the stack trace below.
>>>
>>> <d>Pid: 13846, comm: fio Tainted: P M 2.6.38.4-
>>> <d>RIP: 0010:[<ffffffff8111d90d>] [<ffffffff8111d90d>]
>>> __blockdev_direct_IO+0x6a7/0x9ce
>>> <d>RSP: 0018:ffff8823fb7e9c18 EFLAGS: 00010246
>>> <d>RAX: 0000000000000000 RBX: ffffea007d55d460 RCX: 000000000000000a
>>> <d>RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff8812342b80e0
>>> <d>RBP: ffff8823fb7e9cd8 R08: 0000000000000001 R09: 0000000000000000
>>> <d>R10: 0000000000000000 R11: ffffea0000000000 R12: ffff881233d64400
>>> <d>R13: 0000000000000003 R14: ffff881233d64498 R15: ffff8812342b80e0
>>> <d>FS: 00007f048cddb6e0(0000) GS:ffff88007e200000(0000) knlGS:0000000000000000
>>> <d>CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> <d>CR2: 000000000040d040 CR3: 000000238ea69000 CR4: 00000000000406f0
>>> <d>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> <d>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process fio (pid: 13846, threadinfo ffff8823fb7e8000, task ffff882432ead120)
>>> <0>Stack:
>>> <c> ffff8823fb7e9c68<c> ffffffff814478ce<c> ffff882300000001<c>
>>> ffff8823cf614000<c>
>>> <c> ffff882300000004<c> ffffffff814478ce<c> fffffffffffffc00<c>
>>> 00000000814478ce<c>
>>> <c> ffff8823fb7e8000<c> 0000000000000400<c> 0000000a00000001<c>
>>> ffff8823fb7e8000<c>
>>>
>>> Checking that function it's
>>>
>>> 0xffffffff8111d90d is in __blockdev_direct_IO (fs/direct-io.c:955).
>>>
>>> and that points to following line in direct-io.c:
>>>
>>>  955             BUG_ON(this_chunk_bytes == 0);
>>>
>>> We also tested with following patch from kernel.org
>>>
>>> f9b5570 fs: simplify handling of zero sized reads in __blockdev_direct_IO
>>>
>>> That resolved the panic problem.
>>>
>>> Can you please add check to fio that it should error out OR skip 0
>>> size accesses ?
>>
>> It seems you forgot to include the job file that triggered this :-)
>> Fio should not be making zero sized reads, but pretty embarassing that
>> the kernel oopsed on getting one. It could be a file system issue, a bug
>> there triggering a zero sized read.
>>
>> So how did you trigger this? And on what fs?
>>
>> --
>> Jens Axboe
>>
> 
> The job file is attached. It is a simple job file doing direct IO (so
> no fs) on a flash device.

What fio version did you use?

-- 
Jens Axboe

