Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36606 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753222AbdIHGVN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Sep 2017 02:21:13 -0400
Received: by mail-ua0-f176.google.com with SMTP id q29so2748928uaf.3
        for <fio@vger.kernel.org>; Thu, 07 Sep 2017 23:21:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADAGN7XhtCCJotMXjimEYYR47YAshyP=ymDNaFNSaNhF_00wEg@mail.gmail.com>
References: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
 <CALjAwxgQVhaviwg0wEqsqqHCsyksf0ES+E6-S3ON7HhUMn17ng@mail.gmail.com>
 <CADAGN7UzGuCBbTs3URhqi6RiwNrOs-jLu0VtVRmT6nWvMnjPHg@mail.gmail.com>
 <CALjAwxjv2LXhnBEXn5R3pw2KfapvEu7FKojbjxWKhBUMJJEPhg@mail.gmail.com>
 <CALjAwxjR+fcBy9=E6bwMHf9Ns0+Z8UAQxUcGczLimNU4cV3UCg@mail.gmail.com> <CADAGN7XhtCCJotMXjimEYYR47YAshyP=ymDNaFNSaNhF_00wEg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 8 Sep 2017 07:20:41 +0100
Message-ID: <CALjAwxgAuHfPu_jq8pLoha5jX2MXVcof1NyE-9XsnQKK+3QVVA@mail.gmail.com>
Subject: Re: NCQ Priority Support and FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brandon Schwartz <schwartz.xn@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 5 September 2017 at 19:45, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>
> Building off of the above change to control the priority bit, I'm
> trying to add the ability to track completion latencies for high and
> low prio read commands separately, but I'm not sure what I added to FIO is
> exactly correct.  It seems to be very accurate for qdepths up to 8,
> but at 16 and 32 I start seeing the FIO output for the high prio
> commands be higher than what I see when I take a bus trace and parse
> that (low prio latencies are what I would expect however).  What I am
> trying to do is track the priority of the IO when it is set in
> libaio.c via the following (notice the io_us[0]->priorityBit
> additions):
>
> https://github.com/brschwartz/fio/blob/10fdb93663e52beefa1f5dd836927d1e85c354d7/engines/libaio.c#L280

This is going to get confusing fast as you are changing the priority
of the fio thread/process periodically rather than tagging the I/O
with a priority which it keeps until completion. Are you saying
batches of I/O all have the same priority and if so why aren't you
tagging all the I/Os that comprise your batch? What if you submit an
I/O then while waiting for completion you send another I/O off but
change your I/O priority - what does that mean for the first I/O when
it completes? My understanding is that ioprio_set only controls CFQ
I/O scheduler priorities and nothing else BTW (Jens said you would
need a new kernel interface to pass NCQ priorities from fio over on
https://www.spinics.net/lists/fio/msg06102.html ).

> rand()%100

You may want to use fio's pseudorandom generator. See
get_rand_file_size() in filesetup.c for an example.

> And then I grab that value again when the IO is complete and add the
> associated latency to high and low prio read data structures which
> then get outputted in the json output.
>
> https://github.com/brschwartz/fio/commit/b7ad9003feb83fca57ec7438f5532426f597cec6
> https://github.com/brschwartz/fio/blob/10fdb93663e52beefa1f5dd836927d1e85c354d7/stat.c#L1056
>
> Does this seem right?  Or should I be tracking it a different way?
> Thanks for any help/input!

I find the premise a bit confusing because unless you're using
direct=1 coupled with the appropriate batch options
(http://fio.readthedocs.io/en/latest/fio_doc.html#i-o-depth ) so you
maintain the same priority across the whole lifetime of an I/O.
Without at least that you don't know if the I/Os are sitting in a
queue in while you repeatedly flip priorities of the thread/process
and at that point what priority should the completed I/O be attributed
to?

-- 
Sitsofe | http://sucs.org/~sits/
