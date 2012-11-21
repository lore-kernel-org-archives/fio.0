Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2KUJqN (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 21 Nov 2012 04:46:13 -0500
Message-ID: <50ACA2A4.2040508@kernel.dk>
Date: Wed, 21 Nov 2012 10:45:08 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO on Android
References: <50AC7DC7.6040804@cse.unsw.edu.au>
In-Reply-To: <50AC7DC7.6040804@cse.unsw.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On 2012-11-21 08:07, Aaron Carroll wrote:
> Hi,
> 
> Attached is a patch to support Android.  It's implemented as a
> different OS, so most of the changes are in os/os-android.h
> 
> To build, do something like:
> 
>   make UNAME=Android
>   CROSS_COMPILE=/path/to/android/toolchain/bin/arm-linux-androideabi-
> 
> Yes, it's pretty ugly all round, but fio isn't designed for cross
> compile and Android's libc is busted, so we have to make do.
> 
> Note that this is basically untested.  Works for a few basic tests but
> YMMV.  If someone wants to look at the splice build warning, that
> would be great.

Nifty! Applied, thanks.

-- 
Jens Axboe

