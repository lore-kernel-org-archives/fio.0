Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36414 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdGYSfI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Jul 2017 14:35:08 -0400
Received: by mail-vk0-f49.google.com with SMTP id y70so11740079vky.3
        for <fio@vger.kernel.org>; Tue, 25 Jul 2017 11:35:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4b0decdf-1615-cf2b-1305-d55630bef9f0@bluestop.org>
References: <CAHndrBkV55xWU0yioqqYARdE3SzVpjxxnp9e8qoxxF+-Y_5F+A@mail.gmail.com>
 <4b0decdf-1615-cf2b-1305-d55630bef9f0@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 25 Jul 2017 19:34:37 +0100
Message-ID: <CALjAwxja=iG12B1drf7zaxb7z7M25XBTrume4PXXEbLy5DqWOA@mail.gmail.com>
Subject: Re: The commit 'filesetup: add native fallocate' breaks on Cygwin
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 25 July 2017 at 16:29, Rebecca Cran <rebecca@bluestop.org> wrote:
> On 7/25/2017 1:16 AM, Tomohiro Kusumi wrote:
>>
>> It seems the recent commit 2c3e17be ('filesetup: add native
>> fallocate') breaks on Cygwin.
>> It works on FreeBSD by the way.
>
>
> I see the problem: FIO_FALLOCATE_NONE has a value of 1, so in fallocate_file
> the 0 which is produced for platforms like Windows that don't support
> fallocate fall through to the default case, which asserts. I'm not sure if
> we want to renumber the fio_fallocate_mode enum to start at 0?

Sigh, that was my mistake - I never ran fio on a Windows filesystem
(only ioengine=null) to notice this and I guess every other platform I
tried had at least posix_fallocate.

I suppose other options are:
* Just put back (modified) #ifdef guards back in around the whole case
statement: https://github.com/axboe/fio/commit/2c3e17be4c7c9a737317ada414b98929652fec15#diff-4abbf037246dd2e450dc3f6a2ac77180L48
* Add a case 0: /* fallocate N/A */ just above case FIO_FALLOCATE_NONE:

-- 
Sitsofe | http://sucs.org/~sits/
