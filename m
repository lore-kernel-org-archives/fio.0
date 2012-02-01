Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35060 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab2BAIW5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Feb 2012 03:22:57 -0500
Message-ID: <4F28F62E.4060708@fusionio.com>
Date: Wed, 1 Feb 2012 09:22:06 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: A commented out optimization...
References: <CAAUT-yNTJGUircBV+P3CD3FuozBfTfwLgLwu+JpsED4dTMnNKA@mail.gmail.com>
In-Reply-To: <CAAUT-yNTJGUircBV+P3CD3FuozBfTfwLgLwu+JpsED4dTMnNKA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 02/01/2012 02:40 AM, Steven Lang wrote:
> In comparing the performance between older versions of fio and newer
> versions, I noticed right away that pattern writes were slower in fio
> 2.0.1.  Running perf showed that most of the time spent in fio was in
> fill_pattern (Over 50% of the CPU time), which was not the case in the
> past.
> 
> This seems like it is worth it to have around, however a year ago it
> was commented out with the following commit log:
> 
> Author: Jens Axboe <jaxboe@fusionio.com>  2011-01-14 06:32:30
> Committer: Jens Axboe <jaxboe@fusionio.com>  2011-01-14 06:32:30
> Parent: 9a793c2f91a47df348237f1a9b778253ca87ec2e (Fix race in exit of
> eta/util thread)
> Child:  69204d6e8830464bc98fcc28ca91412d6d360775 (Eta/disk thread uses
> more than the minimum stack)
> Branches: continue_on_error_type_2, master, remotes/origin/master,
> remotes/origin/stable-1.x
> Follows: fio-1.50-rc2
> Precedes: fio-1.50-rc3
> 
>     Comment out ->buf_filled_len in pattern fill
> 
>     It's buggy, needs to be debugged. Disable for now. It can cause
>     verify failures.
> 
>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> 
> And in the code the comments say "We need to ensure that the pattern
> stores are seen before the fill length store, or we could observe
> headers that aren't valid to the extent notified by the fill length".
> 
> However I'm having trouble imaging a case when that will happen, given
> that buffers are filled and consumed within the context of a single
> thread.

That's not always the case, if you are using async verifies you can have
multiple threads/CPUs looking at the same buffers.

> Do you happen to remember what sort of case was buggy and causing this
> to fail?

Let me see if I can find the thread... OK, here it is:

http://www.spinics.net/lists/fio/msg00538.html

I think the issue just dropped off the debug todo. I'd appreciate your
input :-)

-- 
Jens Axboe

