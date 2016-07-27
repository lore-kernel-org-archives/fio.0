Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20160727143021.GB26856@kernel.dk>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com> <20160727143021.GB26856@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 27 Jul 2016 23:44:48 +0900
Message-ID: <CAHndrB=ZyCjzDxGO_YTsAHiuweWe6C0HWJgOkAEc2j-Gc36W-w@mail.gmail.com>
Subject: Re: [PATCH 01/15] Make return value type of fio_getaffinity() consistent
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you !

2016-07-27 23:30 GMT+09:00 Jens Axboe <axboe@kernel.dk>:
> On Wed, Jul 27 2016, Tomohiro Kusumi wrote:
>> Return type of fio_getaffinity() isn't consistent among supported OS.
>> Windows and DragonFlyBSD return void while FreeBSD version is int.
>> The default version for those that don't support is do{}while(0).
>>
>> Linux version is a macro for sched_getaffinity(2) which returns 0
>> on success and -1 otherwise, so others should basically follow that.
>>
>> Note that I haven't compiled this on Windows, but it shouldn't fail.
>
> Thanks, applied this and the rest, except for the one I commented on.
>
> --
> Jens Axboe
>

