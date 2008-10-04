Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:47500 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbYJDINH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 4 Oct 2008 04:13:07 -0400
Date: Sat, 4 Oct 2008 10:12:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add environment-variable substitution to config options
Message-ID: <20081004081241.GZ19428@kernel.dk>
References: <48E70DAD.5000604@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E70DAD.5000604@gelato.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: fio@vger.kernel.org

On Sat, Oct 04 2008, Aaron Carroll wrote:
> Hi,
> 
> I have a nasty bash script that performs environment variable substitution 
> for running
> automated benchmarks.  This seems like a reasonable feature for FIO... so 
> here it is.
> 
> The code is quite perilous, and hasn't been particularly well tested.

I'm fine with including this, but could you also please provide an
example (preferably in HOWTO/README)? Thanks :)

-- 
Jens Axboe

