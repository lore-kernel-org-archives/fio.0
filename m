Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33838 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754300AbdIRSd4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 14:33:56 -0400
Received: by mail-io0-f193.google.com with SMTP id g32so2021216ioj.1
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 11:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a2df534e-1ba1-27e4-7467-8be21271d838@kernel.dk>
References: <20170918182355.45590-1-tkusumi@tuxera.com> <20170918182355.45590-3-tkusumi@tuxera.com>
 <a2df534e-1ba1-27e4-7467-8be21271d838@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 18 Sep 2017 21:33:15 +0300
Message-ID: <CAHndrBn-d28aSOhE+=2uaHy4B1pF=WFkqfJtFo+a+i=r7uQRAA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] add fio_set_directio() error message for platforms
 without direct I/O
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>

Right..
Sorry, I just reused the message right above which originates
42f1ee68ceec87fbbfdc4972c35d3cdf7c08d9f6 ("Improve informativeness
about directIO support or rather lackthereof on Solaris when errno is
set to ENOTTY").

I'll send v3.

2017-09-18 21:26 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
> On 09/18/2017 12:23 PM, kusumi.tomohiro@gmail.com wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> This lets platforms without dio (e.g. OpenBSD) fail with an explicit
>> message, otherwise they fail without a clue about dio even with
>> --debug=all enabled.
>>
>> The message assumes platforms with O_DIRECT do not call this function
>> (and in fact they don't so it's not really a problem).
>>
>> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
>> ---
>>  filesetup.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/filesetup.c b/filesetup.c
>> index b51ab35..9813873 100644
>> --- a/filesetup.c
>> +++ b/filesetup.c
>> @@ -1868,6 +1868,7 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
>>
>>       return 0;
>>  #else
>> +     log_err("fio: the file system does not seem to support direct IO\n");
>
> Should have caught this the first time, sorry... But that should say "the operating
> system", it's not a file system condition. I'd use something ala:
>
> fio: direct IO is not supported on this host operating system
>
> since it is possible that the OS does in fact support some variant of direct
> IO, but fio doesn't support it on that platform.
>
> --
> Jens Axboe
>
