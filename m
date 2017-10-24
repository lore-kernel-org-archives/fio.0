Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:49765 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdJXG2q (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Oct 2017 02:28:46 -0400
Received: by mail-ua0-f170.google.com with SMTP id h34so14643313uaa.6
        for <fio@vger.kernel.org>; Mon, 23 Oct 2017 23:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
 <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com> <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 24 Oct 2017 07:28:15 +0100
Message-ID: <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com>
Subject: Re: buffer-cache builds up with invalidate=1 too
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

If memory serves it's actually slightly more complicated. If you are
using loops=<number> then I *think* (you'll have to check) you will
find that invalidation happens once per each loop start. However when
you use time_based to do the repetition there is essentially only one
"loop" (even though the job goes on forever) so loop actions only
happen right at the start of the job with that option (that's why I
put the scare quotes around "beginning" ;-).

On 24 October 2017 at 04:23, Paolo Valente <paolo.valente@linaro.org> wrote:
>
> thank you very much for answering this and my other question
> thoroughly!
>
> Maybe I would specify, in the description of invalidate, that the
> invalidation is not repeated in case the I/O on a file restarts from
> the beginning go the file.

-- 
Sitsofe | http://sucs.org/~sits/
