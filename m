Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <bcf4ea16-f7a0-8a8b-e04c-7a7d4f90e03a@kernel.dk>
References: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com> <bcf4ea16-f7a0-8a8b-e04c-7a7d4f90e03a@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Sat, 30 Jul 2016 00:40:44 +0900
Message-ID: <CAHndrB=jDwwQT5zq9CJb+_gjML4pbib2r74he4f4CmV4f_oKbg@mail.gmail.com>
Subject: Re: [PATCH 1/4] Use in-place path separator "/" for Linux specific code
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you !

2016-07-30 0:02 GMT+09:00 Jens Axboe <axboe@kernel.dk>:
> On 07/29/2016 09:05 AM, Tomohiro Kusumi wrote:
>>
>> diskutil,cgroup,blktrace related code fully depend on Linux kernel,
>> so sprintf variants can use in-place path separator "/" instead of
>> FIO_OS_PATH_SEPARATOR.
>>
>> In fact these Linux specific files are mix of two types within the
>> same file depending on who wrote them, where they were originally
>> using "/".
>
>
> Thanks, applied this and the other 3.
>
> --
> Jens Axboe
>

