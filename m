Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20160719214726.GA27019@kernel.dk>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com> <20160719214726.GA27019@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 20 Jul 2016 07:20:27 +0900
Message-ID: <CAHndrB=rGmkrur3Z24nVyN9r9TyORwxowkix=tH5FLv5uXDOxw@mail.gmail.com>
Subject: Re: [PATCH 1/7] Fix wrong cpuio option name in documentation
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you.

I've just sent another one, which adds missing
+#include "./os-linux-syscall.h"
in Android header in 1c764dbe.

Sorry about that.


2016-07-20 6:47 GMT+09:00 Jens Axboe <axboe@kernel.dk>:
> On Wed, Jul 20 2016, Tomohiro Kusumi wrote:
>> The name of an option for cpuio engine is "cpuchunks",
>> though the code internally uses "cpucycle" for variables.
>>
>> (If the option name "cpuchunks" is the incorrect one,
>> I'll resubmit a patch that corrects the option name)
>
> Thanks, applied all 7 patches.
>
> --
> Jens Axboe
>

