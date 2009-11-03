Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:38541 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZKCUwM (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Nov 2009 15:52:12 -0500
Date: Tue, 3 Nov 2009 21:52:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: fio-1.34.1, what we are doing with it and some patches we use.
Message-ID: <20091103205216.GP8742@kernel.dk>
References: <321292794.59661256869305878.JavaMail.root@zimbra.oss.co.nz> <336580134.59771256869521664.JavaMail.root@zimbra.oss.co.nz> <20091031070123.GW10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091031070123.GW10727@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Glen Ogilvie <gogilvie@oss.co.nz>
Cc: fio@vger.kernel.org, Michael O'Sullivan <michael.osullivan@auckland.ac.nz>

On Sat, Oct 31 2009, Jens Axboe wrote:
> On Fri, Oct 30 2009, Glen Ogilvie wrote:
> > Dear Jens Axboe and the FIO mailing list.
> > 
> > I have been working with Mike O'Sullivan, a senior lecturer at the
> > University of Auckland, New Zealand. He has been adapting fio 1.34.1
> > to work with iolog files and also to be able to read a "wait" command
> > to allow the iolog file to specify a wait (in millisecs) before the
> > next io. Mike's not completely confident that his changes are correct
> > in the overall fio picture, but they are working with the iolog files
> > we are using. What we did:
> > 
> > 1) We incorporated wait into iolog file reading; 2) We made some
> > modifications so that read_iolog worked.
> > 
> > We have attached a patch for fio-1.34.1.tar.bz2 along with some
> > demonstration fio config files and iolog files.
> > 
> > We are doing this so we can use an open source SPC-1 emulator to
> > generate SPC-1 like workloads and then run them in fio.
> > 
> > Hope some of this work is useful.   Feed back is welcome, we are not
> > experts in FIO and SPC-1, so this may have problems.
> 
> Interesting! I think the patch you attached is reversed, you want to
> diff old tree -> new tree. Otherwise the patch looks nice and simple,
> one of the hunks look like a generic bug fix for leaking memory and
> probably should be applied first as it isn't really part of this
> "feature".
> 
> Another thing to keep in mind is the format of the iolog file. Did you
> check whether the old versions just ignore the 'wait' line? If yes, we
> can keep the format. Otherwise we probably need to bump it.

I fixed up the style and committed it, thanks a lot for contributing
this!

-- 
Jens Axboe

