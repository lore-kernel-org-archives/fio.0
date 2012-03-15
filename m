Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2CONmu (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Mar 2012 09:42:50 -0400
Message-ID: <4F61F1B2.6040809@kernel.dk>
Date: Thu, 15 Mar 2012 14:42:10 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] New offset_increment option
References: <1331767163-26042-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1331767163-26042-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org, egouriou@google.com, nauman@google.com, tirea@google.com

On 03/15/2012 12:19 AM, Dan Ehrenberg wrote:
> This patch adds a new option to fio job files. It is described
> in the HOWTO as follows:
> 
> offset_increment=int	If this is provided, then the real offset becomes
> 		the offset + offset_increment * thread_number, where the
> 		thread number is a counter that starts at 0 and is incremented
> 		for each job. This option is useful if there are several jobs
> 		which are intended to operate on a file in parallel in disjoint
> 		segments, with even spacing between the starting points.

This looks good. "Fixing" the math situation would be a bit more
involved, though cool if we had support for doing arbitrary math.

I have applied this, thanks Daniel!

-- 
Jens Axboe

