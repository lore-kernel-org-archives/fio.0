Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2HPG6Q (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Aug 2012 02:58:16 -0400
Message-ID: <502C99E1.6020803@kernel.dk>
Date: Thu, 16 Aug 2012 08:57:37 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fixing wraparound behavior for time-based sequential
 read jobs
References: <1345068498-3732-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1345068498-3732-1-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org, nauman@google.com, jhr@google.com, akashv@google.com, aschade@google.com

On 08/16/2012 12:08 AM, Dan Ehrenberg wrote:
> Previously, a buggy patch made sequential jobs wrap around when they
> reached an offset of 'size'. However, the appropriate wraparound is at
> size + initial offset. This patch restores the previous behavior.

Thanks Dan, that looks correct. Applied.

-- 
Jens Axboe

