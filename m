Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2HQG2u (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 02:28:50 -0400
Message-ID: <502DE47C.8050802@kernel.dk>
Date: Fri, 17 Aug 2012 08:28:12 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Test files being created twice as large as requested (Win7)
References: <CAHaS=QxT7Prz4jw8b5rZ-D3gTmejFp3D6ZA6DxcigHpEcVAJbw@mail.gmail.com>
In-Reply-To: <CAHaS=QxT7Prz4jw8b5rZ-D3gTmejFp3D6ZA6DxcigHpEcVAJbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 08/16/2012 05:34 AM, Greg Sullivan wrote:
> fio seems to be creating test files that are twice as large as
> requested. The following config creates a file that is 209,715,200
> bytes in size:
> 
> [read]
> size=100M
> rw=read
> 
> Environment: Windows 7 32-bit, fio 2.0.8

Can you post the output of running that job? Ensure that the read.1.0 is
deleted before running it.

-- 
Jens Axboe

