Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:41917 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbbCDEUe (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Mar 2015 23:20:34 -0500
Received: by labgm9 with SMTP id gm9so2304080lab.8
        for <fio@vger.kernel.org>; Tue, 03 Mar 2015 20:20:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C907C3B4-6C98-4E1E-A363-0F3C110BF2E1@ornl.gov>
References: <C907C3B4-6C98-4E1E-A363-0F3C110BF2E1@ornl.gov>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 4 Mar 2015 08:20:12 +0400
Message-ID: <CANvN+ekJfoPg6Z37QZ7c7j_myhxtKfMGpWC1RHRw-1eSX5dPRg@mail.gmail.com>
Subject: Re: Missing completions with libaio after context switch?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Caldwell, Blake A." <blakec@ornl.gov>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Mar 4, 2015 at 6:40 AM, Caldwell, Blake A. <blakec@ornl.gov> wrote:
> While looking at fio activity with libaio using blktrace, I could not find completion requests when fio is rescheduled onto a different CPU.

Are you witnessing a completion lost, with the respective I/O hung? Or
is it a blktrace rather than fio issue?

If the completion is indeed lost, I stumbled upon a similar issue a
while back, around fio-2.1 (which, by the way, is quite outdated, so
you might want to rerun this experiment with a more recent release
such as https://github.com/axboe/fio/releases/tag/fio-2.2.6), but that
happened in a special case where I experimented with user_space_reap
feature of the libaio engine. Under normal circumstances, this path is
not invoked, and I've never faced lost completions with libaio even in
massive multi-core setup.

HTH,
Andrey

For instance, in the trace below the IO stream to /dev/sdae is moved
from CPU 8 to CPU 10 and there is no corresponding completion (or
insertion) for a get request at offset 5743016.  It would seem that
fio was preempted before fully forming the request (Q and G, but no I
or D). Is this expected behavior?
>
> fio version 2_1_4 from http://git.kernel.dk/fio.git
>
> fio --bs=4k --ioengine=libaio --rw=write --iodepth=127 --buffered=0 --norandommap --thread --loops=2147483648 --runtime=60 --gtod_reduce=1 --invalidate=1 --name=/dev/sdae --filename=/dev/sdae
>
>  65,224  8    84946     0.228857464  9729  C  WS 5742888 + 8 [0]
>  65,224  8    84947     0.228858948  9729  C  WS 5742896 + 8 [0]
>  65,224  8    84948     0.228861434  9729  C  WS 5742904 + 8 [0]
>  65,224  8    84949     0.228862696  9729  C  WS 5742912 + 8 [0]
>  65,224  8    84950     0.228863825  9729  C  WS 5742920 + 8 [0]
> ...
>  65,224  8    84966     0.228883226  9729  Q  WS 5743008 + 8 [fio]
>  65,224  8    84967     0.228883518  9729  G  WS 5743008 + 8 [fio]
>  65,224  8    84968     0.228883783  9729  I  WS 5743008 + 8 [fio]
>  65,224  8    84969     0.228884001  9729  D  WS 5743008 + 8 [fio]
>  65,224  8    84970     0.228885688  9729  U   N [fio] 11
>  65,224  8    84971     0.228888429  9729  Q  WS 5743016 + 8 [fio]
>  65,224  8    84972     0.228888728  9729  G  WS 5743016 + 8 [fio]
>  65,224 10        1     0.243064252  9729  Q  WS 5757368 + 8 [fio]
>  65,224 10        2     0.243065348  9729  G  WS 5757368 + 8 [fio]
>  65,224 10        3     0.243066110  9729  I  WS 5757368 + 8 [fio]
>  65,224 10        4     0.243066816  9729  D  WS 5757368 + 8 [fio]
> ...
>  65,224 11    42478     0.322827200  9729  C  WS 5831064 + 8 [0]
>  65,224 11    42479     0.322833478  9729  Q  WS 5831144 + 8 [fio]
>  65,224 11    42480     0.322833826  9729  G  WS 5831144 + 8 [fio]
>  65,224  8    84973     0.334959322  9729  Q  WS 5842992 + 8 [fio]
>  65,224  8    84974     0.334960161  9729  G  WS 5842992 + 8 [fio]
>  65,224  8    84975     0.334960993  9729  I  WS 5842992 + 8 [fio]
>  65,224  8    84976     0.334961632  9729  D  WS 5842992 + 8 [fio]
>  65,224  8    84977     0.334966226  9729  U   N [fio] 1
>
> # blkparse sdae |grep "WS 5743016"
>  65,224  8    84971     0.228888429  9729  Q  WS 5743016 + 8 [fio]
>  65,224  8    84972     0.228888728  9729  G  WS 5743016 + 8 [fio]
>
> # blktrace --version
> blktrace version 2.0.0
>
> kernel 2.6.32-431.17.1.el6.x86_64--
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
