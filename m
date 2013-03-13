Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42627 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab3CMPAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 Mar 2013 11:00:04 -0400
Date: Wed, 13 Mar 2013 15:59:30 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH/RFC] Improve cross-compile support
Message-ID: <20130313145930.GJ25165@kernel.dk>
References: <CAKCZDgn5ds9-Fmn6pLW4Y7eCpeJr2C5gks1jKgCK3J-wNtXoeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgn5ds9-Fmn6pLW4Y7eCpeJr2C5gks1jKgCK3J-wNtXoeQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On Wed, Mar 13 2013, Aaron Carroll wrote:
> A first attempt at making cross-compile viable is attached.
> 
> Specifically we:
>  - Propagate the target OS from configure to Makefile so we dont need uname
>  - Allow CROSS_COMPILE for toolchain prefix, which is common (e.g. Linux)
>  - Allow wordsize and bigendian to be set statically.  These are
> usually determined by executing a test program, which obviously
> doesn't work for cross compiles.
>  - Make the Android config dynamic (but set wordsize/bigendian)
> 
> Now the wordsize/bigendian handling is not ideal but I can't think of
> a better approach right now.
> 
> Also I've changed the #includes in the socklet_t check.  sys/socket.h
> appears to be the right thing, but please check.
> 
> Compile tested on Linux/i386 native, Linux/i386 to Android cross
> compile, and OS X native.

Looks OK to me, I can test on other platforms too. But it does not apply
against current -git:

patching file Makefile
patching file configure
Hunk #3 FAILED at 235.
1 out of 9 hunks FAILED -- saving rejects to file configure.rej

Can you update and resend? Thanks!

-- 
Jens Axboe

