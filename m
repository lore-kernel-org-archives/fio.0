Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35220 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752928AbdBDADt (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2017 19:03:49 -0500
Received: by mail-lf0-f48.google.com with SMTP id n124so18180322lfd.2
        for <fio@vger.kernel.org>; Fri, 03 Feb 2017 16:03:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgQVhaviwg0wEqsqqHCsyksf0ES+E6-S3ON7HhUMn17ng@mail.gmail.com>
References: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
 <CALjAwxgQVhaviwg0wEqsqqHCsyksf0ES+E6-S3ON7HhUMn17ng@mail.gmail.com>
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Fri, 3 Feb 2017 17:03:17 -0700
Message-ID: <CADAGN7UzGuCBbTs3URhqi6RiwNrOs-jLu0VtVRmT6nWvMnjPHg@mail.gmail.com>
Subject: Re: NCQ Priority Support and FIO
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks for the info, I'll play around with that option and see if I
can make that work.  Is there anything that would allow me to control
the amount of priority commands from within a single thread?

Regards,
Brandon

On Thu, Feb 2, 2017 at 3:36 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> Perhaps you could use multiple threads and utilise the flow
> (http://fio.readthedocs.io/en/sphinx-doc/fio_doc.html#cmdoption-arg-flow
> ) control on pairs of threads?
>
> On 2 February 2017 at 22:29, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>>
>> 60% RandomRead / 40% RandomWrite but of those reads, have 15% be high priority
>>
>> Or is there a way to get this sort of priority testing done with
>> current FIO?
>
> --
> Sitsofe | http://sucs.org/~sits/
