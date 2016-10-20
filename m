Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] Use fmt -w WIDTH option instead of -WIDTH
References: <1476972198-5530-1-git-send-email-kusumi.tomohiro@gmail.com>
 <1476972198-5530-2-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d9fe5348-43b0-b69a-ecb9-1aa588b1f980@kernel.dk>
Date: Thu, 20 Oct 2016 08:16:55 -0600
MIME-Version: 1.0
In-Reply-To: <1476972198-5530-2-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/20/2016 08:03 AM, Tomohiro Kusumi wrote:
> Most systems support -WIDTH option which is an abbreviated form
> of -w WIDTH or --width=WIDTH option, but some OS don't support
> -WIDTH format.
>
> As far as I've checked (on actual systems or online manpages),
> Linux/FreeBSD/DragonFlyBSD/OpenBSD/Solaris/AIX/Cygwin support
> -WIDTH format, but NetBSD doesn't support this (see below).
> IRIX and HPUX may not support either according to online manpages.

It's been a while since I tried, but HPUX used to build without warning. 
Don't remember what version, though.

> -w WIDTH format is basically supported by all systems that have
> fmt command, so this is probably better in terms of portability.

Seems sane enough, I'll apply it.

-- 
Jens Axboe


