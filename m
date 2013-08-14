Return-Path: <xanpeng@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130813144311.GI25668@kernel.dk>
References: <CA+8ZFnhapBuTo0U9Loyg=zrGHxf2GGJN2=LTu2Sw0oJWKHNicA@mail.gmail.com>
	<20130813144311.GI25668@kernel.dk>
Date: Wed, 14 Aug 2013 09:48:12 +0800
Message-ID: <CA+8ZFnhH9Dg7-nsH52KALp1RaREVy51AKkd0_d_m2WPiv4AesA@mail.gmail.com>
Subject: Re: Why not abort when posix_fallocate() failed?
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Aug 13, 2013 at 10:43 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> I'm recently reading fio source code and running it for test purpose.
>> A case bothered me which is fio keep going after posix_fallocate()
>> failed, I'm wondering why, shouldn't it abort immediately?
>
> Fio treats it as advisory, like fadvise. Back in the day, fallocate
> would often not be available. So it would be hard to treat it as a full
> error.

Thanks. This sounds very reasonable to me.
-- 
- Thanks.
- xan.peng

