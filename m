Return-Path: <fio-owner@vger.kernel.org>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:2481 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbZJGUgh (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Oct 2009 16:36:37 -0400
From: Roland Dreier <rdreier@cisco.com>
Subject: Re: "Fix wrong clock source in mutex" broke fio for me
References: <ada1vlfqan3.fsf@cisco.com> <20091007200128.GK8703@kernel.dk>
Date: Wed, 07 Oct 2009 13:22:43 -0700
In-Reply-To: <20091007200128.GK8703@kernel.dk> (Jens Axboe's message of "Wed,
	7 Oct 2009 22:01:28 +0200")
Message-ID: <adak4z7osx8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org


 > I did a quick check, and at least newer revisions have it. Hmm I'm a bit
 > torn on this, perhaps the safer option is just to revert the bad commit.

But presumably you made that commit because it fixed some platform?

The default clock for pthread_cond_timedwait() seems poorly specified,
I'm not able to find any definitive statement about what it uses, and
pthread_condattr_setclock() seems to be option in the pthreads spec.
Seems to be a mess.

Anyway not sure what the best idea is....

 - R.
