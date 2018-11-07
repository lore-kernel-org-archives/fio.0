Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f41.google.com ([209.85.222.41]:36451 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbeKHBPE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 20:15:04 -0500
Received: by mail-ua1-f41.google.com with SMTP id j3so3508450uap.3
        for <fio@vger.kernel.org>; Wed, 07 Nov 2018 07:44:11 -0800 (PST)
MIME-Version: 1.0
References: <CAFF4W0Vv3uqbXhfW4+jBHtvg+F2HGt_D78AXfiTN3ROpsg38_g@mail.gmail.com>
In-Reply-To: <CAFF4W0Vv3uqbXhfW4+jBHtvg+F2HGt_D78AXfiTN3ROpsg38_g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Nov 2018 15:43:45 +0000
Message-ID: <CALjAwxgcSO0BCei4LEXLunpQ+gCqL_1Q_wXtEYC_HvyiYbrS_w@mail.gmail.com>
Subject: Re: Understanding offset modifier
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 7 Nov 2018 at 11:31, Mohanraj B <bmohanraj91@gmail.com> wrote:
>
> Hello all,
>
>
> https://fio.readthedocs.io/en/latest/fio_man.html#i-o-type
>
> what is offset modifier, some please explain.
> It is possible to specify the number of I/Os to do before getting a
> new offset by appending :<nr> to the end of the string given.

I guess you mean mean the rw <nr> parameter in the final paragraph in
https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-readwrite
. Can you say what part of that paragraph and the rw_sequencer section
you are struggling to understand and did you work through the
randread:8 and rw=write:4k examples?

-- 
Sitsofe | http://sucs.org/~sits/

