Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54365 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762581Ab2ERKAM (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 18 May 2012 06:00:12 -0400
Message-ID: <4FB61D94.2050909@kernel.dk>
Date: Fri, 18 May 2012 11:59:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: blocking shutdown?
References: <CAMJ=ptCSGPwF+QWLw27XePB9kbJ-PxjtOtvJ3UbmzAqaZsYrGQ@mail.gmail.com> <CAMJ=ptBgv_YKz9zQOnsyMzXbLO=pUusNY9YEWJzqQWgr_TvRyw@mail.gmail.com>
In-Reply-To: <CAMJ=ptBgv_YKz9zQOnsyMzXbLO=pUusNY9YEWJzqQWgr_TvRyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: George Pang <xilvar@gmail.com>
Cc: fio@vger.kernel.org

On 05/17/2012 10:50 AM, George Pang wrote:
> I've been configuring a server for a colocation recently using ubuntu
> 12.04 desktop (the server dist dislikes my only keyboard) and I
> noticed that if I am running an fio test and I initiate a shutdown the
> shutdown kills off everything as usual, but fio appears to keep
> running and block shutdown. (from either the desktop ui or with
> "shutdown now")
> 
> Thus on a remote server any user with privileges to run fio could
> accidentally, or maliciously prevent system shutdown from completing,
> effectively taking a server out of service until physical access was
> achieved.

Sounds like the distro is buggy, then. Fio is nothing special. It'll
terminate on a signal, if sent TERM for instance. The only way that fio
would feasibly not die on shutdown would be if it's stuck
uninterruptibly in the kernel, due to an oops/crash or a bug.

-- 
Jens Axboe

