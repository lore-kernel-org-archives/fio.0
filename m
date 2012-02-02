Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35086 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030Ab2BBTUU (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Feb 2012 14:20:20 -0500
Message-ID: <4F2AE1F0.9080005@fusionio.com>
Date: Thu, 2 Feb 2012 20:20:16 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Optimize pattern filling by limiting small calls to memcpy.
References: <CAAUT-yOCgVD61WtQB4CtY86zzYFCBfN4G=F=QCd4kvqFb4zx+Q@mail.gmail.com> <4F2A4DE7.7020409@fusionio.com> <CAAUT-yMkot3gGYA13bwbakmMArsHYnF_bYOFNzW9sHDL2Eg+rA@mail.gmail.com>
In-Reply-To: <CAAUT-yMkot3gGYA13bwbakmMArsHYnF_bYOFNzW9sHDL2Eg+rA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-02-02 20:11, Steven Lang wrote:
> No, that's actually all of it; it's really that simple.  It just takes
> the pattern buffer, and replicates it until it it is at least half
> full, which during verification drastically reduces the number of
> calls to memcpy() for short multibyte patterns.

Ah gotcha, I see what you mean now, what I missed was the assignment of
td->o.verify_pattern_bytes _after_ the extra fill on option init. Looks
good! I'll apply it.

-- 
Jens Axboe

