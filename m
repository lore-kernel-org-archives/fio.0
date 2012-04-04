Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2DDUPK (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Apr 2012 16:15:10 -0400
Message-ID: <4F7CABC5.7090109@kernel.dk>
Date: Wed, 04 Apr 2012 14:15:01 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk>
In-Reply-To: <4F7CA5F1.2050309@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Danny Kukawka <dkukawka@suse.de>
Cc: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2012-04-04 13:50, Jens Axboe wrote:
>> 2) fio 2.0.6 and also the current git tends to fail with this error:
> 
>>    fio 2.0.6
>>    Starting 1 process
>>    fio: iolog.c:242: log_io_piece: Assertion `ipo->len == __ipo->len'
>>    failed.:08m:31s]
> 
>> It seems that we can prevent it when we use the --size parameter, but we
>> would like to prevent the usage of the parameter, if possible
> 
> Strangely, I had two reports of this today. Did a bit of digging, and
> it's due to this commit:
> 
> commit c04e4661e4da3b6079f415897e4507cf8e610c54
> Author: Daniel Ehrenberg <dehrenberg@google.com>
> Date:   Fri Mar 16 18:54:15 2012 +0100
> 
>     time_based: Avoid restarting main I/O loop
> 
> I think what is going on here is that your job is time based, and when
> we fail getting a new offset, we clear the offset bitmap. But we could
> have verifies pending at this point, we'd need to prune this out as
> well.

Actually, since it happens so rarely, I think the better approach is
just to ignore it. I've updated fio to reflect that.

- -- 
Jens Axboe

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPfKvBAAoJEPfTWPspceCmuLIP+wccx5iGP9f5qpD7J0GJbQ7m
ClUlBZEPbKJw15KUW27bydRjaPZjBw71aX/ho5UzAPTH7vR97jqgQVve6brg7lB0
xxoUVa1ww3JQHpT5rDsZ+wy+JeFxbiKVWgqQJquJuayX128j6gGxyIap5qGatCym
N9yS3BrZxBmujEuY4O1OOLPi30eIXq3ncLqWq5Xi1HBlo3Wog+/22ZD0Lp2WcAZT
A8oCUNcvtEuhSseMqc4B/xBDZHBPnEI0JmiHB+COkKN3oRi536LfO/7SZMx4rm3x
LHUGwUtE5zdyz3HtiTcy9TxjPFUK83JfwaOQ4dayIhSyJw1SPQN7ZlPXuwd1A8Q8
lFpZffFkU5IBoBRXXE/VUxpoKTB8YBMbtp1uELp5nYnVjVsJA2eYmaStQP7jU7RD
v8UqSNTCJCAJBNFdliuVxSYjdiRM9nGxBLcOt1knereWCJTjdzf+FnjCKFrS9Pop
m3IOpkrH1Jr44xtOs9wZkrPP1XYOfqCAiNiZqnfQUiWK7Po3jIvVuHRymzkomDBB
S4ellXIx1MTyl5OkIniMYwJuP5gN2LDLQ3cicTcLggve821o2Shr0CK67zn49WQt
0THsyw0fOcgbJYYZ9FKaN98rM42pL+ctujjUe6yaA4Vk3ylp9qSSZRDS7gPziMaw
Yf/J5XC3leAxr2hLDuyT
=ajen
-----END PGP SIGNATURE-----
