Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36112 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbZKWOTS (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 Nov 2009 09:19:18 -0500
Date: Mon, 23 Nov 2009 15:19:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fio on solaris
Message-ID: <20091123141923.GF8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de> <20091119201417.GJ8742@kernel.dk> <20091123120318.GW8742@kernel.dk> <25005.194.113.141.20.1258978389.squirrel@webmail.s-itc.de> <20091123121420.GX8742@kernel.dk> <13958.194.113.141.20.1258980688.squirrel@webmail.s-itc.de> <20091123125912.GZ8742@kernel.dk> <44735.194.113.141.20.1258982494.squirrel@webmail.s-itc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44735.194.113.141.20.1258982494.squirrel@webmail.s-itc.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tom <4711@gnurz.de>
Cc: fio@vger.kernel.org

On Mon, Nov 23 2009, Tom wrote:
> I search both on my server and found nothing, so I ask grandma google and
> I found this:
> 
> Don't use the POSIX_MEMALIGN function on solaris.
> 
> on
> http://www.ruby-forum.com/topic/165346
> 
> in a Website which is not our theme, but interessting.
> 
> I try to find it with grep:
> 
> # grep memalign /usr/include/stdlib.h
> extern void *memalign(size_t, size_t);
> extern void *memalign();
> 
> # grep fallocate /usr/include/stdlib.h
> # grep fallocate /usr/include/*

Can you try the newest snapshot? I added weak directives for those two
helpers.

-- 
Jens Axboe

