Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33147 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753709AbdBDHhl (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Feb 2017 02:37:41 -0500
Received: by mail-ua0-f174.google.com with SMTP id i68so29648489uad.0
        for <fio@vger.kernel.org>; Fri, 03 Feb 2017 23:37:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADAGN7UzGuCBbTs3URhqi6RiwNrOs-jLu0VtVRmT6nWvMnjPHg@mail.gmail.com>
References: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
 <CALjAwxgQVhaviwg0wEqsqqHCsyksf0ES+E6-S3ON7HhUMn17ng@mail.gmail.com> <CADAGN7UzGuCBbTs3URhqi6RiwNrOs-jLu0VtVRmT6nWvMnjPHg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 4 Feb 2017 07:37:09 +0000
Message-ID: <CALjAwxjv2LXhnBEXn5R3pw2KfapvEu7FKojbjxWKhBUMJJEPhg@mail.gmail.com>
Subject: Re: NCQ Priority Support and FIO
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brandon Schwartz <schwartz.xn@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I can't think of anything if you mean "I want the same thread/single
job to send both normal AND high priority commands" so perhaps it
would have to be done as new patch to the pvsync2 ioengine...

On 4 February 2017 at 00:03, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
> Thanks for the info, I'll play around with that option and see if I
> can make that work.  Is there anything that would allow me to control
> the amount of priority commands from within a single thread?
>
> Regards,
> Brandon
>
> On Thu, Feb 2, 2017 at 3:36 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hi,
>>
>> Perhaps you could use multiple threads and utilise the flow
>> (http://fio.readthedocs.io/en/sphinx-doc/fio_doc.html#cmdoption-arg-flow
>> ) control on pairs of threads?
>>
>> On 2 February 2017 at 22:29, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>>>
>>> 60% RandomRead / 40% RandomWrite but of those reads, have 15% be high priority
>>>
>>> Or is there a way to get this sort of priority testing done with
>>> current FIO?
>>
>> --
>> Sitsofe | http://sucs.org/~sits/



-- 
Sitsofe | http://sucs.org/~sits/
