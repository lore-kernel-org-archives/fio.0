Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35402 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932299AbdCaF6t (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 01:58:49 -0400
Received: by mail-vk0-f46.google.com with SMTP id r69so79582566vke.2
        for <fio@vger.kernel.org>; Thu, 30 Mar 2017 22:58:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
References: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Mar 2017 06:58:17 +0100
Message-ID: <CALjAwxgZx+QHcM74ERtj1zUZo1r+aCfgCP8wnhNicJ01b768FA@mail.gmail.com>
Subject: Re: numberio failure with numjobs=1
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Guruganesh Hegde <guruhegde4u@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 31 March 2017 at 03:25, Guruganesh Hegde <guruhegde4u@gmail.com> wrote:
>
> I am using fio version 2.12 and using following configuration to
> perform data integrity check
> --------------------------------------------------------------------
> [write-phase]
> group_reporting
> rw=randwrite
> bs=4k
> direct=1
> ioengine=libaio
>
> iodepth=32
> numjobs=1
>
> size=32G
> randseed=40964096
> verify=crc32c
>
> verify_dump=1
> refill_buffers
>
> filename=/dev/nvme0n1
>
> loops=10
> ----------------------------------------------------------------------------------
>
> What I am seeing is fio fails for numberio with mismatch.
> "verify: bad header numberio x wanted y"
>
> I have modified fio 'verify.c' to continue on numberio mismatch error.
> All other header checks like header crc & data crcs are verified.
>
> After the above changes fio reports only few numberio errors and there
> seem to no other data integrity error.
>
> Is there anything I am missing in fio configuration?

On first glance the config looks fine. refill_buffers is actually
automatically set when you set verify (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill-buffers
) so it's redundant but harmless and won't have anything to do with
the error you reported.

A few suggestions:
Can you reproduce the problem with the latest fio release (2.18)?
Can you make it happen with size=1G ? If so how about size=256M ?
How far does it get through the total I/O before the numberio problem
is shown (i.e. what output is displayed when failure occurs and fio
exits) and is it roughly the same amount each time?
Does everything else still verify when you use bsrange=4k-64k instead of bs=4k?

-- 
Sitsofe | http://sucs.org/~sits/
