Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:35208 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754340AbdGSVTL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2017 17:19:11 -0400
Received: by mail-ua0-f171.google.com with SMTP id 64so9339065uae.2
        for <fio@vger.kernel.org>; Wed, 19 Jul 2017 14:19:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <90DB9BC3-CC6B-4BFC-8FC6-F4685B07642F@linaro.org>
References: <787DD20D-DCFE-4E01-8F6E-A84853E89F12@linaro.org>
 <CALjAwxh-rE6vnRc8TsoOe0Sx8hFbSrhoHgXJa8WAYfLhjooECw@mail.gmail.com> <90DB9BC3-CC6B-4BFC-8FC6-F4685B07642F@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 19 Jul 2017 22:18:40 +0100
Message-ID: <CALjAwxgQzmBp_Pu5faRrX=8NQyRdKJjm1-FgsCHM0oKsHvo8iw@mail.gmail.com>
Subject: Re: random-time I/O with fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 19 July 2017 at 09:24, Paolo Valente <paolo.valente@linaro.org> wrote:
>
>> Il giorno 18 lug 2017, alle ore 22:22, Sitsofe Wheeler <sitsofe@gmail.com> ha scritto:
>>
>> On 18 July 2017 at 09:03, Paolo Valente <paolo.valente@linaro.org> wrote:
>>>
>>> by chance, is there a (possibly indirect) way to generate I/Os
>>> occurring at random times with fio?  Even a minimum variation with
>>> respect to periodic I/O, such as rate-limited I/O I guess, would be
>>> perfect.
>>
>> How about rate_process=poisson
>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rate-process
>> )?
>>
>
> That's exactly what I need!  I missed that parameter because I
> looked for a useful parameter with un-matching keywords.

Interesting - which keywords were you using?

-- 
Sitsofe | http://sucs.org/~sits/
