Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f52.google.com ([209.85.217.52]:44030 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbeK0JWp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Nov 2018 04:22:45 -0500
Received: by mail-vs1-f52.google.com with SMTP id x1so12446652vsc.10
        for <fio@vger.kernel.org>; Mon, 26 Nov 2018 14:27:08 -0800 (PST)
MIME-Version: 1.0
References: <CAHfRdgfCMsZWB7r=NfANSXnz7kHQY4dTsnGYvZoWPkBG_XfnWw@mail.gmail.com>
In-Reply-To: <CAHfRdgfCMsZWB7r=NfANSXnz7kHQY4dTsnGYvZoWPkBG_XfnWw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 26 Nov 2018 22:26:47 +0000
Message-ID: <CALjAwxhFac8VuZ2vhyW0Qoevy2s_AjAOa8UhEki1P4TZAi9rLA@mail.gmail.com>
Subject: Re: How to set up fio working with multiple files simultaneously?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: yijiezhong12@gmail.com
Cc: fio <fio@vger.kernel.org>

Hi,

On Mon, 26 Nov 2018 at 15:22, Yijie Zhong <yijiezhong12@gmail.com> wrote:
>
> I have learned that glibc emulate POSIX AIO via thread pool on Linux
> and only one thread would service for one open file
> (https://github.com/bminor/glibc/blob/glibc-2.28/sysdeps/pthread/aio_misc.c#L359).
>
> I want to use fio to validate it, so I want to know how to set up fio
> working with multiple files simultaneously?

I'm not too sure on this one. You could ask fio to use multiple
threads/processes itself via things like numjobs bigger than 1 (and
then you could put the iodepth down) and hope round robin sends each
I/O to a different file but perhaps this is not what you're after. I
suppose the other thing to try is having as many files as your iodepth
but the big snag is this I/O is going to start looking more random
rather than sequential the more files you use. You might just be
hitting a Linux glibc POSIX AIO weakness...

-- 
Sitsofe | http://sucs.org/~sits/

