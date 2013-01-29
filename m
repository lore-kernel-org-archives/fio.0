Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47780
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103Ab3A2NC5 (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 08:02:57 -0500
Date: Tue, 29 Jan 2013 14:02:12 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130129130212.GB8800@kernel.dk>
References: <843E15216120C047928F6879B0E2D9240F6D006F@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D006F@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Jan 28 2013, Neto, Antonio Jose Rodrigues wrote:
> Hi All,
> 
> This is neto from Brazil
> 
> How are you?
> 
> I just need a help to make sure I understood correctly the report (see below --Output). 
> 
> Trying to generate 80% Read and 20% Write - 8KB block size
> 
> Reads
> IOPS: 15330
> Latency: (clat) 628usecs - 0.628ms

Correct. Well 629 really, if rounded properly.

> Writes
> IOPS: 3827
> Latency: (clat) 577usecs - 0.577ms

Correct too.

> Am I doing the correct analysis?

Yep.

> One question is: Is it possible to have global IOPS and latency?

You mean for both read and write combined? Fio does not report that, but
for IOPS you could just add them. For latency, the larger of the two.

-- 
Jens Axboe

