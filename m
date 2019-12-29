Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45514 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfL2VQc (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Dec 2019 16:16:32 -0500
Received: by mail-wr1-f50.google.com with SMTP id j42so31097980wrj.12
        for <fio@vger.kernel.org>; Sun, 29 Dec 2019 13:16:31 -0800 (PST)
MIME-Version: 1.0
References: <CANbyPNfpV0dazkiyviWs1yZtnGkjC-3zYBZt6QCr2wGgnGv1jw@mail.gmail.com>
 <CALjAwxjuA71m-FdOb=gpFDt8mrgedgcgEikB62gUjv0M248nrA@mail.gmail.com> <06dee952d2214867863d4423127553b8@AUSX13MPS306.AMER.DELL.COM>
In-Reply-To: <06dee952d2214867863d4423127553b8@AUSX13MPS306.AMER.DELL.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 29 Dec 2019 21:16:04 +0000
Message-ID: <CALjAwxg03oE0h43NX7PSz7qxe4VWkoUwxMQ0YO32X7fUxnyAtg@mail.gmail.com>
Subject: Re: Running FIO until DUT leaves steadystate
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Charles.Colburn@dell.com
Cc: Mike Kingsbury <mike.kingsbury@cacheio.com>, fio <fio@vger.kernel.org>, Vincent Fu <vincentfu@gmail.com>

(CC'ing Vincent for comment)

On Thu, 19 Dec 2019 at 17:34, <Charles.Colburn@dell.com> wrote:
>
> Sitsofe
>
> Is there an example of using the steadystate option to do random preconditioning of and SSD? - I assume that is what it is for. I tried to use the featured a while back but never got it to work as expected.
>
> Chuck Colburn
>
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of Sitsofe Wheeler
> Sent: Thursday, December 19, 2019 1:11 AM
> To: Mike Kingsbury
> Cc: fio
> Subject: Re: Running FIO until DUT leaves steadystate
>
>
> [EXTERNAL EMAIL]
>
> Hi,
>
> On Fri, 13 Dec 2019 at 16:29, Mike Kingsbury <mike.kingsbury@cacheio.com> wrote:
> >
> > Reading through the docs and looked at some examples, its not clear if
> > its possible to accomplish this. In our case, we're attempting to
> > evaluate SSDs and determine when they start internal garbage
> > collection and how much performance drops.  Is there a way to detect
> > steadystate, and then exit when the DUT performance leaves that
> > steadystate?
>
> Not really. You can use the steadystate option (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-steadystate
> ) to try and determine when you're in the steadystate but then you're kind of stuck. Maybe once you knew what expected latencies were, you could then use max_latency (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-max-latency
> ) to allow a job to exit if one got obviously too high? You would have to do a fair bit of intermediate storage and processing to make this work and it's not clear how reliable it would be though...

-- 
Sitsofe | http://sucs.org/~sits/

