Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:47938 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdJWS12 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Oct 2017 14:27:28 -0400
Received: by mail-ua0-f179.google.com with SMTP id e46so13606298uaa.4
        for <fio@vger.kernel.org>; Mon, 23 Oct 2017 11:27:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 23 Oct 2017 19:26:57 +0100
Message-ID: <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com>
Subject: Re: buffer-cache builds up with invalidate=1 too
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 23 October 2017 at 11:02, Paolo Valente <paolo.valente@linaro.org> wrote:
>
> in a time_based test with direct=0, a small file happened to be read several times. Yet I/O was actually done only when the file was read for the first time, even if invalidate was set.
>
> So, if I'm not mistaken, the buffer cache still builds up even if invalidate is set, right?

Correct - invalidate just invalidates the cache at the "beginning"
(see http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-invalidate
). See below where I agree with using your direct=1 suggestion if you
want to avoid the cache. See
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-direct
for documentation on direct.

> Then, in a time_based test, the only way to make sure that I/O is constantly done, is to use direct=1, isn't it? Of course, unless the file is so large that one knows that no portion of the file will be found in the buffer cache when read again.

If you mean "the only way for fio to try and avoid all I/O being
cached/being only serviced by Linux's buffer cache is to use direct=1"
then yes. Also as you suggest you can do I/O over a region big enough
that a significant amount of I/O must not be cacheable therefore the
average speed would better reflect that of the underlying disk (that's
why you hear the old bonnie benchmark rule that you had to use a file
size at least twice memory etc as it had no cache bypass mode). If you
do a lot of I/O to only a small region then this is clearly still
cachable though.

-- 
Sitsofe | http://sucs.org/~sits/
