Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20170501184820.31025-3-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com> <20170501184820.31025-3-tkusumi@tuxera.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 2 May 2017 06:36:46 +0100
Message-ID: <CALjAwxjdCPxAC0R7z8Ss4cRe_pTn92-eW6E0TiuMSi_2JhKFFg@mail.gmail.com>
Subject: Re: [PATCH 03/11] configure: Use single square brackets (POSIX)
Content-Type: text/plain; charset=UTF-8
To: kusumi.tomohiro@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 1 May 2017 at 19:48,  <kusumi.tomohiro@gmail.com> wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>
> Avoid "if [[...]]" format which seems to be bash extension.

According to http://www.shellcheck.net/ , ./configure has a few other
bashims in it:

Line 16:
TMPC="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.c"
                                       ^-- SC2039: In POSIX sh, RANDOM
is undefined.

Line 17:
TMPO="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.o"
                          ^-- SC2039: In POSIX sh, RANDOM is undefined.
                                       ^-- SC2039: In POSIX sh, RANDOM
is undefined.

Line 18:
TMPE="${TMPDIR1}/fio-conf-${RANDOM}-$$-${RANDOM}.exe"
                                       ^-- SC2039: In POSIX sh, RANDOM
is undefined.
                          ^-- SC2039: In POSIX sh, RANDOM is undefined.

Line 109:
  type "$1" >/dev/null 2>&1
  ^-- SC2039: In POSIX sh, 'type' is undefined.

Line 1685:
  if [[ $? -eq 0 ]]; then
     ^-- SC2039: In POSIX sh, [[ ]] is undefined.
        ^-- SC2181: Check exit code directly with e.g. 'if mycmd;',
not indirectly with $?.

-- 
Sitsofe | http://sucs.org/~sits/

