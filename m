Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <9e47c711-7101-85ad-3208-eb21dd0d12a9@kernel.dk>
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk> <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
 <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk> <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
 <CALjAwxiiuKXqd-YVWhdBoSuMvpVCFQt5BwjRdf-9RKGBxkV6fQ@mail.gmail.com>
 <5181032d-5f85-5b65-66c6-5621b1582323@kernel.dk> <9e47c711-7101-85ad-3208-eb21dd0d12a9@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 6 Mar 2018 18:45:56 +0000
Message-ID: <CALjAwxhCpSiW9dgKDEzworPFBz07bViCLLogYhqByUc4sWTtwQ@mail.gmail.com>
Subject: Re: memcpy test: results from adding sse and avx tests
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6 March 2018 at 17:02, Jens Axboe <axboe@kernel.dk> wrote:
> On 3/6/18 9:45 AM, Jens Axboe wrote:
>> On 3/6/18 9:43 AM, Sitsofe Wheeler wrote:
>>> On 6 March 2018 at 16:22, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> +##########################################
>>>> +# sse probe
>>>> +sse="no"
>>>> +cat > $TMPC << EOF
>>>> +#include <xmmintrin.h>
>>>> +#include <immintrin.h>
>>>> +int main(int argc, char **argv)
>>>> +{
>>>> +  __m128 val;
>>>> +  float const *src = NULL;
>>>> +  float *dst = NULL;
>>>> +  val = _mm_load_ps(src);
>>>> +  _mm_store_ps(dst, val);
>>>> +  return 0;
>>>> +}
>>>> +EOF
>>>> +if compile_prog "-msse" "" "sse"; then
>>>> +  sse="yes"
>>>> +fi
>>>> +print_config "SSE (compiler)" "$sse"
>>>
>>> According to https://stackoverflow.com/questions/28939652/how-to-detect-sse-sse2-avx-avx2-avx-512-avx-128-fma-kcvi-availability-at-compile/28939692#28939692
>>> in gcc and clang you can just check for the appropriate define (e.g.
>>> __SSE2__ ) if you're only interested in what's available at compile
>>> time...
>>
>> I never really trust that, since there are always cases where that
>> isn't true. A configure test with the meat of the code and types
>> is always going to be 100% reliable.

That does have the ring of truth about it...

> BTW, another (and probably more problematic) issue is that the
> compiler may well have support for sse/avx/avx512, while the
> machine it's run on does not. If we enable the instruction set
> based on that, we could be seeing illegal instructions outside
> just the memcpy test. And that would be a concern, since it would
> prevent fio from running at all.
>
> I think we have to make it something like the below because of that.

If someone forces SSE on then by all means we should add it to the
CFLAGS but if they haven't and we can compile a program which uses
headers/instructions that are only available when SSE is enabled then
can't we deduce that the user is happy for those instructions to be in
their code?

[...]
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

We could try and use __builtin_ia32_addps (from
https://gcc.gnu.org/onlinedocs/gcc/x86-Built-in-Functions.html#x86-Built-in-Functions
).

> +EOF
> +if test "$enable_sse" = "yes" && compile_prog "-msse" "" "sse"; then
> +  sse="yes"
> +fi
> +print_config "SSE (compiler)" "$sse"

Here we wouldn't explicitly add -msse because we would have already
added it to the global CFLAGS if forced or depended on the user's
particular compiler flags if not.

-- 
Sitsofe | http://sucs.org/~sits/

