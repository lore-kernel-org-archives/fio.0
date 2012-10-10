Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:21012 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2JJM2A convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Oct 2012 08:28:00 -0400
Message-ID: <507569CF.2010108@cran.org.uk>
Date: Wed, 10 Oct 2012 13:27:59 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Windows & netio problems/bugreport
References: <DIIE.000011B400039534@192.168.0.5>
In-Reply-To: <DIIE.000011B400039534@192.168.0.5>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?U3RlZmFuIEjDvGJuZXI=?= <shu@wwwgroup.de>
Cc: fio@vger.kernel.org

On 18/09/2012 11:30, Stefan Hübner wrote:
> I just noticed a major bug in fio for windows (proven on W7 and WSS 2008R2).  It seems the netio-testing doesn't work at all a.t.m, even with elevated privileges.

There were a few problems, which I'll fix for 2.0.10:

There was no call to WSAStartup().
inet_aton() wasn't implemented.
There was a NULL dereference bug in poll().

-- 
Bruce Cran
