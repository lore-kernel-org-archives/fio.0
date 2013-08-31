Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3HaEcQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Aug 2013 00:32:16 -0400
Date: Fri, 30 Aug 2013 22:32:14 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: question on log file command behavior change
Message-ID: <20130831043214.GV21481@kernel.dk>
References: <CABFR9T2djdvEh9t7Jk_ouE9vN7+=z56kp5Z-NkKSytBybC6nkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABFR9T2djdvEh9t7Jk_ouE9vN7+=z56kp5Z-NkKSytBybC6nkA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <roger_sibert@xyratex.com>
Cc: FIO <fio@vger.kernel.org>

On Wed, Aug 28 2013, Roger Sibert wrote:
> Hello Everyone,
> 
> It's been a stretch since I last did something that required logging
> logging, that would be going from 2.0 to the latest git clone from
> today.
> 
> When I tried to use my older fio configuration files with the new fio
> it barked about not specifying the write_bw_log name.  The 2.0.x
> version used the name from the job so you could have the options
> turned on in [global].
> 
> Is the change in behavior where you now have to specify the name of
> the log (thus requiring it to be in each job) intentional?

Unfortunately it is intentional, it came with the merging of the gfio
code base. Someone else recently brought it up as well. But I will see
if I can come up with a good way to make it work as it did before...

-- 
Jens Axboe

