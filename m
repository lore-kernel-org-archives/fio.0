Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37319 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752143AbdIESpn (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Sep 2017 14:45:43 -0400
Received: by mail-it0-f53.google.com with SMTP id k189so4266624itk.0
        for <fio@vger.kernel.org>; Tue, 05 Sep 2017 11:45:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjR+fcBy9=E6bwMHf9Ns0+Z8UAQxUcGczLimNU4cV3UCg@mail.gmail.com>
References: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
 <CALjAwxgQVhaviwg0wEqsqqHCsyksf0ES+E6-S3ON7HhUMn17ng@mail.gmail.com>
 <CADAGN7UzGuCBbTs3URhqi6RiwNrOs-jLu0VtVRmT6nWvMnjPHg@mail.gmail.com>
 <CALjAwxjv2LXhnBEXn5R3pw2KfapvEu7FKojbjxWKhBUMJJEPhg@mail.gmail.com> <CALjAwxjR+fcBy9=E6bwMHf9Ns0+Z8UAQxUcGczLimNU4cV3UCg@mail.gmail.com>
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Tue, 5 Sep 2017 12:45:12 -0600
Message-ID: <CADAGN7XhtCCJotMXjimEYYR47YAshyP=ymDNaFNSaNhF_00wEg@mail.gmail.com>
Subject: Re: NCQ Priority Support and FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Sitsofe,

Building off of the above change to control the priority bit, I'm
trying to add the ability to track completion latencies for high and
low prio read commands separately, but I'm not sure what I added to FIO is
exactly correct.  It seems to be very accurate for qdepths up to 8,
but at 16 and 32 I start seeing the FIO output for the high prio
commands be higher than what I see when I take a bus trace and parse
that (low prio latencies are what I would expect however).  What I am
trying to do is track the priority of the IO when it is set in
libaio.c via the following (notice the io_us[0]->priorityBit
additions):

https://github.com/brschwartz/fio/blob/10fdb93663e52beefa1f5dd836927d1e85c354d7/engines/libaio.c#L280

And then I grab that value again when the IO is complete and add the
associated latency to high and low prio read data structures which
then get outputted in the json output.

https://github.com/brschwartz/fio/commit/b7ad9003feb83fca57ec7438f5532426f597cec6
https://github.com/brschwartz/fio/blob/10fdb93663e52beefa1f5dd836927d1e85c354d7/stat.c#L1056

Does this seem right?  Or should I be tracking it a different way?
Thanks for any help/input!

Regards,
Brandon



On Sat, Apr 8, 2017 at 3:06 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi Brandon,
>
> Looks like someone went on to implement a design based on what you
> were after https://github.com/xahmad/fio/commit/c45abdaa857bd30ccf4f20ed59340686fc3e9103
> . It's not in mainline fio but perhaps if it was cleaned up it could
> be submitted for inclusion?
>
> On 4 February 2017 at 07:37, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> >
> > I can't think of anything if you mean "I want the same thread/single
> > job to send both normal AND high priority commands" so perhaps it
> > would have to be done as new patch to the pvsync2 ioengine...
> >
> > On 4 February 2017 at 00:03, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
> >> Thanks for the info, I'll play around with that option and see if I
> >> can make that work.  Is there anything that would allow me to control
> >> the amount of priority commands from within a single thread?
> >>
> >> On Thu, Feb 2, 2017 at 3:36 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> >>>
> >>> Perhaps you could use multiple threads and utilise the flow
> >>> (http://fio.readthedocs.io/en/sphinx-doc/fio_doc.html#cmdoption-arg-flow
> >>> ) control on pairs of threads?
> >>>
> >>> On 2 February 2017 at 22:29, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
> >>>>
> >>>> 60% RandomRead / 40% RandomWrite but of those reads, have 15% be high priority
> >>>>
> >>>> Or is there a way to get this sort of priority testing done with
> >>>> current FIO?
>
> --
> Sitsofe | http://sucs.org/~sits/
