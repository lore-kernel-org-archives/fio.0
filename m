Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20170214152348.GA32572@kernel.dk>
References: <20170214151948.16460-1-tkusumi@tuxera.com> <20170214151948.16460-7-tkusumi@tuxera.com>
 <20170214152348.GA32572@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 14 Feb 2017 17:27:32 +0200
Message-ID: <CAHndrBniGbuEmgZHzn6Ppn-qQqrpDd1rgnHy0Y-+UJsHJONBzw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] Acquire file ->lock while the lock itself is being copied
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

I couldn't see a race too, but assumed there is since you (the author) say so.
For the other one in dup_files(), I didn't think there's any race as commented.

But yes, if there's no race, please drop this.

2017-02-14 17:23 GMT+02:00 Jens Axboe <axboe@kernel.dk>:
> On Tue, Feb 14 2017, kusumi.tomohiro@gmail.com wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> to the destination file pointer.
>> The ones in dup_files() doesn't seem to require locking from
>> the way it's been called.
>
> I've been thinking about this a little bit, since I could not see what
> the race was. Do you spot one, or are you just acting on the comment?
> I think the original race was that we copied over the lock, lock owner,
> batch, etc. Hence the race was that if someone else grabbed the lock
> while we were doing that copy, the fields weren't in a consistent state.
> But now we're just copying the pointer to the lock, so I don't think
> there's a race. It's just a stale comment.
>
> --
> Jens Axboe
>

