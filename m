Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:56767 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZKCUmg (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Nov 2009 15:42:36 -0500
Date: Tue, 3 Nov 2009 21:42:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fix race condition when using asynch verify
Message-ID: <20091103204240.GN8742@kernel.dk>
References: <66dfd3fe0911031240o786976ewfca457239e1b9048@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911031240o786976ewfca457239e1b9048@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Tue, Nov 03 2009, Radha Ramachandran wrote:
> Hi,
> I discovered the race condition when using asynch verify with libaio engine.
> The code assumes that because the td->cur_depth value is not 0 that
> there is still I/O pending and issues io_getevents when the I/O was
> actually being verified by the asynchronous verify thread. This causes
> the code to hang.
> 
> I have attached a patch along to fix this issue.

Thanks for the fix, that is indeed a race. I'll merge your patch, but
change the io_u->in_cur_depth to be a IO_U_F_ flag.

-- 
Jens Axboe

