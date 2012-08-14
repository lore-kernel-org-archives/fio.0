Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56674 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2HNTQR convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 14 Aug 2012 15:16:17 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How to do strict synchronous i/o on Windows?
Date: Tue, 14 Aug 2012 21:16:15 +0200
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com> <201208141936.34301.Martin@lichtvoll.de> <CAHaS=Qye5bO_A=WQ-RFYHnSmkhXSeuBWT1qP+3rFQx7+9UW_vQ@mail.gmail.com> (sfid-20120814_211246_197334_D361F96C)
In-Reply-To: <CAHaS=Qye5bO_A=WQ-RFYHnSmkhXSeuBWT1qP+3rFQx7+9UW_vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201208142116.15899.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> On 15 August 2012 03:36, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Hi Greg,
[…]
> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
> >
> >> On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
> >> >
> >> > On 08/14/2012 08:24 AM, Greg Sullivan wrote:
> >> > > I need to simulate strict synchronous, round robin i/o to a group of
> >> > > files. I am on Windows 7 32-bit.
> >> > > fio is very nearly working, except that even with a queue depth of 1,
> >> > > it is still resulting in a disk queue that is > 1, because the
> >> > > "iodepth" parameter is not global - it is per thread. (correct?)
> >> > >
> >> > > I've tried using the "sync" engine, however that doesn't work at all -
> >> > > just spews out errors.
> >> >
> >> > That'll be the case for ANY platform and IO engine. If you have more
> >> > than 1 thread or process going, you can have > 1 depth at the device
> >> > side. The definition of a sync IO call is that the call doesn't return
> >> > until the IO is done. If you have overlapped calls due to more than 1
> >> > thread, then that is no longer true.
> >> >
> >> > What you are looking for is outside the scope of an application. You
> >> > would have to limit the queue depth on the operating system side to
> >> > achieve that. Or artificially limit fio in some way, which would not
> >> > make a lot of sense imho.
> >
> >> Thanks Jens. I do in fact have an application that reads in exactly the
> >> manner I described. I have monitored the queue depth - it does not rise
> >> above 1.  It is a real time musical sample streamer.
> >>
> >> Please consider this a new feature request for fio - thankyou.
> >
> > Is this application multithreaded? If so, are mutiple threads doing I/O
> > at the same time? If not I´d suggest just testing with one job.
> 
> I don't know whether it is multithreaded or not. All I know is that it
> reads many files sequentially and in a round-robin fashion, without
> causing any disk queuing.
> 
> Is it possible to read from more than file in a single job, in a
> round-robin fashion? I tried putting more than one file in a single
> job, but it only opened one file. If you mean to just do random reads
> in a single file - I've tried that, and the throughput is
> unrealistically low. I suspect it's because the read-ahead buffer
> cannot be effective for random accesses.  Of course, reading
> sequentially from a single file will result in a throughput that is
> far too high to simulate the application.

Have you tried

       nrfiles=int
              Number of files to use for this job.  Default: 1.

       openfiles=int
              Number of files to keep open at the same time.  Default:
              nrfiles.

       file_service_type=str
              Defines  how files to service are selected.  The follow‐
              ing types are defined:

                     random Choose a file at random

                     roundrobin
                            Round robin  over  open  files  (default).
                            sequential Do each file in the set sequen‐
                            tially.

              The number of I/Os to issue before switching a new  file
              can  be  specified  by  appending  `:int' to the service
              type.

? (see fio manpage).

It seems to me that all you need is nrfiles. I´d bet that fio distributes
the I/O size given among those files, but AFAIR there is something about
that in fio documentation as well.

Use the doc! ;)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
