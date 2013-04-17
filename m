Return-Path: <fio-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54323 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3DQGMy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Apr 2013 02:12:54 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5DF329A0690
	for <fio@vger.kernel.org>; Wed, 17 Apr 2013 00:12:54 -0600 (MDT)
Date: Wed, 17 Apr 2013 08:12:36 +0200
From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Fio ignoring runtime after an error?
Message-ID: <20130417061236.GD4816@kernel.dk>
References: <A7A1D348E34E024BBC74480FB93A2EAB026DFC@DAGN05A-E6.exg6.exghost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB026DFC@DAGN05A-E6.exg6.exghost.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Apr 16 2013, Carl Zwanzig wrote:
> Hello,
> 
> I think I've run across a case where, during a time-limited test, a soft error occurred on the device and fio continued to run -way- past (overnight) the time limit.
> 
> The rough scenario is:
> fio test - ok
> fio test - ok
> fio test - starts
>   soft error
> fio never ends (and is still pushing traffic as reported by the disk system)
> 
> I haven't had a chance to dive into the code yet (fio 2.0.14, linux 2.6.32-279.14.1.el6.x86_64), but can anyone think of a reason why this would happen?
> 
> The command line looks like:
> fio --name='raid0;16;randread;8;16' --rw=randread --filename=/dev/ethdrv/e107.1 --iodepth=16 --bs=8k --rwmixread=70 --norandommap --group_reporting --time_based --minimal --direct=1 --fill_device=1 --ioengine=libaio --ramp_time=5 --runtime=35 --randrepeat=0
> 
> Hopefully, I'll get the clue to inject an error into the disk system and run this down, but that'll take time I don't really have.

What kind of error? For fill_device=1, fio will clear ENOSPC, but should
not clear other errors. Apart from that, there should not be any
interactions between errors and runtime/time_based.

-- 
Jens Axboe

