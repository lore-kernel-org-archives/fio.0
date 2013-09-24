Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3IXOm0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 Sep 2013 10:42:26 -0400
Message-ID: <5241A4AF.7030504@kernel.dk>
Date: Tue, 24 Sep 2013 08:41:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: new fio release?
References: <1416283628.111018.1380009575092.JavaMail.zimbra@teamix.de>
In-Reply-To: <1416283628.111018.1380009575092.JavaMail.zimbra@teamix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org, =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>

On 09/24/2013 01:59 AM, Martin Steigerwald wrote:
> Hi Jens!
> 
> Georg is currently packaging fio 2.1.2 for Ubuntu Precise, while I did 2.1.1 for Debian a while ago.
> 
> I already started packaging 2.1.2 for Debian as well and I think I was almost finished with it but I had:
> 
> ms@mango:~/lokal/Debian/fio> lintian -IE fio_2.1.2-1_amd64.changes
> W: fio: script-with-language-extension usr/bin/fio2gnuplot.py
> W: fio: binary-without-manpage usr/bin/fio2gnuplot.py
> W: fio: binary-without-manpage usr/bin/genfio
> 
> which as I looked are all fixed upstream already.
> 
> Since it is difficult to rename a upstream file in debian packaging without repacking upstream tarball, I'd rather build next package from a fio release with these issues fixed.
> 
> 
> Can you do a fio 2.1.3 release?

Yeah, it's about that time anyway, and the short list of changes between
2.1.2 to now seems to indicate a decent point to do a new release.

-- 
Jens Axboe

