Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48462 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab3GPVNl (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Jul 2013 17:13:41 -0400
Date: Tue, 16 Jul 2013 15:13:33 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Question about exec_string()
Message-ID: <20130716211333.GP22392@kernel.dk>
References: <51E4F3F6.3030808@enovance.com>
 <20130716205810.GM22392@kernel.dk>
 <51E5B4C6.9040705@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5B4C6.9040705@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: fio@vger.kernel.org

On Tue, Jul 16 2013, Erwan Velu wrote:
> On 16/07/2013 22:58, Jens Axboe wrote:
> >
> >I'll happily take a patch to include the output into the general logging
> >:-). That's the way it should work.
> That could be very verbose. Isn't that a problem ?
> I though to split it to let user read it later if needed instead of flooding
> the current console.

Sure, that'd be fine too. You could have jobname-prerun.txt etc created.
I'm fine with either approach.

-- 
Jens Axboe

