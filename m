Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57424
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815Ab3CNOKO (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Mar 2013 10:10:14 -0400
Date: Thu, 14 Mar 2013 15:09:39 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] Cross compile improvements
Message-ID: <20130314140939.GB31875@kernel.dk>
References: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On Thu, Mar 14 2013, Aaron Carroll wrote:
> This set improves handling of cross compilation to the point where
> Android can now build with no special-casing in the configure script.
> 
> Tested on Linux/x86 and Darwin/x86_64 native, and cross compile from
> Linux/x86 to Android/arm and Linux/arm.  I dont have access to any
> big endian machine, so a sanity check of the endianess changes would
> be appreciated.

Thanks Aaron, applied. I give it the most nasty of tests, seeing if
configure runs and fio builds on HPUX/ia64:

bash-4.2# ./configure 
Operating system              HP-UX
CPU                           ia64
Big endian                    yes
Compiler                      gcc
Cross compile                 no
[...]

bash-4.2# /usr/local/bin/gmake -j8
FIO_VERSION = fio-2.0.14
[...]
    LINK fio
bash-4.2#

So I think you can consider this a pass.

-- 
Jens Axboe

