Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:38130 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbeHINOS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Aug 2018 09:14:18 -0400
Received: by mail-ua0-f170.google.com with SMTP id o11-v6so5756011uak.5
        for <fio@vger.kernel.org>; Thu, 09 Aug 2018 03:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANyP7Cj=HGRHVAyuZOu9Yxi8A_JYNKUb7venqen3cp77euFxdw@mail.gmail.com>
References: <CANyP7Cj4hNtq5aeQ-h1L3ZtyBch0GDfab+4E2cChnKJTwjYsLg@mail.gmail.com>
 <CALjAwxgo0gYvmitK0GvLiYLQZvMAK2UeUJRAvWdVTrbmtioD0g@mail.gmail.com> <CANyP7Cj=HGRHVAyuZOu9Yxi8A_JYNKUb7venqen3cp77euFxdw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 9 Aug 2018 11:49:29 +0100
Message-ID: <CALjAwxjgKP5K+Nc+TPr3jZkkYgQK8mC71kr0cSEW1Y8Q+K4XWg@mail.gmail.com>
Subject: Re: What exactly is iodepth in fio?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeevan Patnaik <g1patnaik@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hello Jeevan,

(Resending to the list. Please don't send HTML mail to the mailing
list - it only accepts plaint text)

On 9 August 2018 at 08:50, Jeevan Patnaik <g1patnaik@gmail.com> wrote:
> Hi Sitsofe,
>
> Thanks for the detailed answer. :)
>
> Few things are now clear i.e., what iodepth parameter actually does. But I'm
> unable to figure out when to actually use it with fio.
>
> And I am sorry I couldnt respond early. I was trying to reply immediately,
> but was stuck with framing my question and reading a bit more about it :)
>
> I am trying to findout a way to exploit NVMe and see where it can beat HP
> SSD RAID 5 storage array.

[I'm going to copy/paste an answer from
https://github.com/axboe/fio/issues/579#issuecomment-382327888 ]

There has been the occasional "What are go faster options for fio?"
questions on the mailing list in the past (e.g.
https://www.spinics.net/lists/fio/msg05451.html ) and there are
examples of the jobs people used to reach high IOPS in various places
(e.g. https://marc.info/?l=linux-kernel&m=140313968523237&w=2 ). Some
of those options increase IOPS at the expense of CPU though but some
will reduce overhead while increasing latency (e.g. the batching
options in http://fio.readthedocs.io/en/latest/fio_doc.html#i-o-depth
).

(Don't forget to look over
https://github.com/axboe/fio/blob/master/MORAL-LICENSE if you're going
to publish statistics using fio)

> Before I posted the question in the forum, I was trying to set higher IO
> depth, as I thought NVMe devices can handle 65536 queues at a time whereas
> SSD can handle 256 queues. As I couldn't find any significant difference
> when setting higher IOdepths with both of them
> (iodepth-1,2,8,16,256,1024,32768), I stopped meddling with iodepth.

Tuning your fio and your system is a topic in itself but some of the
previous links will give you some areas to start with.

> So from your answer, now I understand that Iodepth is only needed with fio
> to be able to put as much as load as possible on the storage controller and
> so even if we run out of the CPUs, this higher Iodepth will be able to put
> that load on the storage controller (can I call this as load?)  And due to

Hmm not quite. It's more about being able to submit I/O efficiently.
Imagine a hypothetical scenario where your controller/disk has a high
latency per I/O but can accept huge numbers of I/Os in parallel. At a
depth of 1 your CPU may actually be very idle waiting for each I/O to
come back because the latency is high. However at a high iodepth you
can reach that parallelism because your CPU is now able to overlap the
submitting and receiving acknowledgement of done I/O stages and
potentially be usefully busy.

> connectivity and also buffer size limitations in the host that is submitting
> I/O, at some point of time, the load on storage can not get higher.
> The connectivity, I mean, how the storage is connected: i.e., direct
> attached disk can be exploited heavily while with network attached storage,
> we may not be able to reach high load.

Network attached storage often introduces higher latency but it can
potentially still have good throughput.

> What about NFS or any other file level storage, will the IO depth has any

More layers = more opportunity for more latency and points for
bottlenecks. It's not as straight forward as NFS = bad though.

> effect on them? I'm guessing Iodepth uses ioscheduler to control this io

It is the OS that is in control of its own ioscheduler (if it chooses
to use one) so I don't understand this statement. Perhaps you can
rephrase this or give a small example?

> submission and Io scheduler doesn't have any effect on NFS (atleast NetApp
> NFS)?

How things are queued up and are sent on/by the client can have an
impact on the choices that can be made on the server. If the client is
overloaded then there's little the server can do to help...

> Finally, what is the case with the real environment? does the end user jobs
> too control this Iodepth and buffer mode. I believe in our environment, we

Well programs are submitting I/O but if a program submits I/O in a
"slow" fashion in a "wrong" way it may not get good performance. For
example, it's generally better to try and submit each I/O in a bigger
quantity (e.g. 64k) rather than one byte at a time if you have a
choice.

> use buffer and not direct, because from the mount stats, bytes gone through
> direct io is zero. Is IO Depth in fio only to set therotical benchmark on

You may be benefiting from caching. This may mean writes happen latter
than you think and reads for data that was previously brought into RAM
and is still there will be satisfied without having to retrieve
anything to the disk.

> the storage, but not to benchmark for real world scenario?

You're asking about workload modelling. What the correct model is
depends on what is being modelled. Some programs ARE able to submit
I/O asynchronously from a single thread. Some only submit I/O
synchronously but have lots if threads all submitting independently of
each other. Some programs do a mixture of the two. It's impossible to
say "doing X covers everything" because it depends on what you're
willing to approximate and how.

> Sorrya again for too many questions :|

-- 
Sitsofe | http://sucs.org/~sits/
