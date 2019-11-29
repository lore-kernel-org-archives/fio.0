Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44194 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfK2Hyj (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Nov 2019 02:54:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so33786313wrn.11
        for <fio@vger.kernel.org>; Thu, 28 Nov 2019 23:54:38 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV4x7Re+sa1AADW00j0nR0C7+PUXr8gh7vby4d2h084KjQ@mail.gmail.com>
In-Reply-To: <CAHEKYV4x7Re+sa1AADW00j0nR0C7+PUXr8gh7vby4d2h084KjQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 29 Nov 2019 07:54:21 +0000
Message-ID: <CALjAwxiRRM2sJ7s_Ej0ZShfO1JcA774ZnDNCw1mF4A9txVMcCw@mail.gmail.com>
Subject: Re: rwmixread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mauricio Tavares <raubvogel@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 27 Nov 2019 at 17:18, Mauricio Tavares <raubvogel@gmail.com> wrote:
>
> On some articles which use fio, I see the following entry in the config file:
>
> rwmixread={100, 70, 0}
>
> Is that a valid entry or just a shorthand to say 3 runs each of them
> using one of the percentage values?

I'm afraid the answer is no - that's invalid in standard fio because
`rwmixread` only takes a single int (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rwmixread
) and has nothing to do with successive runs. I've found the document
you're referring to and they use that syntax in lots of different
places so I wonder if they are using it to mean "we manually tried
this set of parameters" or are using a customised version of fio that
does some sort of preprocessing beyond regular fio.

A brief reminder to anyone reading: if you're publishing results don't
forget to abide by fio's MORAL-LICENSE
(https://github.com/axboe/fio/blob/master/MORAL-LICENSE ) as things
like version number or whether your fio is custom fork can help others
understand how to reproduce your results.

-- 
Sitsofe | http://sucs.org/~sits/

