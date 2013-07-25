Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3GYTUM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 15:20:12 -0400
Message-ID: <51F17A57.3040609@kernel.dk>
Date: Thu, 25 Jul 2013 13:19:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Weird trim test results
References: <CAF+0mvm8_89BhXRcs46d-AzyGunuVy3E32dcYi=kGThQkhAgfg@mail.gmail.com> <51F137D4.7000609@kernel.dk> <CAF+0mvnzF80RA8m2L9kZjrmT5OkuxYSwhGWOf+YXjOXv3RLCJA@mail.gmail.com> <51F16BCD.1000202@kernel.dk> <CAF+0mvkodcOjZ2yigxFSiq+Hjc7c5FYOOCP=j+ZthW-hCKzT+w@mail.gmail.com>
In-Reply-To: <CAF+0mvkodcOjZ2yigxFSiq+Hjc7c5FYOOCP=j+ZthW-hCKzT+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

On 07/25/2013 01:19 PM, Matthew Eaton wrote:
> On Thu, Jul 25, 2013 at 11:17 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> Please don't top post...
>>
>> On 07/25/2013 11:27 AM, Matthew Eaton wrote:
>>> Hi Jens,
>>>
>>> I'm running Ubuntu 12.04.2, my kernel is:
>>>
>>> Linux matt-work 3.5.0-36-generic #57~precise1-Ubuntu SMP Thu Jun 20
>>> 18:21:09 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> Here is the output I got from blktrace / blkparse:
>>>
>>> Total (sdb):
>>>  Reads Queued:         166,      664KiB     Writes Queued:
>>> 3001,    12004KiB
>>>  Read Dispatches:      166,      664KiB     Write Dispatches:
>>> 3001,    12004KiB
>>>  Reads Requeued:         0         Writes Requeued:         0
>>>  Reads Completed:      166,      664KiB     Writes Completed:
>>> 3001,     1500KiB
>>>  Read Merges:            0,        0KiB     Write Merges:
>>> 0,        0KiB
>>>  PC Reads Queued:        0,        0KiB     PC Writes Queued:
>>> 0,        0KiB
>>>  PC Read Disp.:         22,        3KiB     PC Write Disp.:
>>> 0,        0KiB
>>>  PC Reads Req.:          0         PC Writes Req.:          0
>>>  PC Reads Compl.:       10         PC Writes Compl.:        0
>>>  IO unplugs:           166             Timer unplugs:           0
>>
>> That looks fine, it might just be coincidence that you are capped at
>> ~100 IOPS. I don't think it's that unlikely that the this is the limit
>> for you, your device might have a fixed overhead associated with a trim
>> request. I'd have to look closer at your system to see if that's the
>> case or not.
>>
>> --
>> Jens Axboe
>>
> 
> Sorry, I'm kind of new to mailing lists.  I'll test some different
> drive / system configurations next.  Thanks for your help!

I think that would be useful, will certainly help in pin pointing what
the limiting component is here.

-- 
Jens Axboe

