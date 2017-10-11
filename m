Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20171010212710.12526-1-andrzej.jakowski@intel.com>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 11 Oct 2017 23:18:51 +0100
Message-ID: <CALjAwxhFr84M6p3SUmJuu8novyP+Wq7fiyPrTd=qGn4ubHwC1w@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-ID: <fio@vger.kernel.org>

Hi Jens,

On 10 October 2017 at 22:27, Andrzej Jakowski
<andrzej.jakowski@intel.com> wrote:
> This patch fixes percentile calculation for Windows where overflow
> on 32 bit type happened while calculating actual percentiles.
>
> Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
> ---
>  stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/stat.c b/stat.c
> index c5a68ad5..5c758680 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -139,7 +139,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
>                                    fio_fp64_t *plist, unsigned long long **output,
>                                    unsigned long long *maxv, unsigned long long *minv)
>  {
> -       unsigned long sum = 0;
> +       unsigned long long sum = 0;
>         unsigned int len, i, j = 0;
>         unsigned int oval_len = 0;
>         unsigned long long *ovals = NULL;
> --
> 2.13.6

Just in case you didn't see it, the above looks sensible/necessary...

-- 
Sitsofe | http://sucs.org/~sits/

