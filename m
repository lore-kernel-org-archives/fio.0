Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53946 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab1GWLhP (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Jul 2011 07:37:15 -0400
Message-ID: <4E2AB262.1010309@fusionio.com>
Date: Sat, 23 Jul 2011 13:37:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Respect iodepth_batch_complete=0 in main loop
References: <1311196279-7373-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1311196279-7373-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org

On 2011-07-20 23:11, Dan Ehrenberg wrote:
> If the iodepth_batch_complete is 0, then even if the queue is full,
> we still don't make min_events be 1 in the main loop. Instead, poll
> in a non-blocking way until a result is found.

Thanks, applied 1+2.

-- 
Jens Axboe

