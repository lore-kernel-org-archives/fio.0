Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:61946 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbdGYHnH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Jul 2017 03:43:07 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: The commit 'filesetup: add native fallocate' breaks on Cygwin
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <CAHndrBkV55xWU0yioqqYARdE3SzVpjxxnp9e8qoxxF+-Y_5F+A@mail.gmail.com>
Date: Tue, 25 Jul 2017 01:43:04 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <A3342934-22F3-49F3-B6DB-96307D34AA56@bluestop.org>
References: <CAHndrBkV55xWU0yioqqYARdE3SzVpjxxnp9e8qoxxF+-Y_5F+A@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio@vger.kernel.org

Thanks, I'll take a look at it later today - I guess the posix emulation needs some work.

-- 
Rebecca

Sent from my iPhone

> On Jul 25, 2017, at 1:16 AM, Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
> 
> Hi
> It seems the recent commit 2c3e17be ('filesetup: add native
> fallocate') breaks on Cygwin.
> It works on FreeBSD by the way.
> 
> ---
> $ uname
> CYGWIN_NT-10.0
> $ ./fio --name=xxx --ioengine=sync --rw=read --bs=4k --size=1m
> fio: this platform does not support process shared mutexes, forcing
> use of threads. Use the 'thread' option to get rid of this warning.
> xxx: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=sync, iodepth=1
> fio-2.21-80-g2c3e
> Starting 1 thread
> 
> This application has requested the Runtime to terminate it in an unusual way.
> Please contact the application's support team for more information.
> xxx: Laying out IO file (1 file / 1MiB)
> fio: unknown fallocate mode: 0
> Assertion failed!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

