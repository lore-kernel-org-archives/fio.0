Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38077
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970Ab3CKL14 (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 11 Mar 2013 07:27:56 -0400
Date: Mon, 11 Mar 2013 12:27:24 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] Proposed LFSR implementation
Message-ID: <20130311112724.GW14525@kernel.dk>
References: <1362746224-5162-1-git-send-email-apyrgio@grnet.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362746224-5162-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alex Pyrgiotis <apyrgio@grnet.gr>
Cc: fio@vger.kernel.org, synnefo-devel@googlegroups.com

On Fri, Mar 08 2013, Alex Pyrgiotis wrote:
> Hi Jens and list,
> 
> Due to the open-source nature of fio, I figured I'd share with you
> something I've created while working on Archipelago[1], a storage
> backend for synnefo[2] VMs.
> 
> We wanted to have an entity that can do random permutations fast, so
> we've created an XNOR Galois LFSR (more details about the implementation
> in the following patches) that should perform "better" than the generic
> one for I/O related tasks.
> 
> By "better", I don't mean only in terms of speed - since by definition
> LFSRs are insanely fast - but also in terms of their properties as
> PRNGs. The main issue with LFSRs that can't make them a serious
> candidate for I/O tasks is that due to their shifting nature, they
> cannot produce a sequence of numbers that differs widely from one to the
> next. This implementation should tackle this problem and should make
> LFSRs promising candidates at least for randrepeat jobs.
> 
> I actually went one step further and tested this implementation against
> the TESTU01 suite. A generic LFSR fails all the tests as expected, but
> this LFSR passes 3 to 5 out the 10 entry level tests of the suite. This
> shows that they are far from suitable as stand-alone PRNGs for
> cryptography, but should be pretty decent for I/O tasks.
> 
> Anyways, hopefully you will find this patch set interesting for
> inclusion in your code. If you have any questions, feel free to ask.

This is good stuff! It is indeed far superior to the existing lfsr
implementation. I'll get this queued up for inclusion. Thanks a lot.

-- 
Jens Axboe

