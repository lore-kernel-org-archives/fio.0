Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3ICWha (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Sep 2013 18:37:30 -0400
Date: Tue, 3 Sep 2013 16:37:27 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to loop a timebased job
Message-ID: <20130903223727.GB31170@kernel.dk>
References: <522639CE.2030705@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522639CE.2030705@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Sep 03 2013, Erwan Velu wrote:
> Hey,
> 
> I'm on the IRC channel trying to help someone that needs to do the following
> :
> 
> doing IOs for x seconds
> sleeping for y seconds
> and looping this z times
> 
> While trying to setup this, I faced that loops and timebased seems exclusive
> options.
> Am I wrong on this point ?
> 
> If not, would it be possible not to let them exclusive or add a new option
> to handle this case?

It should work, if it doesn't, I agree it's a bug. It's not certain than
anyone has considered this specific use case before.

Feel free to fix! Or I can take a look at it tomorrow.

-- 
Jens Axboe

