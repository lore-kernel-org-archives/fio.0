Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <MWHPR04MB03208D586D958B32CAC0AD678F690@MWHPR04MB0320.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB03208D586D958B32CAC0AD678F690@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 9 Feb 2019 06:38:51 +0000
Message-ID: <CALjAwxhNAOo75daBaqrpT5UEQbJs+7O78vy8ne+XoDF=tE1eXA@mail.gmail.com>
Subject: Re: [PATCH] client/server: inflate error handling
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Fri, 8 Feb 2019 at 21:44, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> Occasionally fio client/server with zlib enabled may report:
>
> fio: inflate error -5
> fio: failed decompressing log
> fio: failed converting IO log
>
[snip]
>
> The way we tell that deflate() has no more output is by seeing that it di=
d not fill the output buffer, leaving avail_out greater than zero. However =
suppose that deflate() has no more output, but just so happened to exactly =
fill the output buffer! avail_out is zero, and we can't tell that deflate()=
 has done all it can. As far as we know, deflate() has more output for us. =
So we call it again. But now deflate() produces no output at all, and avail=
_out remains unchanged as CHUNK. That deflate() call wasn't able to do anyt=
hing, either consume input or produce output, and so it returns Z_BUF_ERROR=
. (See, I told you I'd cover this later.) However this is not a problem at =
all. Now we finally have the desired indication that deflate() is really do=
ne, and so we drop out of the inner loop to provide more input to deflate()=
."

Wow. Does this fix the bug you found from a few years back:
https://www.spinics.net/lists/fio/msg05877.html ?

--
Sitsofe | http://sucs.org/~sits/

