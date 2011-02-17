Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:33646 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab1BQU3R (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Feb 2011 15:29:17 -0500
Date: Thu, 17 Feb 2011 20:28:59 +0000
From: Bruce Cran <bruce@cran.org.uk>
Subject: Re: fio Makefile bug
Message-ID: <20110217202859.000053f6@unknown>
In-Reply-To: <20110217201636.GA11681@beardog.cce.hp.com>
References: <20110217201636.GA11681@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: fio@vger.kernel.org

On Thu, 17 Feb 2011 14:16:36 -0600
Mike Miller <mike.miller@hp.com> wrote:

> I ran across this when trying to run make on fio v1.50.
> 
> spike:/tmp/fio-1.50 # make
> Makefile:25: Extraneous text after `else' directive
> Makefile:30: Extraneous text after `else' directive
> Makefile:30: *** only one `else' per conditional.  Stop.

Could you try with 1.50.2 or later please? The Makefile was fixed after
1.50 was released.

-- 
Bruce Cran
