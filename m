Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:47904 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZEVHuz (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 May 2009 03:50:55 -0400
Date: Fri, 22 May 2009 09:50:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Set io_u field(endpos) value during verify phase
Message-ID: <20090522075056.GI11363@kernel.dk>
References: <66dfd3fe0905211440s2b95867ex12a741e7a391b2fb@mail.gmail.com> <66dfd3fe0905211451x353c250bt326136f87be5d7f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0905211451x353c250bt326136f87be5d7f6@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Thu, May 21 2009, Radha Ramachandran wrote:
> Sorry for the confusion, Please disregard this fix.  Looks like I was
> looking at the older version of the fio code that had this bug.  The
> current version of fio does not work the same way, so will not see
> this error.

I think the endpos code got in through the google verify work. Looking
at the current base, it's only set once and never read. So at least some
good came of your posting, I killed the variable :-)

-- 
Jens Axboe

