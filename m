Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxjdCPxAC0R7z8Ss4cRe_pTn92-eW6E0TiuMSi_2JhKFFg@mail.gmail.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com> <20170501184820.31025-3-tkusumi@tuxera.com>
 <CALjAwxjdCPxAC0R7z8Ss4cRe_pTn92-eW6E0TiuMSi_2JhKFFg@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 2 May 2017 08:58:46 +0300
Message-ID: <CAHndrBm2dU+p0=OUGYzjBnDwT44g7Gt1wQz3yOps0umBaNpsFA@mail.gmail.com>
Subject: Re: [PATCH 03/11] configure: Use single square brackets (POSIX)
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Feel free to send those including my 03/11 if they are bash things.
I happened to just find [[...]] one without using tools.

There was one remove-bash-ism commit in the past too (40cfddb4 in 2010).

2017-05-02 8:36 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> On 1 May 2017 at 19:48,  <kusumi.tomohiro@gmail.com> wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> Avoid "if [[...]]" format which seems to be bash extension.
>
> According to http://www.shellcheck.net/ , ./configure has a few other
> bashims in it:
>
> Line 16:
> TMPC="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.c"
>                                        ^-- SC2039: In POSIX sh, RANDOM
> is undefined.
>
> Line 17:
> TMPO="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.o"
>                           ^-- SC2039: In POSIX sh, RANDOM is undefined.
>                                        ^-- SC2039: In POSIX sh, RANDOM
> is undefined.
>
> Line 18:
> TMPE="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.exe"
>                                        ^-- SC2039: In POSIX sh, RANDOM
> is undefined.
>                           ^-- SC2039: In POSIX sh, RANDOM is undefined.
>
> Line 109:
>   type "$1" >/dev/null 2>&1
>   ^-- SC2039: In POSIX sh, 'type' is undefined.
>
> Line 1685:
>   if [[ $? -eq 0 ]]; then
>      ^-- SC2039: In POSIX sh, [[ ]] is undefined.
>         ^-- SC2181: Check exit code directly with e.g. 'if mycmd;',
> not indirectly with $?.
>
> --
> Sitsofe | http://sucs.org/~sits/

