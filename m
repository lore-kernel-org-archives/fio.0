Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33375 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbeCQGfX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Mar 2018 02:35:23 -0400
Received: by mail-ua0-f182.google.com with SMTP id f6so7996338ual.0
        for <fio@vger.kernel.org>; Fri, 16 Mar 2018 23:35:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7d4b20a37c7c500d6565a76db6481a40@mail.gmail.com>
References: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com>
 <368477604.10754890.1521010004445.JavaMail.zimbra@redhat.com> <7d4b20a37c7c500d6565a76db6481a40@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Mar 2018 06:34:51 +0000
Message-ID: <CALjAwxi2WtkSLG6v7sMWWoWZVSOqGahiX3aYRT6Fuh23_K8HGw@mail.gmail.com>
Subject: Re: Proper way to shut down FIO in Linux
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matt Freel <matt.freel@broadcom.com>
Cc: Erwan Velu <evelu@redhat.com>, fio <fio@vger.kernel.org>

Matt,

You didn't include the fio line you are running which cause the
problem. That sort of thing is useful extra information - see
https://github.com/axboe/fio/blob/master/REPORTING-BUGS .

1. Which file are we talking about? For example if a job is abandoned
due to it hanging you start skipping past code like this:

backend.c
2497         if (!fio_abort) {
2498                 __show_run_stats();
2499                 if (write_bw_log) {
2500                         for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
2501                                 struct io_log *log =3D agg_io_log[i];
2502
2503                                 flush_log(log, false);
2504                                 free_log(log);
2505                         }
2506                 }
2507         }

So that's an example of a log file won't necessarily be flushed if a
job is believed to be stuck. There are also logs that may not be
written if the job itself is stuck in the running state:

1525 static void *thread_main(void *data)
1526 {
[...]
1755
1756         while (keep_running(td)) {
[...]
1853         }
1854
[...]
1882         td_writeout_logs(td, true);

So I wouldn't depend on all the logs being correct if you have stuck
jobs that end up being abandoned. With regard to a) the general stats
might be OK but you're going to potentially have data at the end of
them that's indeterminate depending on why the job became stuck and
since we don't know the thread is dead the "final" stats might be
pulled while the job is in the middle of changing them...

2. What you're doing will send a kill to all fio processes which may
mean that when in process mode fio's child jobs get signalled before
the main job. You might things get better if you just the main fio
backend thread and let that then send the kill message to the other
processes.

Nonetheless, it would be useful to know the minimal fio command line
that generates the hangs you are referring to. If we had that then we
might be able to make things more robust by debugging the problem.

On 14 March 2018 at 15:07, Matt Freel <matt.freel@broadcom.com> wrote:
> I'm using it to generate IO -- not necessarily as a benchmark.  I'm runni=
ng
> IO, taking some other measurements, then killing it to kick off a differe=
nt
> workload.  The time it needs to run is not constant -- it depends on a bu=
nch
> of different things.
>
> -----Original Message-----
> From: Erwan Velu <evelu@redhat.com>
> Sent: Wednesday, March 14, 2018 12:47 AM
> To: Matt Freel <matt.freel@broadcom.com>
> Cc: fio@vger.kernel.org
> Subject: Re: Proper way to shut down FIO in Linux
>
> Hey,
>
> Why do you want to kill fio ? That sounds weird to me.
>
> If you need to run your benchmark on constant time then use time_based &
> runtime instructions.
>
> ----- Mail original -----
> De: "Matt Freel" <matt.freel@broadcom.com>
> =C3=80: fio@vger.kernel.org
> Envoy=C3=A9: Mardi 13 Mars 2018 19:56:10
> Objet: Proper way to shut down FIO in Linux
>
> I'm using FIO to run IOs to a number of block devices.  I'm looking for t=
he
> proper way to shut down all the threads that are spawned.
>
> I'm doing the following:
>
> /usr/bin/pkill --signal INT fio
>
> Most of the time this works fine, but I do have cases where some of the F=
IO
> processes remain open.  Eventually I get a 300s timeout and then they're
> killed.
>
> A couple questions:
>
> 1.      When these threads have to be ungracefully killed, do the results
> still get counted in the output file?
> a.      I'm using JSON output file
> 2.      Is there a better way I should be killing all the threads?

--=20
Sitsofe | http://sucs.org/~sits/
