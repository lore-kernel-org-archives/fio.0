Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:36195 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752606AbdFWWZB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Jun 2017 18:25:01 -0400
Received: by mail-ot0-f170.google.com with SMTP id 95so40342656ott.3
        for <fio@vger.kernel.org>; Fri, 23 Jun 2017 15:25:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9cca62e1-d3c1-8112-9bea-58ece11bcd2d@kernel.dk>
References: <20170623220801.38178-1-tkusumi@tuxera.com> <20170623220801.38178-2-tkusumi@tuxera.com>
 <9cca62e1-d3c1-8112-9bea-58ece11bcd2d@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Sat, 24 Jun 2017 01:24:20 +0300
Message-ID: <CAHndrBk63C9wwT3GsE2+3-Yjrf2MWjW0V7TFtGLy_7+QFRKkAg@mail.gmail.com>
Subject: Re: [PATCH 1/8] ignore directory= if the given path is absolute
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>

Yes, it's a contrived and minor thing anyway.
I happened to hit this error for having directory=. option left when
filename=/path/to/file was used.


2017-06-24 1:16 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
> On 06/23/2017 04:07 PM, kusumi.tomohiro@gmail.com wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> When filename= is specified in absolute path format (starts with '/'),
>> being able to use directory= doesn't make much sense and also likely
>> to result in an unexpected error, thus it should be ignored if any.
>>
>> (If combining directory= and absolute filename= is a feature rather
>> than unexpected, then it should be documented, since it works as long
>> as directory/filename doesn't contain invalid directory. For example,
>> directory=. and filename=/tmp/xxx work as ./tmp/xxx if ./tmp exists
>> as shown in below.)
>>
>> Not sure about the proper way to handle this on Windows, so I had to
>> add WIN32 guard.
>
> Honestly, I'd rather just keep it as a strict concatenation of
> directory+filename. People could have valid jobs or scripts that
> already do variants of
>
> directory=/some_dir
> filename=/file_in_some_dir
>
> and it works fine. Your example above is a bit contrived, in my
> opinion. If anything, we should improve the error so it shows
> the file name fio attempted to use.
>
> --
> Jens Axboe
>
