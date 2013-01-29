Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47991
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab3A2Nrg (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 08:47:36 -0500
Date: Tue, 29 Jan 2013 14:46:52 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130129134652.GF8800@kernel.dk>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> atency: (clat) 577usecs - 0.577ms
> >
> >Correct too.
> >
> >> Am I doing the correct analysis?
> >
> >Yep.
> >
> >> One question is: Is it possible to have global IOPS and latency?
> >
> >You mean for both read and write combined? Fio does not report that, but
> >for IOPS you could just add them. For latency, the larger of the two.
> >
> >--=20
> >Jens Axboe
> >
> 
> Hi Jens
> 
> This is neto from Brazil
> 
> How are you?
> 
> Thank you so much for your answer.
> 
> How can I have a combined IOPS reported?

You can't, at least not automatically. You would have to sum them up. It
would not be hard to add at all, though, controlled by an option. I
haven't had any requests for it before now, usually people ask for more
fine grained metrics, not the other way around :-)

-- 
Jens Axboe

