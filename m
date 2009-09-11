Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37999 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZIKUXE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Sep 2009 16:23:04 -0400
Date: Fri, 11 Sep 2009 22:23:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one  MD?
Message-ID: <20090911202306.GR14984@kernel.dk>
References: <1252684789.5814.29.camel@cail> <20090911163539.GK14984@kernel.dk> <1252695820.5814.31.camel@cail> <20090911193411.GO14984@kernel.dk> <1252700200.5814.32.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252700200.5814.32.camel@cail>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org

On Fri, Sep 11 2009, Alan D. Brunelle wrote:
> On Fri, 2009-09-11 at 21:34 +0200, Jens Axboe wrote:
> > On Fri, Sep 11 2009, Alan D. Brunelle wrote:
> > > Well, the attached patch appears to fix the problem: When looking to add
> > > an underlying device we first check to see if its in the list of current
> > > devices. If so, we skip this add. 
> > > 
> > > As I know next to nothing about the innards of fio, I'd be a little
> > > leery of taking this in, but at least it allows me to proceed! :-)
> > 
> > OK, so it's probably corrupting the list on a double insert. Your check
> > is likely fine, even if there are alternative ways we could fix this.
> > I'll add it for now, thanks for debugging this Alan!
> > 
> 
> It worked fine w/ my full test (all 12 LVM2/DM volumes being accessed on
> the same underlying MD RAID10 array). So that's goodness...

Great, thanks for re-testing!

-- 
Jens Axboe

