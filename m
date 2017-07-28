Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <507e8c4a-5611-0eb7-f0b0-8f8a5a0702c9@kernel.dk>
References: <20170727203837.97569-1-tkusumi@tuxera.com> <507e8c4a-5611-0eb7-f0b0-8f8a5a0702c9@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 28 Jul 2017 07:41:09 +0100
Message-ID: <CALjAwxhZgzQgTPt9ud7tHAzq0n4XdCD5eCFQzjpfoD-8KBe0JQ@mail.gmail.com>
Subject: Re: [PATCH] don't print native_fallocate() error if ENOSYS
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 27 July 2017 at 21:44, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/27/2017 02:38 PM, kusumi.tomohiro@gmail.com wrote:
>> From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
>>
>> log_err(ENOSYS) on native_fallocate() failure which was newly added
>> by 2c3e17be('filesetup: add native fallocate') should be silenced
>> or somehow be printed only once instead of being a per file message.
>>
>> This happens on a platform like FreeBSD where posix_fallocate(3)
>> exists, but native_fallocate() is ENOSYS.
>>
>> This commit just silences it if errno is set to ENOSYS on return.
>> "native" is the default mode, thus not printing ENOSYS won't be any
>> confusing unless fallocate=native is explicitly specified, and
>> native_fallocate() has dprint() for ENOSYS case anyway.
>
> I think that's the right fix, ENOSYS is expected for some setups,
> so it need not be a visible error.

I wonder if the default actually be set to "none" on all systems that
don't implement a native fallocate regardless of whether they
implement posix_fallocate?

-- 
Sitsofe | http://sucs.org/~sits/

