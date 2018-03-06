Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test: results from adding sse and avx tests
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
 <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
 <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk>
 <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
 <CALjAwxiiuKXqd-YVWhdBoSuMvpVCFQt5BwjRdf-9RKGBxkV6fQ@mail.gmail.com>
 <5181032d-5f85-5b65-66c6-5621b1582323@kernel.dk>
 <9e47c711-7101-85ad-3208-eb21dd0d12a9@kernel.dk>
 <CALjAwxhCpSiW9dgKDEzworPFBz07bViCLLogYhqByUc4sWTtwQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <520d1625-b0d6-2c4f-c270-985bf5456254@kernel.dk>
Date: Tue, 6 Mar 2018 11:53:55 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxhCpSiW9dgKDEzworPFBz07bViCLLogYhqByUc4sWTtwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/6/18 11:45 AM, Sitsofe Wheeler wrote:
>> BTW, another (and probably more problematic) issue is that the
>> compiler may well have support for sse/avx/avx512, while the
>> machine it's run on does not. If we enable the instruction set
>> based on that, we could be seeing illegal instructions outside
>> just the memcpy test. And that would be a concern, since it would
>> prevent fio from running at all.
>>
>> I think we have to make it something like the below because of that.
> 
> If someone forces SSE on then by all means we should add it to the
> CFLAGS but if they haven't and we can compile a program which uses
> headers/instructions that are only available when SSE is enabled then
> can't we deduce that the user is happy for those instructions to be in
> their code?

Right, _if_ they turn it on. The initial patch did it unconditionally,
this followup patch adds the option to turn it on, while defaulting to
not enabling sse. We can't add -msse if gcc decides to enable SSE
memcpy, for instance, which will then fail with SIGILL if the machine
doesn't support it.

> [...]
>> +##########################################
>> +# sse probe
>> +sse="no"
>> +cat > $TMPC << EOF
>> +#include <xmmintrin.h>
>> +#include <immintrin.h>
>> +int main(int argc, char **argv)
>> +{
>> +  __m128 val;
>> +  float const *src = NULL;
>> +  float *dst = NULL;
>> +  val = _mm_load_ps(src);
>> +  _mm_store_ps(dst, val);
>> +  return 0;
>> +}
> 
> We could try and use __builtin_ia32_addps (from
> https://gcc.gnu.org/onlinedocs/gcc/x86-Built-in-Functions.html#x86-Built-in-Functions

Sure

>> +EOF
>> +if test "$enable_sse" = "yes" && compile_prog "-msse" "" "sse"; then
>> +  sse="yes"
>> +fi
>> +print_config "SSE (compiler)" "$sse"
> 
> Here we wouldn't explicitly add -msse because we would have already
> added it to the global CFLAGS if forced or depended on the user's
> particular compiler flags if not.

It's only enabled IFF the global flag (--enable-sse) is set AND the
configure test passes.

-- 
Jens Axboe


