Return-Path: <Alan.Brunelle@hp.com>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one  MD?
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
In-Reply-To: <20090911193411.GO14984@kernel.dk>
References: <1252684789.5814.29.camel@cail>
	 <20090911163539.GK14984@kernel.dk> <1252695820.5814.31.camel@cail>
	 <20090911193411.GO14984@kernel.dk>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 16:16:40 -0400
Message-Id: <1252700200.5814.32.camel@cail>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Fri, 2009-09-11 at 21:34 +0200, Jens Axboe wrote:
> On Fri, Sep 11 2009, Alan D. Brunelle wrote:
> > Well, the attached patch appears to fix the problem: When looking to add
> > an underlying device we first check to see if its in the list of current
> > devices. If so, we skip this add. 
> > 
> > As I know next to nothing about the innards of fio, I'd be a little
> > leery of taking this in, but at least it allows me to proceed! :-)
> 
> OK, so it's probably corrupting the list on a double insert. Your check
> is likely fine, even if there are alternative ways we could fix this.
> I'll add it for now, thanks for debugging this Alan!
> 

It worked fine w/ my full test (all 12 LVM2/DM volumes being accessed on
the same underlying MD RAID10 array). So that's goodness...

Alan


