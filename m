Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1H3VgA convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 30 Aug 2011 17:36:00 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p7ULZxX0027894
	for <fio@vger.kernel.org>; Tue, 30 Aug 2011 14:36:00 -0700
Received: from gyg8 (gyg8.prod.google.com [10.243.50.136])
	by wpaz21.hot.corp.google.com with ESMTP id p7ULZvVi012843
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Tue, 30 Aug 2011 14:35:59 -0700
Received: by gyg8 with SMTP id 8so37343gyg.26
        for <fio@vger.kernel.org>; Tue, 30 Aug 2011 14:35:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAK6Zt0SUBi_+_XRkP0pU5W6RYjcQhg-W+RkJP5qpteGSwPo4g@mail.gmail.com>
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
	<x4962lfkn74.fsf@segfault.boston.devel.redhat.com>
	<CAAK6Zt0uPgY1V1tJihUwKxbjtNVNUqMZu0UDmUtRdJY4k_Lkmw@mail.gmail.com>
	<CAAK6Zt3iVsTS9=YGSJ3dTvY3vSYBygQYR9HeJwh8Zivmkfa7dg@mail.gmail.com>
	<x49obz6k3eu.fsf@segfault.boston.devel.redhat.com>
	<CAAK6Zt0SUBi_+_XRkP0pU5W6RYjcQhg-W+RkJP5qpteGSwPo4g@mail.gmail.com>
Date: Tue, 30 Aug 2011 14:35:58 -0700
Message-ID: <CAAK6Zt0cJvBeP5KOZ7kGALkSbzR5GzD5iFU4tPHWvAw9GouKWA@mail.gmail.com>
Subject: Re: [PATCH] Adding userspace_libaio_reap option
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org

On Tue, Aug 30, 2011 at 2:14 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Daniel Ehrenberg <dehrenberg@google.com> writes:
>
>> On Tuesday, August 30, 2011, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Dan Ehrenberg <dehrenberg@google.com> writes:
>>>
>>>> When a single thread is reading from a libaio io_context_t object
>>>> in a non-blocking polling manner (that is, with the minimum number
>>>> of events to return being 0), then it is possible to safely read
>>>> events directly from user-space, taking advantage of the fact that
>>>> the io_context_t object is a pointer to memory with a certain layout.
>>>> This patch adds an option, userspace_libaio_reap, which allows
>>>> reading events in this manner when the libaio engine is used.
>>>
>>> I haven't yet tried to poke holes in your code, but I'm pretty sure I
>>> can find some. =EF=BF=BDI have patches for the kernel and libaio which =
allow
>>> user-space reaping of events. =EF=BF=BDWhy don't I dust those off and p=
ost them,
>>> and then fio won't have to change at all? =EF=BF=BDThat seems like to p=
roper
>>> approach to solving the problem.
>>>
>>> Cheers,
>>> Jeff
>>>
>>
>> Ken Chen posted some patches which accomplish this in 2007. However, I w=
as a
>> little concerned about his lock-free queue structure--it seems like an
>> integer overflow might cause events to be lost; on the other hand this is
>> very unlikely. Are you talking about Ken's patchset or another one?
>
> I'm talking about another one, since I completely forgot about Ken's
> patches. =EF=BF=BDThanks for reminding me!
>
> I'm not sure your approach will work on all architectures without kernel
> modification. =EF=BF=BDI think at least a flush_dcache_page may be requir=
ed.
> More importantly, though, I'd like to discourage peeking into the
> internals outside of the libaio library. =EF=BF=BDDoing this makes it rea=
lly
> hard to change things moving forward.

Are you saying flush_dcache_page from the kernel or from user-space?
What kind of architecture will have problems? What kind of failures
could result?

About ABI dependence: I agree, it would be better to have things in
libaio rather than here. But to do reaping like this, with certain
restrictions about what context it's used in, I think we'd have to
make another function rather than just changing io_getevents. At
first, I was looking into changing io_getevents, but then I realized
that the application I'm working on optimizing, like FIO, is only
calling io_getevents in a certain pattern, making all of the
synchronization unnecessary. I don't think these two things are the
only users of io_getevents in this pattern. But maybe proper
synchronization can be made cheap enough that there's not a big
penalty for doing it properly all the time.
>
> Cheers,
> Jeff
>
