Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <2aebbd38-2c87-a88c-0b28-23d4d72c33cb@bluestop.org>
References: <2aebbd38-2c87-a88c-0b28-23d4d72c33cb@bluestop.org>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Sun, 8 Apr 2018 20:35:40 +0900
Message-ID: <CAHndrB=PknOUTuU9NjzvtVCxX8=r+ibkF4tzhME-gOiVYtvG-w@mail.gmail.com>
Subject: Re: Results from clang 7.0 analyzer (scan-build)
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

2018-04-08 8:58 GMT+09:00 Rebecca Cran <rebecca@bluestop.org>:
> I ran clang 7.0's analyzer scan-build on a checkout of fio from a few days
> ago (rev 196ce5d5ff76af30cf93fd24240f12d8c4d24381, Tue Apr 3).
>
>
> I've uploaded the results to
> https://bluestop.org/scan-build-2018-04-07-171241-24360-1/ in case anyone
> wants to take a look to see if it has found any real bugs.

This isn't in the list, but strlcat() in ./oslib/strlcat.c also has
a corner case bug which leads to buffer overrun, though fio won't
encounter that bug from the way it uses strlcat().

Fixing it is as easy as replacing strlcat() with the correct one
from some libc with strlcat(3).

However, I wonder if fio even needs its own strlcat(). This was
added for sg ioengine and has only been used by sg ioengine.
The destination buffer is large enough that using strcat(3)
(or misusing strncat(3)) won't do any real harm. It's not that the
existing other code are incorrectly using strcat(3) or strncat(3)
either.

>
>
> --
> Rebecca
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

