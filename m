Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:44433 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaIUKVx (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 21 Sep 2014 06:21:53 -0400
Received: by mail-la0-f54.google.com with SMTP id ge10so5264272lab.13
        for <fio@vger.kernel.org>; Sun, 21 Sep 2014 03:21:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <541E4CA6.8070705@gmail.com>
References: <541E4CA6.8070705@gmail.com>
Date: Sun, 21 Sep 2014 11:21:50 +0100
Message-ID: <CALjAwxgOu+iFoGiexcxBLL-DwKL0wiqyRCK6t8S2qQsyB3DA6A@mail.gmail.com>
Subject: Re: [Question] What if the parameter for --size option is smaller
 than the target device?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 21 September 2014 04:57, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> I am writing a test with fio tool (2.0.8) and I am facing a problem.
>
> I just want to submit 512B random write to a block device.
> In my case, the size of the device is 2MB and the amount of writes (specified by --size option) is 32MB.

You probably wanted the behaviour of io_limit
(http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=73e58ff695c3384df30094d6c15ebe9ed615460f;hb=HEAD#l433
) rather than size...

> like this (A line from device-mapper-test-suite. Is my command wrong?):
>       ProcessControl.run("fio --name=test --filename=#{dev.path} --rw=randwrite --ioengine=libaio --direct=1 --size=#{@param[0]}m --bs=512")
>
> The problem is, the runtime is too short.
> The block device is just a single HDD so, it will be 30sec or so. But it's actually 3sec...
>
> My guess is that fio uses min(device size, param to --size) as the amount of writes here.

That's correct in this context - size is limiting the last possible
block that can be written to (see
http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=73e58ff695c3384df30094d6c15ebe9ed615460f;hb=HEAD#l421
for details).

> To investigate it, I increased the size of the device to x10 and saw the runtime gets x10.
>
> My questions are:
> 1. Is my guess correct?

Yes.

> 2. What shall I do to make fio work as I want it to do?

Use io_limit if your fio is new enough or number_ios
(http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=73e58ff695c3384df30094d6c15ebe9ed615460f;hb=HEAD#l778
).

Sitsofe | http://sucs.org/~sits/
