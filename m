Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:51519 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175AbZIKTeJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Sep 2009 15:34:09 -0400
Date: Fri, 11 Sep 2009 21:34:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one  MD?
Message-ID: <20090911193411.GO14984@kernel.dk>
References: <1252684789.5814.29.camel@cail> <20090911163539.GK14984@kernel.dk> <1252695820.5814.31.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252695820.5814.31.camel@cail>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org

On Fri, Sep 11 2009, Alan D. Brunelle wrote:
> Well, the attached patch appears to fix the problem: When looking to add
> an underlying device we first check to see if its in the list of current
> devices. If so, we skip this add. 
> 
> As I know next to nothing about the innards of fio, I'd be a little
> leery of taking this in, but at least it allows me to proceed! :-)

OK, so it's probably corrupting the list on a double insert. Your check
is likely fine, even if there are alternative ways we could fix this.
I'll add it for now, thanks for debugging this Alan!

-- 
Jens Axboe

