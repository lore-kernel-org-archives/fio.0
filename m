Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3G2PCc (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jul 2013 11:02:32 -0400
Message-ID: <51F683EC.4090402@kernel.dk>
Date: Mon, 29 Jul 2013 09:02:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --minimal does not work in client/server mode
References: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
In-Reply-To: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: asomers@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/26/2013 05:16 PM, asomers@gmail.com wrote:
> When I use fio in client/server mode, no matter how I try to specify
> --minimal, I always get the normal output.  I've tried all of these
> methods, and their combinations:
> 
> server# fio --server
> client#  fio --minimal --client=localhost /tmp/cpuio.fio
> 
> server# fio --server
> client#  fio --client=localhost --minimal /tmp/cpuio.fio
> 
> server# fio --minimal --server
> client# fio --client=localhost  /tmp/cpuio.fio
> 
> The following patch fixes the problem, though I can't promise it won't
> break anything else:

It's a good starting point. It needs to handle the json based output too
though. I'll take a look at fixing that part up and pass you back
something to test.

-- 
Jens Axboe

