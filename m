Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59539 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2HNT4z convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 14 Aug 2012 15:56:55 -0400
Received: by yenl14 with SMTP id l14so901372yen.19
        for <fio@vger.kernel.org>; Tue, 14 Aug 2012 12:56:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208142116.15899.Martin@lichtvoll.de>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
	<201208141936.34301.Martin@lichtvoll.de>
	<CAHaS=Qye5bO_A=WQ-RFYHnSmkhXSeuBWT1qP+3rFQx7+9UW_vQ@mail.gmail.com>
	<201208142116.15899.Martin@lichtvoll.de>
Date: Wed, 15 Aug 2012 05:56:54 +1000
Message-ID: <CAHaS=Qya1tk=9gKkd+emx33aYKShgfaqyX6bUG7V9zzya2osOw@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 15/08/2012, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
>> On 15 August 2012 03:36, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>> > Hi Greg,
> […]
>> > Am Dienstag, 14. August 2012 schrieb Greg Sullivan:
>> >
>> >> On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>> >> >
>> >> > On 08/14/2012 08:24 AM, Greg Sullivan wrote:
>> >> > > I need to simulate strict synchronous, round robin i/o to a group
>> >> > > of
>> >> > > files. I am on Windows 7 32-bit.
>> >> > > fio is very nearly working, except that even with a queue depth of
>> >> > > 1,
>> >> > > it is still resulting in a disk queue that is > 1, because the
>> >> > > "iodepth" parameter is not global - it is per thread. (correct?)
>> >> > >
>> >> > > I've tried using the "sync" engine, however that doesn't work at
>> >> > > all -
>> >> > > just spews out errors.
>> >> >
>> >> > That'll be the case for ANY platform and IO engine. If you have more
>> >> > than 1 thread or process going, you can have > 1 depth at the device
>> >> > side. The definition of a sync IO call is that the call doesn't
>> >> > return
>> >> > until the IO is done. If you have overlapped calls due to more than
>> >> > 1
>> >> > thread, then that is no longer true.
>> >> >
>> >> > What you are looking for is outside the scope of an application. You
>> >> > would have to limit the queue depth on the operating system side to
>> >> > achieve that. Or artificially limit fio in some way, which would not
>> >> > make a lot of sense imho.
>> >
>> >> Thanks Jens. I do in fact have an application that reads in exactly
>> >> the
>> >> manner I described. I have monitored the queue depth - it does not
>> >> rise
>> >> above 1.  It is a real time musical sample streamer.
>> >>
>> >> Please consider this a new feature request for fio - thankyou.
>> >
>> > Is this application multithreaded? If so, are mutiple threads doing I/O
>> > at the same time? If not I´d suggest just testing with one job.
>>
>> I don't know whether it is multithreaded or not. All I know is that it
>> reads many files sequentially and in a round-robin fashion, without
>> causing any disk queuing.
>>
>> Is it possible to read from more than file in a single job, in a
>> round-robin fashion? I tried putting more than one file in a single
>> job, but it only opened one file. If you mean to just do random reads
>> in a single file - I've tried that, and the throughput is
>> unrealistically low. I suspect it's because the read-ahead buffer
>> cannot be effective for random accesses.  Of course, reading
>> sequentially from a single file will result in a throughput that is
>> far too high to simulate the application.
>
> Have you tried
>
>        nrfiles=int
>               Number of files to use for this job.  Default: 1.
>
>        openfiles=int
>               Number of files to keep open at the same time.  Default:
>               nrfiles.
>
>        file_service_type=str
>               Defines  how files to service are selected.  The follow‐
>               ing types are defined:
>
>                      random Choose a file at random
>
>                      roundrobin
>                             Round robin  over  open  files  (default).
>                             sequential Do each file in the set sequen‐
>                             tially.
>
>               The number of I/Os to issue before switching a new  file
>               can  be  specified  by  appending  `:int' to the service
>               type.
>
> ? (see fio manpage).
>
> It seems to me that all you need is nrfiles. I´d bet that fio distributes
> the I/O size given among those files, but AFAIR there is something about
> that in fio documentation as well.
>
> Use the doc! ;)
>
> Ciao,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
>

Yes, I have tried all that, and it works, except that it causes disk
queuing, as I stated in my first post. I thought you meant to put all
the files into a single [job name] section of the ini file, to enforce
single threaded io.

Thanks,
Greg.
