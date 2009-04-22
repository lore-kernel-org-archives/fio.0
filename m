Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:36744 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZDVGVd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2009 02:21:33 -0400
Date: Wed, 22 Apr 2009 08:21:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Issue running random reads with verify on a raw device
Message-ID: <20090422062132.GV4593@kernel.dk>
References: <66dfd3fe0904101557g99d6b63r5a24a84cfe01ffbf@mail.gmail.com> <20090418175308.GE4593@kernel.dk> <66dfd3fe0904211631q2d5b7045o5664a3bdda100c19@mail.gmail.com> <20090422060528.GU4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422060528.GU4593@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Apr 22 2009, Jens Axboe wrote:
> On Tue, Apr 21 2009, Radha Ramachandran wrote:
> > Hi Jens,
> > Ah right, I missed the offset.
> > My interpretation of the options was that the check needs to be that
> > the (new random block + offset) needs to be < both the real_file_size
> > and io_size.
> > 
> > Iam not sure i understand what you said very well, so the fix that I have is:
> 
> I read up on the code, and I think your previous patch was correct. The
> offset isn't added until later in the process, so we should indeed not
> check the offset in this location.
> 
> I'll test your previous patch and add it, sorry for the noise!

Everything appears to be in working order, I have added your fix.
Thanks!

-- 
Jens Axboe

