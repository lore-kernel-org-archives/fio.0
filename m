Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:55756 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0K3NUh (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Nov 2010 08:20:37 -0500
Message-ID: <4CF4FA1F.5070505@fusionio.com>
Date: Tue, 30 Nov 2010 14:20:31 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio packages for Solaris via opencsw.org
References: <20101129171159.GN28050@sebastiankayser.de>
In-Reply-To: <20101129171159.GN28050@sebastiankayser.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On 2010-11-29 18:12, Sebastian Kayser wrote:
> Hi,
> 
> in case anyone here is using fio on Solaris, there are now precompiled
> binary packages available via opencsw.org (Solaris 9/10, both x86 and
> SPARC) [1]. With Solaris 10 installation is as easy as:
> 
> # pkgadd -d http://mirror.opencsw.org/opencsw/pkgutil-`uname -p`.pkg
> # pkgutil -i fio
> 
> For Solaris 9 installation instructions and more details about pkgutil
> please see the pkgutil quick start page [2].
> 
> Sebastian
> 
> [1] http://www.opencsw.org/packages/fio/
> [2] http://www.opencsw.org/get-it/pkgutil/
> 
> P.S.: Jens, would you mind adding the package reference to README?

Not at all, was going to ask you if that would be ok until I saw this
line. Care to send a patch for the README?

-- 
Jens Axboe

