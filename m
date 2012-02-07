Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41382 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab2BGIlY (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Feb 2012 03:41:24 -0500
Message-ID: <4F30E374.4080401@fusionio.com>
Date: Tue, 7 Feb 2012 09:40:20 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Enable completion latency stat collection on verify
References: <CAAUT-yMQ5MpMCT0JBvSgeD73aTfyNuekATtJ4XsPjka5_ZX_1w@mail.gmail.com>
In-Reply-To: <CAAUT-yMQ5MpMCT0JBvSgeD73aTfyNuekATtJ4XsPjka5_ZX_1w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 02/07/2012 03:58 AM, Steven Lang wrote:
> A patch last year
> (http://git.kernel.dk/?p=fio.git;a=commit;f=io_u.c;h=c8eeb9df1f52f28567a5937e141decc6a26ec30b)
> changed the behavior of verify loads so they stopped printing
> completion latency stats.  (A verify load in this case includes both
> rw=*write with verify and do_verify=1 and rw=*read with verify.)
> 
> Is there any particular reason that an io_u which is going to be
> verified shouldn't have its latency statistics recorded?

No reason, patch applied, thanks!

-- 
Jens Axboe

