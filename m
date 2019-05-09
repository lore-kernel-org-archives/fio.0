Return-Path: <axboe@kernel.dk>
Subject: Re: Recent changes (master)
References: <20190509120003.26BCA2C098E@kernel.dk>
 <3b8b6f54-e990-2feb-bfc3-14a68345c366@criteo.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b40b8010-52ea-1d77-bdae-225086e8dfab@kernel.dk>
Date: Thu, 9 May 2019 08:07:53 -0600
MIME-Version: 1.0
In-Reply-To: <3b8b6f54-e990-2feb-bfc3-14a68345c366@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Erwan Velu <e.velu@criteo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 5/9/19 6:47 AM, Erwan Velu wrote:
> Isn't that also related to the kernel version you use ?
> 
> This message might mislead the user as he might just have to upgrade his 
> kernel to gain the feature ?

Yes, the message is for the specific kernel, it doesn't speak for any
future kernels. But I think we're getting into documentation at this
point, the message just means that on this setup, either the fs or
device driver (or both) doesn't support polled IO.

-- 
Jens Axboe


