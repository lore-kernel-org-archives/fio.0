Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40252 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaIWOFh (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Sep 2014 10:05:37 -0400
Received: by mail-lb0-f180.google.com with SMTP id b12so8820684lbj.11
        for <fio@vger.kernel.org>; Tue, 23 Sep 2014 07:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <542179FA.5040106@gmail.com>
References: <542179FA.5040106@gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 23 Sep 2014 18:05:15 +0400
Message-ID: <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
Subject: Re: [Question] How to perform stride access?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: fio@vger.kernel.org

Offset modifier under rw= should do the trick, consult
https://github.com/axboe/fio/blob/master/HOWTO for details.

Best regards,
Andrey
Regards,
Andrey


On Tue, Sep 23, 2014 at 5:47 PM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> Hi,
>
> I want to perform stride write access to a block device but
> I don't have a clue how I can do that.
>
> What I want to do is to perform a stride access that
> each write size is 1 sector and 7 sectors are apart between each writes.
> (i.e. Only the first sector of each 4KB block)
>
> For example,
> 0, 8, 16, 24, 32, ...
>
> And, it repeat over the device until certain amount of writes are accomplished.
> In my case, amount of 32MB to 508KB device.
>
> I consider the command below works like as I want but it doesn't actually.
> Instead, it looks performing ordinary 512KB seq write.
> fio --name=test --filename=#{dev.path} --rw=write --ioengine=libaio --direct=1 --io_limit=32M --size=100% --ba=4k --bs=512
>
> My questions are:
> 1) How to perform stride write access in fio?
> 2) If fio is not a appropriate tool for this purpose, easy to fix?
>    Or do you recommend other tool?
>
> - Akira
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
