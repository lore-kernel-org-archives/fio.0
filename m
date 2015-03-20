Return-Path: <axboe@kernel.dk>
Message-ID: <550C4AF9.4020502@kernel.dk>
Date: Fri, 20 Mar 2015 10:29:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] In gettime.c, check for ARCH_CPU_CLOCK_WRAPS only ifdef
 ARCH_HAVE_CPU_CLOCK
References: <CAFFT=UnkLWJ2GjDMBg8ZvuFN05us8QbYLZHpn1BzWDaAjFob3w@mail.gmail.com>
In-Reply-To: <CAFFT=UnkLWJ2GjDMBg8ZvuFN05us8QbYLZHpn1BzWDaAjFob3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/19/2015 05:26 PM, Akash Verma wrote:
> This causes compiler warnings because of unused variables cycles_start
> and cycles_wrap.
>
>  From 8dce1512a5adf39f30643085b11a0b94cecf6157 Mon Sep 17 00:00:00 2001
> From: Akash Verma <akashv@google.com>
> Date: Thu, 19 Mar 2015 16:19:25 -0700
> Subject: [PATCH] Cpu clock does not wrap if there is no CPU clock

Thanks, applied.

-- 
Jens Axboe


