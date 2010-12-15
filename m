Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:34245 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0LOSad (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Dec 2010 13:30:33 -0500
Message-ID: <4D09093C.1040504@fusionio.com>
Date: Wed, 15 Dec 2010 19:30:20 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [patch] Use C99 standard integer types
References: <20101215150924.00003add@unknown>	<4D08DED3.6000202@fusionio.com> <20101215163754.00000c0e@unknown>
In-Reply-To: <20101215163754.00000c0e@unknown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 2010-12-15 17:37, Bruce Cran wrote:
> On Wed, 15 Dec 2010 16:29:23 +0100
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>> Really blktrace_api.h should just go away, since it's an OS interface
>> and should be exposed as such. We've traditionally always used __uxx
>> types in those interfaces. You should not be picking that up on
>> FreeBSD :-)
> 
> It looks like blktrace_api.h is being parsed through the depend rule
> in Makefile.[FreeBSD|NetBSD|mac] due to the headers being listed in
> $(SOURCE) - gcc just ignores missing <> headers while clang generates an
> error as it builds the dependency list. Since headers which are
> included within source files will be listed as a dependency anyway, I
> think they can be removed from $(SOURCE).

This looks good, thanks!

-- 
Jens Axboe

