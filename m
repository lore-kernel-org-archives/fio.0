Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35744 "EHLO
	mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbcGZSLw (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jul 2016 14:11:52 -0400
Received: by mail-ua0-f179.google.com with SMTP id l32so3678960ual.2
        for <fio@vger.kernel.org>; Tue, 26 Jul 2016 11:11:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nn84j6$5la$1@ger.gmane.org>
References: <nn5git$q4l$1@ger.gmane.org> <CALjAwxgP4k4rRFAgpiJ-oBaBHd0OAyXXJ-dTZg7QxyaD36dO_g@mail.gmail.com>
 <nn66ih$j66$1@ger.gmane.org> <CALjAwxhCSTdi_EjvciC=-zy8=8G4rz-X6G4RiOgKwTeyumPPog@mail.gmail.com>
 <nn84j6$5la$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 26 Jul 2016 19:11:47 +0100
Message-ID: <CALjAwxj0ig71RbtP4oNmMNa9QumcDnBkHxao2g-u2EyLFFq-7A@mail.gmail.com>
Subject: Re: fio jobs time_based & runtime scope
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 26 July 2016 at 17:53, Saeed <ionictea@gmail.com> wrote:
> But what about in the case of a verify job where we want verification done
> (do_verify)?  Should we exclude the runtime & time_based settings from the
> validation/verification job?

If I had to guarantee at least one write pass was completed and one
verification pass was also completed then yes I'd ensure that runtime
and time_based were not set on that write job. runtime/time_based is
there so you can guarantee a job will run for given period of time
(and not dramatically more or less time).

> http://www.coderplay.org/filesysdev/FIO-Data-Integrity-Test.html
>
> "However, if the job file specifies to run based on time rather than total
> number of bytes (setting runtime=int and time_based), then do_verify() is
> not performed. "

This is correct and matches my previous warning. If you are asking for
*both runtime and time_based* and the verification job is a write one
then it won't stop writing until runtime is exceeded and at that point
there can't be any time left to do the verify. What are you trying to
achieve by setting runtime/time_based?

-- 
Sitsofe | http://sucs.org/~sits/
