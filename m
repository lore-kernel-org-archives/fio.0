Return-Path: <axboe@kernel.dk>
Subject: Re: gfio and GTK-3
References: <2016694.B2NXdZ3Yii@merkaba>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <817148c6-67ff-f3bd-12b0-21e2e7b03748@kernel.dk>
Date: Thu, 20 Aug 2020 05:52:40 -0600
MIME-Version: 1.0
In-Reply-To: <2016694.B2NXdZ3Yii@merkaba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Martin Steigerwald <martin@lichtvoll.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/20/20 1:43 AM, Martin Steigerwald wrote:
> Dear Jens, dear community.
> 
> Is gfio compatible with GTK-3?
> 
> I am asking due to Debian wanting to get rid of GTK-2 at some time:
> 
> fio: depends on deprecated GTK 2: https://bugs.debian.org/967339
> 
> If not, are there plans to make it compatible? Or are there plans to 
> drop it instead?

I'm tempted to just drop it. gfio never really got what I consider
finished, and I don't think it's in widespread use.

Maybe I'm wrong and there are in fact people out there using it. I
know someone had a patch at some point to convert it to gtk3, and
if that's still the case, I would not mind applying that and making
it continue to live in the repo.

-- 
Jens Axboe


