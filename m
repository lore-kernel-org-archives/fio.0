Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20170607235336.48859-1-daniel.verkamp@intel.com>
References: <20170607235336.48859-1-daniel.verkamp@intel.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Jun 2017 06:17:51 +0100
Message-ID: <CALjAwxjj9BbH-p1m4R+x6LE94zcDrY_Enxie=90n=LZ3R0wo3g@mail.gmail.com>
Subject: Re: [PATCH] lib/ffz: remove dead store
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Verkamp <daniel.verkamp@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8 June 2017 at 00:53, Daniel Verkamp <daniel.verkamp@intel.com> wrote:
> 'word' is written in the last 'if' block but never read again.
>
> This is harmless, but scan-build (clang-analyzer) flags it as a warning.
>
> Signed-off-by: Daniel Verkamp <daniel.verkamp@intel.com>
> ---
>  lib/ffz.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/lib/ffz.h b/lib/ffz.h
> index e2c1b8e..b98dad6 100644
> --- a/lib/ffz.h
> +++ b/lib/ffz.h
> @@ -28,7 +28,6 @@ static inline int ffs64(uint64_t word)
>                 r += 2;
>         }
>         if (!(word & 1)) {
> -               word >>= 1;
>                 r += 1;
>         }
>
> --
> 2.9.4

Any thoughts on this one Jens (just checking it didn't slip through the net)?

-- 
Sitsofe | http://sucs.org/~sits/

