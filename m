Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48705 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3CLMLh (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 08:11:37 -0400
Date: Tue, 12 Mar 2013 13:11:07 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: configure/make target machine
Message-ID: <20130312121107.GM25165@kernel.dk>
References: <513EB4F7.3040204@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513EB4F7.3040204@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On Tue, Mar 12 2013, Aaron Carroll wrote:
> Hi,
> 
> It would be nice to make fio a little more cross compile friendly.  Right
> now configure determines the target by checking for C defines and falling
> back to uname.  The makefile then reads uname again.  Is there any reason we
> can't propagate the host/target from configure to makefile?

Absolutely no reason why that could not be done. I haven't played much
wit cross compiling myself (ever), so feel free to implement a proper
way of passing the required info to configure/Makefile so that it's more
cross build friendly.

-- 
Jens Axboe

