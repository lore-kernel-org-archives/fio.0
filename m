Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] include sys/sysmacros.h for major/minor
References: <1461171139-20616-1-git-send-email-vapier@gentoo.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5718BDDB.6070808@kernel.dk>
Date: Thu, 21 Apr 2016 07:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <1461171139-20616-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mike Frysinger <vapier@gentoo.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/20/2016 12:52 PM, Mike Frysinger wrote:
> These functions have always been defined in sys/sysmacros.h under
> Linux C libraries.  For some, including sys/types.h implicitly
> includes that as well, but glibc wants to deprecate that, and some
> others already have.  Include the header explicitly for the funcs.
>
> The mtd change is already in upstream mtd-utils too.

Added, thanks.

-- 
Jens Axboe


