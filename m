Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:39716 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeC1QSR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Mar 2018 12:18:17 -0400
Received: by mail-vk0-f54.google.com with SMTP id n124so1715556vkd.6
        for <fio@vger.kernel.org>; Wed, 28 Mar 2018 09:18:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e2032302-c19a-0e4a-2a44-ecb03807b7e7@redhat.com>
References: <e2032302-c19a-0e4a-2a44-ecb03807b7e7@redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 28 Mar 2018 17:17:46 +0100
Message-ID: <CALjAwxiaPJ5aY5qLew_e=q9XkY5U0KVJQaEYf5Wzat9yRg65VQ@mail.gmail.com>
Subject: Re: Status of python3 for fio?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 28 March 2018 at 16:45, Eric Sandeen <sandeen@redhat.com> wrote:
> Fedora is moving more and more towards python3.  (TBH, as a non-python
> expert, I don't know all the details...)
>
> I see that python2.7 is hardcoded in several scripts, and Jens though
> there were possibly some patches "floating out there" to switch
> the various scripts to python3.  Does anyone know the status of
> this work?

fiologparser_hist.py was made Python 3 compatible but it's unknown
whether all the other scripts are as ready (I'm going to guess no). The
hope is that eventually all scripts will be made Python 3 ready but it
will be up to distros to rename the interpreter to use to one they
like at packaging time because it's impossible to satisfy all distros
with a single interpreter line...

You can see the rationale behind the python2.7 rename here:
https://github.com/axboe/fio/commit/60023ade47e7817db1c18d9b7e511839de5c2c99
and here: https://www.spinics.net/lists/fio/msg06746.html (and a
followup here
https://www.spinics.net/lists/fio/msg06748.html ).

-- 
Sitsofe | http://sucs.org/~sits/
