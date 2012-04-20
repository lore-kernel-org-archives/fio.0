Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2DTG1a (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 02:27:30 -0400
Message-ID: <4F9101C0.100@kernel.dk>
Date: Fri, 20 Apr 2012 08:27:12 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running fio with offset Increment option
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com> <4F899663.8050406@kernel.dk> <4F8997E9.6090206@kernel.dk> <CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com> <4F8D0E1A.2020004@kernel.dk> <CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com> <4F8FA704.30006@kernel.dk> <CAN8qX8baRKJrLRQ3p--NBMH9hA+G5om6R9hRQEr2ZXwbDc3Hwg@mail.gmail.com>
In-Reply-To: <CAN8qX8baRKJrLRQ3p--NBMH9hA+G5om6R9hRQEr2ZXwbDc3Hwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 04/19/2012 09:32 PM, Suresh Dhanarajan wrote:
> Hi Jens,
> 
> I tested with and without stonewall.
> with stonewall the offset is reset to zero for a newjob.
> But without stonewall the offset is not reseting zero.

How are you verifying that this is the case? I added a debug printf
here, and ran the below job:

---

[global]
numjobs=4
offset_increment=100m
filename=foo
ioengine=null
size=100g
rw=randread
rate=500m

[null]

[null-a]

[null-b]
stonewall

[null-c]

[null-d]
stonewall

[null-e]

---

Which should give us 4 jobs, then 4 more jobs at continuing offsets,
then null-b at 0 again, null-c at 4*100MB and up, null-d at zero and
null-e identical to null-c.

job1: file foo offset 0                 <- null
job2: file foo offset 104857600
job3: file foo offset 209715200
job4: file foo offset 314572800
job5: file foo offset 419430400         <- null-a
job6: file foo offset 524288000
job7: file foo offset 629145600
job8: file foo offset 734003200
job9: file foo offset 0                 <- null-b
job10: file foo offset 104857600
job11: file foo offset 209715200
job12: file foo offset 314572800
job13: file foo offset 419430400        <- null-c
job14: file foo offset 524288000
job15: file foo offset 629145600
job16: file foo offset 734003200
job17: file foo offset 0                <- null-d
job18: file foo offset 104857600
job19: file foo offset 209715200
job20: file foo offset 314572800
job21: file foo offset 419430400        <- null-e
job22: file foo offset 524288000
job23: file foo offset 629145600
job24: file foo offset 734003200

So it looks like it's working here, at least offset is being calculated
and set correctly. Hence my question on why it isn't working for you. If
you are looking at the actual IO offsets generated, then it's possible
there is a bug somewhere. That bug should, however, also affect the
original patch since this is just changing how we generate them upfront.

-- 
Jens Axboe

