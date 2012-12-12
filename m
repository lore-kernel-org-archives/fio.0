Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2LLI1o (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Dec 2012 03:27:44 -0500
Message-ID: <50C83FEA.5020306@kernel.dk>
Date: Wed, 12 Dec 2012 09:27:22 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Can fio be compiled as a static binary?
References: <50C7DC7A.5000806@aeoncomputing.com>
In-Reply-To: <50C7DC7A.5000806@aeoncomputing.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: fio@vger.kernel.org

On 2012-12-12 02:23, Jeff Johnson wrote:
> Greetings,
> 
> Is there a way to compile fio as a static binary? I have to use it on
> different Linux machines from time to time and I'd like to not alter
> the OS image by installing libaio-devel, etc. In some cases I am not
> able to make any changes to the installed OS image.
> 
> I performed a git checkout of fio and I wanted to ask if there was an
> existing/known method to derive a static fio binary from the existing
> source tree before I make any modifications or attempts on my own.

There should be nothing preventing a static link of fio, provided that
you have the proper libs installed on the machine where you build and
link it. Should be doable with:

$ EXTFLAGS="-static" make

I have never tried it, though...

-- 
Jens Axboe

