Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:51105 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZJWEXr (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 23 Oct 2009 00:23:47 -0400
Date: Fri, 23 Oct 2009 06:23:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one MD?
Message-ID: <20091023042351.GR10727@kernel.dk>
References: <364891921.82961256267527287.JavaMail.root@zimbra.oss.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <364891921.82961256267527287.JavaMail.root@zimbra.oss.co.nz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Glen Ogilvie <gogilvie@oss.co.nz>
Cc: fio@vger.kernel.org

On Fri, Oct 23 2009, Glen Ogilvie wrote:
> Hi,
> 
> Which release is this bug fixed in?  We experienced this bug as well.

Should be fixed in 1.34 release and later.

> Also, We have a problem where running fio on a DRBD device seems to cause
> a complete system lockup sometimes.   Any ideas?

That would be a kernel bug, it should not be able to lock up the system
in any way. So you'd probably want to look into that separately.

-- 
Jens Axboe

