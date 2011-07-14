Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60694 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1GNHTC (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2011 03:19:02 -0400
Message-ID: <4E1E9861.7080008@fusionio.com>
Date: Thu, 14 Jul 2011 09:18:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Calling Linux io_getevents without blocking
References: <CAAK6Zt2ZJnHEAbNhHpXCiOzBGVfeVhA3yto-8OPTGz-KKZW+Sg@mail.gmail.com>
In-Reply-To: <CAAK6Zt2ZJnHEAbNhHpXCiOzBGVfeVhA3yto-8OPTGz-KKZW+Sg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org

On 2011-07-14 04:49, Daniel Ehrenberg wrote:
> Hi,
> 
> I'm trying to recreate a workload which would call the io_getevents
> function in Linux libaio without blocking, spinning until the result
> comes up. There are two ways to make io_getevents return immediately
> if there are no results: pass in a timeout of 0, or pass min_nr=0. (Of
> course, this non-blocking way of invoking io_getevents wouldn't be
> used by the cleanup routines, only during the main loop). I can't
> figure out what the proper way to do this is. I don't see an option
> that would allow this. I thought iodepth_batch_complete=0 would make
> the min_nr be 0, but it seems that the minimum number in practice is
> 1, as lines 555-556 establish. It looks like if
> iodepth_batch_complete=0, then full might be false and min_nr might
> not be set to 1, but this often isn't the case in my testing. I don't
> see how to set a different timeout from the default, which seems to be
> NULL.
> 
> Am I missing something? What would be the proper way of allowing this
> setting in a way that doesn't break other engines? One way I hacked up
> is to make a new boolean option which sets min_events to 0 right after
> line 556 if enabled (and similarly for the do_io main loop). Is there
> a better way to do it? Otherwise, would you accept a patch that
> implements this?

I'd be fine with allowing the nonblocking/spinning variant if set
explicitly. My only worry is people doing this by accident. But if
iodepth_batch_complete was explicitly set to 0, then we should honor
that. So I'll happily take a patch to modify that.

-- 
Jens Axboe

