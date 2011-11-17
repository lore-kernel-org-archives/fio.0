Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab1KQIpr (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Nov 2011 03:45:47 -0500
Message-ID: <4EC4C9BA.2090905@kernel.dk>
Date: Thu, 17 Nov 2011 09:45:46 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Expand continue_on_error to select which type of error
 to allow
References: <CAAUT-yMXe=PK1roL710ciSqZqqnh2GSmGb6BVyUMreY5Yqbwbw@mail.gmail.com>
In-Reply-To: <CAAUT-yMXe=PK1roL710ciSqZqqnh2GSmGb6BVyUMreY5Yqbwbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2011-11-17 04:09, Steven Lang wrote:
> This expands the continue_on_error option to take a string specifying
> what type of error to continue on, breaking out errors into read,
> write, and verify.  (Sync, trim, and anything else not specifically a
> read are considered write operations for the sake of error
> continuation.)
> 
> Backwards compatibility is retained by allowing =0 and =1 values to
> specify none and all, respectively.

Thanks, this is a good idea. I have applied it. Can I talk you into also
sending in an update for the fio.1 man page?

-- 
Jens Axboe

