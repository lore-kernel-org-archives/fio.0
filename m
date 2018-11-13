Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f48.google.com ([209.85.166.48]:32841 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbeKMLPv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Nov 2018 06:15:51 -0500
Received: by mail-io1-f48.google.com with SMTP id f12-v6so7687190iog.0
        for <fio@vger.kernel.org>; Mon, 12 Nov 2018 17:20:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgcSO0BCei4LEXLunpQ+gCqL_1Q_wXtEYC_HvyiYbrS_w@mail.gmail.com>
References: <CAFF4W0Vv3uqbXhfW4+jBHtvg+F2HGt_D78AXfiTN3ROpsg38_g@mail.gmail.com>
 <CALjAwxgcSO0BCei4LEXLunpQ+gCqL_1Q_wXtEYC_HvyiYbrS_w@mail.gmail.com>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Tue, 13 Nov 2018 06:50:07 +0530
Message-ID: <CAFF4W0UyzTe5BgFM-T97oHwmBPJ-_C_nZVFiYYrBfJS-m7EM=A@mail.gmail.com>
Subject: Re: Understanding offset modifier
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

Thanks for the response.

I have gone through and worked out the example.
Below are my queries:
what is offset?
How to verify the results if used the :<nr> at the end of the string ?

Thanks and Regards,
Mohan

On 11/7/18, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On Wed, 7 Nov 2018 at 11:31, Mohanraj B <bmohanraj91@gmail.com> wrote:
>>
>> Hello all,
>>
>>
>> https://fio.readthedocs.io/en/latest/fio_man.html#i-o-type
>>
>> what is offset modifier, some please explain.
>> It is possible to specify the number of I/Os to do before getting a
>> new offset by appending :<nr> to the end of the string given.
>
> I guess you mean mean the rw <nr> parameter in the final paragraph in
> https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-readwrite
> . Can you say what part of that paragraph and the rw_sequencer section
> you are struggling to understand and did you work through the
> randread:8 and rw=write:4k examples?
>
> --
> Sitsofe | http://sucs.org/~sits/
>

