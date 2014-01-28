Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37811 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1WRt (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jan 2014 17:17:49 -0500
Date: Tue, 28 Jan 2014 15:17:48 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fio: consolidate rand_seed to uint64_t
Message-ID: <20140128221748.GE25989@kernel.dk>
References: <1390942940-6886-1-git-send-email-grundler@chromium.org>
 <20140128213014.GC31710@kernel.dk>
 <CANEJEGvZ3xnkg+D8RwVcvHfTKtVCcm_YP_geskOZTC0UNBnGOA@mail.gmail.com>
 <20140128220349.GD25989@kernel.dk>
 <CANEJEGurTpsgV5gUv1758dvE7UtP2zqNP6aLe4S69Ezo4i5yVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANEJEGurTpsgV5gUv1758dvE7UtP2zqNP6aLe4S69Ezo4i5yVA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>

On Tue, Jan 28 2014, Grant Grundler wrote:
> On Tue, Jan 28, 2014 at 2:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> >> -       o->rand_seed = le32_to_cpu(top->rand_seed);
> >> +       o->rand_seed = le64_to_cpu(top->rand_seed);
> >>
> >> I saw this when reviewing the code but didn't realize "top" was the
> >> packed version that got changed.
> >
> > Yeah, and vice versa for top -> o.
> 
> Oh! :(
> 
> (And I assume you mean line 288 as shown below)
> 
> If I add this:
> 
> diff --git a/cconv.c b/cconv.c
> index c4941ba..57996fb 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -285,7 +285,7 @@ void convert_thread_options_to_net(struct thread_options_pac
>         top->do_disk_util = cpu_to_le32(o->do_disk_util);
>         top->override_sync = cpu_to_le32(o->override_sync);
>         top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
> -       top->rand_seed = cpu_to_le32(o->rand_seed);
> +       top->rand_seed = cpu_to_le64(o->rand_seed);
>         top->use_os_rand = cpu_to_le32(o->use_os_rand);
>         top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
>         top->norandommap = cpu_to_le32(o->norandommap);
> 
> I get this warning:
> 
> grundler <2090>make V=1
> gcc -o cconv.o -std=gnu99 -Wwrite-strings -Wall
> -Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE
> -include config-host.h -DBITS_PER_LONG=64
> -DFIO_VERSION='"fio-2.1.4-26-g3a2a"' -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c cconv.c
> 
>     CC cconv.o
> cconv.c: In function ‘convert_thread_options_to_net’:
> cconv.c:288:19: warning: initialization from incompatible pointer type
> [enabled by default]
>     LINK fio
> 
> grundler <2091>file cconv.o
> cconv.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
> 
> 286         top->override_sync = cpu_to_le32(o->override_sync);
> 287         top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
> 288         top->rand_seed = cpu_to_le64(o->rand_seed);
> 289         top->use_os_rand = cpu_to_le32(o->use_os_rand);
> 290         top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
> 
> Now I'm just confused.

It's because the parser is using non uintxx_t types, so you can't really
please it here. There's __cpu_to_le64() to avoid this crap. But ideally,
the parser just needs changing so that anything that is now unsigned int
is uint32_t and unsigned long long needs to be uint64_t.

If you look at your committed patch, I made those changes for you.

-- 
Jens Axboe

