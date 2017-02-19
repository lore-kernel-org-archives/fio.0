Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a291dd06-c42e-45d4-e39a-a6da42d3250f@bluestop.org>
References: <20170219182223.120559-1-tkusumi@tuxera.com> <20170219182223.120559-5-tkusumi@tuxera.com>
 <a291dd06-c42e-45d4-e39a-a6da42d3250f@bluestop.org>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Sun, 19 Feb 2017 21:46:31 +0200
Message-ID: <CAHndrBnfHBQABYB5GYFmhECF-howSfo20UK2T1Shrt-0-Opc3w@mail.gmail.com>
Subject: Re: [PATCH 5/6] Silence Cygwin warning "'vsprintf_s' redeclared
 without dllimport..."
Content-Type: text/plain; charset=UTF-8
To: Rebecca Cran <rebecca@bluestop.org>
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>, Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Sure, I was wondering if there was a reason you left it.


2017-02-19 21:07 GMT+02:00 Rebecca Cran <rebecca@bluestop.org>:
> On 2/19/17 11:22 AM, Tomohiro Kusumi wrote:
>>
>> Silence a compiler warning which used to didn't show up with some
>> old version of Cygwin. ad9c0fbc in 2012 added this, but it seems
>> this prototype should have been declared by an appropriate header
>> that's already been included here, so drop this prototype.
>> It also sounds what this message means according to Google.
>
>
> Thanks, I've been meaning to make the same change.
>
> --
> Rebecca
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

