Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab2JJPHW (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Oct 2012 11:07:22 -0400
Message-ID: <50758F22.80208@kernel.dk>
Date: Wed, 10 Oct 2012 09:07:14 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Windows & netio problems/bugreport
References: <DIIE.000011B400039534@192.168.0.5> <507569CF.2010108@cran.org.uk>
In-Reply-To: <507569CF.2010108@cran.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: =?UTF-8?B?U3RlZmFuIEjDvGJuZXI=?= <shu@wwwgroup.de>, fio@vger.kernel.org

On 2012-10-10 06:27, Bruce Cran wrote:
> On 18/09/2012 11:30, Stefan Hübner wrote:
>> I just noticed a major bug in fio for windows (proven on W7 and WSS 2008R2).  It seems the netio-testing doesn't work at all a.t.m, even with elevated privileges.
> 
> There were a few problems, which I'll fix for 2.0.10:
> 
> There was no call to WSAStartup().
> inet_aton() wasn't implemented.
> There was a NULL dereference bug in poll().

Bruce's patch has been integrated into the current -git version.

-- 
Jens Axboe

