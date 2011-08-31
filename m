Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:24960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab1HaW6D convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 31 Aug 2011 18:58:03 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id p7VMw1Ow001684
	for <fio@vger.kernel.org>; Wed, 31 Aug 2011 15:58:02 -0700
Received: from gxk8 (gxk8.prod.google.com [10.202.11.8])
	by wpaz29.hot.corp.google.com with ESMTP id p7VMw0hF007043
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 31 Aug 2011 15:58:00 -0700
Received: by gxk8 with SMTP id 8so933785gxk.9
        for <fio@vger.kernel.org>; Wed, 31 Aug 2011 15:58:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAK6Zt3cnfUra+vXrZG5ondMf49KDgKf3JOgCM5rbi=KxJvD_Q@mail.gmail.com>
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
	<x4962lfkn74.fsf@segfault.boston.devel.redhat.com>
	<CAAK6Zt0uPgY1V1tJihUwKxbjtNVNUqMZu0UDmUtRdJY4k_Lkmw@mail.gmail.com>
	<CAAK6Zt3iVsTS9=YGSJ3dTvY3vSYBygQYR9HeJwh8Zivmkfa7dg@mail.gmail.com>
	<x49obz6k3eu.fsf@segfault.boston.devel.redhat.com>
	<CAAK6Zt0SUBi_+_XRkP0pU5W6RYjcQhg-W+RkJP5qpteGSwPo4g@mail.gmail.com>
	<x49r5415x0j.fsf@segfault.boston.devel.redhat.com>
	<CAAK6Zt3cnfUra+vXrZG5ondMf49KDgKf3JOgCM5rbi=KxJvD_Q@mail.gmail.com>
Date: Wed, 31 Aug 2011 15:58:00 -0700
Message-ID: <CAAK6Zt1RmAtp7SJE9iEspft2Ki0iVsFH3FDxg71hwsxJsB8UYA@mail.gmail.com>
Subject: Re: [PATCH] Adding userspace_libaio_reap option
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>

Looks like I accidentally sent a reply just to Jeff rather than to the
list, and we've had a little exchange this way. For the record, here's
what we discussed. Jeff, please reply to this email instead of the one
I just sent you.

---------- Forwarded message ----------
From: Daniel Ehrenberg <dehrenberg@google.com>
Date: Wed, Aug 31, 2011 at 3:55 PM
Subject: Re: [PATCH] Adding userspace_libaio_reap option
To: Jeff Moyer <jmoyer@redhat.com>


On Wed, Aug 31, 2011 at 10:08 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Daniel Ehrenberg <dehrenberg@google.com> writes:
>
>> On Tue, Aug 30, 2011 at 2:14 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Daniel Ehrenberg <dehrenberg@google.com> writes:
>>>
>>>> On Tuesday, August 30, 2011, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>>> Dan Ehrenberg <dehrenberg@google.com> writes:
>>>>>
>>>>>> When a single thread is reading from a libaio io_context_t object
>>>>>> in a non-blocking polling manner (that is, with the minimum number
>>>>>> of events to return being 0), then it is possible to safely read
>>>>>> events directly from user-space, taking advantage of the fact that
>>>>>> the io_context_t object is a pointer to memory with a certain layout.
>>>>>> This patch adds an option, userspace_libaio_reap, which allows
>>>>>> reading events in this manner when the libaio engine is used.
>>>>>
>>>>> I haven't yet tried to poke holes in your code, but I'm pretty sure I
>>>>> can find some. =EF=BF=BDI have patches for the kernel and libaio whic=
h allow
>>>>> user-space reaping of events. =EF=BF=BDWhy don't I dust those off and=
 post them,
>>>>> and then fio won't have to change at all? =EF=BF=BDThat seems like to=
 proper
>>>>> approach to solving the problem.
>>>>>
>>>>> Cheers,
>>>>> Jeff
>>>>>
>>>>
>>>> Ken Chen posted some patches which accomplish this in 2007. However, I=
 was a
>>>> little concerned about his lock-free queue structure--it seems like an
>>>> integer overflow might cause events to be lost; on the other hand this=
 is
>>>> very unlikely. Are you talking about Ken's patchset or another one?
>>>
>>> I'm talking about another one, since I completely forgot about Ken's
>>> patches. =EF=BF=BDThanks for reminding me!
>>>
>>> I'm not sure your approach will work on all architectures without kernel
>>> modification. =EF=BF=BDI think at least a flush_dcache_page may be requ=
ired.
>>> More importantly, though, I'd like to discourage peeking into the
>>> internals outside of the libaio library. =EF=BF=BDDoing this makes it r=
eally
>>> hard to change things moving forward.
>>
>> Are you saying flush_dcache_page from the kernel or from user-space?
>> What kind of architecture will have problems? What kind of failures
>> could result?
>
> From the kernel. =EF=BF=BDArm, ppc, mips, sparc64, etc would have issues.
> Basically everything that #defines ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1.
> Specifically, updates to the tail by the kernel would not be seen in
> userspace.

If updates to the tail are not seen in userspace immediately, then it
will just take longer for the reaping to occur, right? Eventually
something else will flush the cache, and then userspace can see that
there's a new event. A delay for observing an event is a performance,
not correctness, bug. Or am i understanding this wrong?
>
>> About ABI dependence: I agree, it would be better to have things in
>> libaio rather than here. But to do reaping like this, with certain
>> restrictions about what context it's used in, I think we'd have to
>> make another function rather than just changing io_getevents. At
>> first, I was looking into changing io_getevents, but then I realized
>> that the application I'm working on optimizing, like FIO, is only
>> calling io_getevents in a certain pattern, making all of the
>> synchronization unnecessary. I don't think these two things are the
>> only users of io_getevents in this pattern. But maybe proper
>> synchronization can be made cheap enough that there's not a big
>> penalty for doing it properly all the time.
>
> I'm not sure what penalty you think exists. =EF=BF=BDIt's a matter of swi=
tching
> a spinlock in the kernel to an atomic cmpxchg. =EF=BF=BDUserspace would t=
hen
> also need atomic ops. =EF=BF=BDI'm pretty sure it'll be a net win over a =
system
> call.
>
> Cheers,
> Jeff
>

I was talking about the penalty of doing the atomic cmpxchg in
userspace rather than doing non-atomic operations. I agree that the
atomic operations in userspace will be a win over the system call,
since I've measured this. The atomic operations themselves actually
aren't that expensive, but they're not completely free; I don't have a
good idea of how much they are relative to the rest of what goes on in
a real workload, but probably not much.

Dan
