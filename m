Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:52976 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab0LNHdJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Dec 2010 02:33:09 -0500
Message-ID: <4D071DB3.9060207@fusionio.com>
Date: Tue, 14 Dec 2010 08:33:07 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: resend [PATCH] fix ramp_in
References: <4D068908.8030205@dangyankee.net>
In-Reply-To: <4D068908.8030205@dangyankee.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Pratt <steve@dangyankee.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-12-13 21:58, Steven Pratt wrote:
> Let's try this again without the mangling.

Actually this one is also badly mangled :-)

> There are a couple of problems with the relatively new ramp_in feature
> of fio.  First, the estimated time
> to completion did not correctly take it into account and bounces around.
> Second and more importantly,
> the runtime was including ramp in time in throughput calculations even
> though the IO done during that
> time was ignored, thus making throughput metrics incorrect. This patch
> fixes both.

Thanks, I hand applied it. You could also remove runtime[] in
fio.c:thread_main() since it's now unused, I did that.

-- 
Jens Axboe

