Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3A2UdX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 29 Jan 2013 15:33:23 -0500
Date: Tue, 29 Jan 2013 21:32:39 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130129203239.GJ8800@kernel.dk>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129134652.GF8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D26D5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129135401.GG8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D27A5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129201005.GH8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D396C@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D396C@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> Jens, sorry to bother you again, but I am trying to apply the I've got this=
>  error. Could you please help me how to fix it?

I forgot to push a previous change out. Pull again and try applying,
should apply without fuzz.

-- 
Jens Axboe

