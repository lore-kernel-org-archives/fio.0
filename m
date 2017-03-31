Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:34392 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdCaGMA (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 02:12:00 -0400
Received: by mail-vk0-f45.google.com with SMTP id z204so80016457vkd.1
        for <fio@vger.kernel.org>; Thu, 30 Mar 2017 23:11:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACqzM2AmmgacpGd+QVt42=SdqQrDENigb7TUs-x50iuD9KWt6Q@mail.gmail.com>
References: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
 <CALjAwxgZx+QHcM74ERtj1zUZo1r+aCfgCP8wnhNicJ01b768FA@mail.gmail.com> <CACqzM2AmmgacpGd+QVt42=SdqQrDENigb7TUs-x50iuD9KWt6Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Mar 2017 07:11:28 +0100
Message-ID: <CALjAwxiHDO0AwQWNYR4J_TL821hhbjn6J0Arm5p73t5dZotV3w@mail.gmail.com>
Subject: Re: numberio failure with numjobs=1
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Guruganesh Hegde <guruhegde4u@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

(Please use reply to all so mails continue going to the mailing list)

On 31 March 2017 at 07:05, Guruganesh Hegde <guruhegde4u@gmail.com> wrote:
> Thanks for the suggestions.
>
> I will tryout suggested tests and share the observations.
>
> The device which I am using is supporting only 4k block size, I will
> not be able to try different block sizes, however I will try with
> different sizes(1G or 256M etc).

Bigger blocks that are still a multiple of 4Kbytes should work
though... Further by default bsrange will only picks block sizes that
are multiples of the minimum specified blocksize so bsrange=4k-64k
should pick 4k, 8k, 16k, 32k, 64k (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-blocksize-range
). Is that clearer?

-- 
Sitsofe | http://sucs.org/~sits/
