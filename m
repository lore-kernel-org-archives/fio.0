Return-Path: <rebecca@bluestop.org>
Subject: Re: zlib in Windows fio builds
References: <CALjAwxj5ebGHWjDs5gOK+YXHSVa+4UCFQi-UGyygNn8W3YgeuA@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <4cfb9f70-3802-f25d-040c-7fb2533b05ec@bluestop.org>
Date: Wed, 21 Feb 2018 10:10:00 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxj5ebGHWjDs5gOK+YXHSVa+4UCFQi-UGyygNn8W3YgeuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2/21/2018 9:44 AM, Sitsofe Wheeler wrote:

> I've noticed that cygwin/mingw actually package up a static zlib in
> the form of mingw64-x86_64-zlib / mingw64-i686-zlib . Given this, can
> we adjust the install instructions to suggest users grab those
> packages and remove the custom zlib/contrib searching in the configure
> script?

Oh, yes - that makes sense.
Thanks!

-- 
Rebecca

