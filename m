Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] smalloc: fix compiler warning
References: <20190731205751.17531-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d25403dd-bc12-3d6d-356f-e516de79a580@kernel.dk>
Date: Wed, 31 Jul 2019 15:28:26 -0600
MIME-Version: 1.0
In-Reply-To: <20190731205751.17531-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/31/19 2:57 PM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> firstfree() triggers a warning from the Windows compiler used by
> AppVeyor because it doesn't return a value if the for loop iterates to
> completion. This patch resolves the compiler warning.
> 
> AppVeyor Windows build log: https://ci.appveyor.com/project/axboe/fio/builds/26381726

I did this on top, as it removes the need to have that weird assert()
with a return. Also fixes the coding style (mix of tabs and spaces), and
makes it easier to read imho. Please review!

http://git.kernel.dk/cgit/fio/commit/?id=21eabccd000aaa36ff8af2cd0db833e0871ed85b

-- 
Jens Axboe


