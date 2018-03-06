Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk> <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
 <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk> <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 6 Mar 2018 16:43:57 +0000
Message-ID: <CALjAwxiiuKXqd-YVWhdBoSuMvpVCFQt5BwjRdf-9RKGBxkV6fQ@mail.gmail.com>
Subject: Re: memcpy test: results from adding sse and avx tests
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6 March 2018 at 16:22, Jens Axboe <axboe@kernel.dk> wrote:
>
> +##########################################
> +# sse probe
> +sse="no"
> +cat > $TMPC << EOF
> +#include <xmmintrin.h>
> +#include <immintrin.h>
> +int main(int argc, char **argv)
> +{
> +  __m128 val;
> +  float const *src = NULL;
> +  float *dst = NULL;
> +  val = _mm_load_ps(src);
> +  _mm_store_ps(dst, val);
> +  return 0;
> +}
> +EOF
> +if compile_prog "-msse" "" "sse"; then
> +  sse="yes"
> +fi
> +print_config "SSE (compiler)" "$sse"

According to https://stackoverflow.com/questions/28939652/how-to-detect-sse-sse2-avx-avx2-avx-512-avx-128-fma-kcvi-availability-at-compile/28939692#28939692
in gcc and clang you can just check for the appropriate define (e.g.
__SSE2__ ) if you're only interested in what's available at compile
time...

-- 
Sitsofe | http://sucs.org/~sits/

