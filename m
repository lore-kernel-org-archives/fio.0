Return-Path: <axboe@kernel.dk>
Subject: Re: [Bug-Report] fio cannot handle some situation
References: <CADhrBQRs9AnEwucJi01ydagqZjuZ=CYeWKeBG+Ds0P46sb-g+Q@mail.gmail.com>
 <b0ba9833-7739-e9ea-0b36-e8744734c9ed@kernel.dk>
 <CADhrBQQZ=AUmsAcTUpv6YSFdL27v7NsZD98Q0Cd8p8UhORk-zQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3d085c0b-0d2a-1575-0aab-95ba30bc45c4@kernel.dk>
Date: Wed, 22 Aug 2018 09:09:46 -0600
MIME-Version: 1.0
In-Reply-To: <CADhrBQQZ=AUmsAcTUpv6YSFdL27v7NsZD98Q0Cd8p8UhORk-zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Chao Guo <guochao@nutstore.net>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/22/18 4:40 AM, Chao Guo wrote:
> ok. that makes sense.
> 
> i thought that the file fio created was already written with verify data.

Only if you ask it to, as it stands, your job file asked fio to verify
already written data.

-- 
Jens Axboe


