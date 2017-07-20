Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:35779 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965050AbdGTVkT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2017 17:40:19 -0400
Received: by mail-ua0-f171.google.com with SMTP id d29so23386782uai.2
        for <fio@vger.kernel.org>; Thu, 20 Jul 2017 14:40:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABhOJBTsk9O4ENXxrJagA5BurXWFWQ4Xmue0Wcy4JD1xX-4KBg@mail.gmail.com>
References: <CABhOJBTsk9O4ENXxrJagA5BurXWFWQ4Xmue0Wcy4JD1xX-4KBg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 20 Jul 2017 22:39:47 +0100
Message-ID: <CALjAwxjqFJrG4qoQhO5cV_9c2ZZq9HB=RoTKe5A1-NEMbuNfng@mail.gmail.com>
Subject: Re: Random writes' bandwidth evolves differently for different disk's portion
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elhamer Oussama AbdelKHalek <abdelkhalekdev@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 20 July 2017 at 09:26, Elhamer Oussama AbdelKHalek
<abdelkhalekdev@gmail.com> wrote:
>
> I've tried to measure the evolution of the bandwidth in an NVMe disk
> when i write only a portion of the disk, so i wrote a simple script
> that basically do that:
>
> For write portion in {10,20...,100} %
> |- Write the entire disk with 1s;
> |- Write a portion% of the disk randomly using 128k bs; #using fio
> |- Log the bandwidth each 50s
> End for
> My fio file looks like this:
>
> [global]
> ioengine=libaio
> iodepth=256
> size=X%
> direct=1
> do_verify=0
> continue_on_error=all
> filename=/dev/nvme0n1
> randseed=1
> [write-job]
> rw=randwrite
> bs=128k
> Logically the bandwidth should start from the best bandwidth (for 128k
> block size), which is around 1.3 GiB/s for my NVMe, then gets down
> till the written portion is met.
> But this is not the case, the randwrites for 80%, 90% and 100% of the
> disk size start at a different bandwidth than the others!
>
> This chart shows the evolution of the bandwidth for each portion over the time:
> https://user-images.githubusercontent.com/2827220/28362904-97f53fdc-6c7e-11e7-80cd-df36ebbe748e.png
>
> If we have 10 identical cars with different fuel amount, shouldn't
> they all start at the same speed until the fuel is done !
> Does fio take into consideration how much he will write and limit the
> bandwidth?!
> Is this a normal fio functioning? Or am i missing something about how
> fio handles portion random writes?

You may be facing problems that stem from how SSDs work.

By operating over a small range you make it easier for the SSD to keep
pre-erased cells available. Essentially you are over-provisioning the
SSD by progressively less and less which makes it tougher and tougher
for it to maintain its highest speeds.

If you progressively tested bigger and bigger ranges you may have
"aged" the SSD after each test by essentially pre-conditioning it. If
you didn't somehow make enough pre-erased cells available after each
run (e.g. by secure erasing between runs) you would essentially be
hurting every future run as you increase the chances of running only
at garbage collection speeds.

See http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.1.pdf
for an exhaustive explanation about reliable SSD benchmarking.

-- 
Sitsofe | http://sucs.org/~sits/
