Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:52223 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbcAUEoD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 20 Jan 2016 23:44:03 -0500
Subject: Re: fio newer than 2.2.12 segfaults on examples/tiobench-example.fio
References: <569B9F48.3010808@cran.org.uk> <569D5FB4.6050602@kernel.dk>
 <56A05EDC.4030309@cran.org.uk> <56A05F80.7070903@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A0620D.6000204@cran.org.uk>
Date: Wed, 20 Jan 2016 21:43:57 -0700
MIME-Version: 1.0
In-Reply-To: <56A05F80.7070903@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org

On 01/20/2016 09:33 PM, Jens Axboe wrote:
> Can you try and revert commit 09400a60042 and see if that fixes it?

Yes, that does fix it.

-- 
Bruce

