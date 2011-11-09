Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1KIMtl (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Nov 2011 07:49:41 -0500
Message-ID: <4EBA76E4.5070903@kernel.dk>
Date: Wed, 09 Nov 2011 13:49:40 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Improve accuracy of rate= option
References: <CAAUT-yO+0SPX9Hrf_ck20S_A-amYcW1ev_me+2gtHpayfg6SNA@mail.gmail.com>
In-Reply-To: <CAAUT-yO+0SPX9Hrf_ck20S_A-amYcW1ev_me+2gtHpayfg6SNA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2011-11-09 02:10, Steven Lang wrote:
> I noticed that the rate= option is not terribly precise in some cases.
>  It gets worse the higher the selected rate.  For example:
> $ fio -name=load -size=100g -ioengine=null -runtime=10 -rate=30m
> One would expect that to read 300MB (307200KB) at close to 30MB/s
> (30720KB/s).  However it writes 315024KB at 31499KB/s.  Further
> experimentation shows that even higher rates can show bigger
> discrepancies.  At the extreme end...
> $ fio -name=load -size=100g -ioengine=null -runtime=10 -rate=500m
> One would expect this to write 5000MB at a rate of 500MB/s
> (512000KB/s).  However it writes close to double that (9536.8MB) at a
> rate of over 953MB/s.  At a rate of 1GB/s and higher, the rate
> limiting is effectively ignored.
> 
> This patch improves the accuracy of the rate= option across the whole
> range of rates, at the cost of being very slightly more
> computationally expensive.

Thanks Steven, another great patch. Applied.

I'm still mulling over the option patch. It'd be great if one could do:

$ fio --cmdhelp=ioengine=libaio

to display these private options. And it's a bit confusing on the global
vs private engine options, but in reality it _probably_ wont bite
anyone.

Anyway, I fiddle with it a bit and let you know.

-- 
Jens Axboe

