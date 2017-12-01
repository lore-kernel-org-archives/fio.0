Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test
References: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk>
 <AT5PR8401MB038721B93CF3CF3DE4361A7AAB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <aba29420-0049-5537-7efe-c6f5f7093b4f@kernel.dk>
 <5020B706-1B8E-4617-93C7-4B424BADA35C@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d4860d34-5a01-be3d-a697-4692a83d505f@kernel.dk>
Date: Fri, 1 Dec 2017 13:59:43 -0700
MIME-Version: 1.0
In-Reply-To: <5020B706-1B8E-4617-93C7-4B424BADA35C@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "Robert Elliott (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 12/01/2017 01:57 PM, Rebecca Cran wrote:
> 
>> On Dec 1, 2017, at 1:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> My goal would be to find if there's something simple we can do to provide
>> a fairly optimized version we can use for larger copies, which is
>> essentially just for mmap and libpmem/dev-dax and friends. 
> 
> Would you be looking for code that makes the decision at runtime
> (using cpuid to see which of SSE, AVX, AVX512F it supports) or having
> it be a compile-time thing?

Should probably be a runtime thing, similar to how we do crc32c checks
and enabling.

And I suspect that we'll just end up with something that is just enabled
for larger sizes, and/or just used for the performance sensitive engine
copies. I don't think we have hot mem copies anywhere else.

But we need to see a substantial win somewhere for it to be worth it. If
not, then I'd rather not, since it does come with an extra maintenance
burden.

-- 
Jens Axboe


