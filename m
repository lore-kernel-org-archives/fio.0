Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:43609 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfLSHLK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Dec 2019 02:11:10 -0500
Received: by mail-wr1-f50.google.com with SMTP id d16so4807534wre.10
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 23:11:08 -0800 (PST)
MIME-Version: 1.0
References: <CANbyPNfpV0dazkiyviWs1yZtnGkjC-3zYBZt6QCr2wGgnGv1jw@mail.gmail.com>
In-Reply-To: <CANbyPNfpV0dazkiyviWs1yZtnGkjC-3zYBZt6QCr2wGgnGv1jw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 07:10:43 +0000
Message-ID: <CALjAwxjuA71m-FdOb=gpFDt8mrgedgcgEikB62gUjv0M248nrA@mail.gmail.com>
Subject: Re: Running FIO until DUT leaves steadystate
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mike Kingsbury <mike.kingsbury@cacheio.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 13 Dec 2019 at 16:29, Mike Kingsbury <mike.kingsbury@cacheio.com> wrote:
>
> Reading through the docs and looked at some examples, its not clear if
> its possible to accomplish this. In our case, we're attempting to
> evaluate SSDs and determine when they start internal garbage
> collection and how much performance drops.  Is there a way to detect
> steadystate, and then exit when the DUT performance leaves that
> steadystate?

Not really. You can use the steadystate option
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-steadystate
) to try and determine when you're in the steadystate but then you're
kind of stuck. Maybe once you knew what expected latencies were, you
could then use max_latency
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-max-latency
) to allow a job to exit if one got obviously too high? You would have
to do a fair bit of intermediate storage and processing to make this
work and it's not clear how reliable it would be though...

-- 
Sitsofe | http://sucs.org/~sits/

