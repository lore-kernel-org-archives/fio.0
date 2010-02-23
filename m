Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58575 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab0BWJie (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Feb 2010 04:38:34 -0500
Date: Tue, 23 Feb 2010 10:38:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bad verify header
Message-ID: <20100223093833.GR1025@kernel.dk>
References: <1266457720.19149.80.camel@cfslap.wizy.org> <1266458472.19149.83.camel@cfslap.wizy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266458472.19149.83.camel@cfslap.wizy.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Cc: fio@vger.kernel.org

On Thu, Feb 18 2010, Ricardo M. Correia wrote:
> Ok, this one appears to be because of the 'bsrange' option.
> 
> It works fine if I replace that option by 'bs=512' or 'bs=128k'.
> 
> Any chance of this problem being fixed, or is the 'verify' option
> conceptually incompatible with 'bsrange'?

If I recall correctly, it's due to overlaps of the ios screwing up the
verify headers. It's not impossible to fix, but you have to either relax
the IO coverage or make the random block generator more clever (so eg
once a 512b block has been allocated, you can only fit < 128KB blocks
into the remaining offsets).

-- 
Jens Axboe

