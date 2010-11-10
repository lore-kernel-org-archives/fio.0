Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:36560 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KJOPd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Nov 2010 09:15:33 -0500
Message-ID: <4CDAA901.4060802@fusionio.com>
Date: Wed, 10 Nov 2010 15:15:29 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio and multithreading
References: <AANLkTin+_h4qUpwWw_0-ANwpbfPaMueW+9JcnXJ3TkGD@mail.gmail.com>
In-Reply-To: <AANLkTin+_h4qUpwWw_0-ANwpbfPaMueW+9JcnXJ3TkGD@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-11-09 18:39, Bart Van Assche wrote:
> On Tue, Nov 9, 2010 at 2:16 PM, Jens Axboe <jaxboe@fusionio.com <mailto:jaxboe@fusionio.com>> wrote:
> 
>     [ ... ]
> 
>     This looks pretty straightforward - the file is created, but not filled
>     with a verifiable pattern. You want to run the workload with rw=write
>     at least once first, then you can use a read-only verify workload later
>     if you want.
> 
> 
> Hello Jens,
> 
> Sorry for the confusion. Something else I came across is the global
> variable last_tv in gettime.c. As far as I can see this variable is
> shared over all fio threads and multiple threads can update this
> variable simultaneously ? I was surprised to see that the variable
> last_tv is updated non-atomically and without being protected by any
> kind of lock. Shouldn't such behavior be documented ?

That is correct, and yes it looks unfortunate. The update really should
be atomic for this to be safe.

> And if my analysis is correct, the variable thread_data.runstate is
> also shared over threads. Will the code that reads that variable work
> correctly on a multiprocessor system that allows write reordering ?
> Or, in other words, have any assumptions been made about values
> written by a worker thread being available to the main thread as soon
> as the main thread notices that the thread state has been updated ?

Also a correct assumption. I think that should be fixed up by always
using td_set_runstate() and introducing an equiv td_get_runstate() to
ensure that it's properly flushed and seen. The volatile is not enough
for this.

> Something else I noticed is that the function print_thread_status() is
> invoked from a SIGALRM signal handler, and that print_thread_status()
> invokes e.g. printf(). I'm afraid that that's not entirely
> POSIX-compliant: the POSIX specs define a limitative list of functions
> that may be invoked from signal handlers, and printf() is not included
> in that list. That list can be found e.g. here:
> <http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_04.html#tag_02_04>http://www.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html.
> I'm not sure though what the consequences are of invoking functions
> that are not async-signal-safe from a signal handler.

I was not aware of that contraint. To be honest, I'm not aware of any
problems that this has caused on any of the platforms supported. The
risk of this causing any issues is minute, and the worst that could
happen is that the ETA output that is generated on the ALRM could be
garbled somewhat. At least that seems to be the worst side effect of
printf() being interrupted.

-- 
Jens Axboe

