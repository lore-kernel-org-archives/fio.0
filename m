Return-Path: <axboe@kernel.dk>
Message-ID: <54F724C8.602@kernel.dk>
Date: Wed, 04 Mar 2015 08:29:12 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug#779336: fio: calc_clat_percentiles() create unaligned access
 on armhf
References: <20150227111544.3704.27235.reportbug@localhost> <1794059.2h3Ngk0LJU@merkaba>
In-Reply-To: <1794059.2h3Ngk0LJU@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org
Cc: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>, 779336@bugs.debian.org
List-ID: <fio@vger.kernel.org>

On 03/04/2015 02:12 AM, Martin Steigerwald wrote:
> Hello Andreas, hello Jens,
>
> thank you for your bug report.
>
> This sounds like an upstream bug, thus I cc fio mailing list.
>
> Jens, any idea?

This is fixed in later releases, the debian package should be updated to 
2.2.6.

-- 
Jens Axboe


