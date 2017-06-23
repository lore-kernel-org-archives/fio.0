Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/8] Makefile: use fmt(1) rather than tr(1) on NetBSD/etc
References: <20170623220801.38178-1-tkusumi@tuxera.com>
 <20170623220801.38178-3-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cba12c06-e24f-2af9-f97e-37bd2ebd583d@kernel.dk>
Date: Fri, 23 Jun 2017 16:18:59 -0600
MIME-Version: 1.0
In-Reply-To: <20170623220801.38178-3-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 06/23/2017 04:07 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> e291cff1 (Use fmt -w WIDTH option instead of -WIDTH) changed the
> command option to a common one to suppress an error, but it only
> fixed the unknown option error without being functional on NetBSD.
> 
> This change is taken from NetBSD's pkgsrc. It may work against
> other platforms that don't work with fmt(1), but only enabled for
> NetBSD at the moment. FreeBSD/DragonFlyBSD/OpenBSD work with fmt(1).
> 
> (This actually works on Linux too, but the existing one should be
> kept for Linux (and other platforms) provided it has been used on
> various distros for years)
> 
> https://github.com/NetBSD/pkgsrc/blob/trunk/benchmarks/fio/patches/patch-Makefile
> 
>> Convert the fmt(1) command to a tr(1) one (the fmt(1) old syntax
>> command is not supported on all Unix systems).

Not crazy about the target dependency on netbsd for using tr. But I
guess it's better we have it working.

-- 
Jens Axboe


