Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39847 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3GYOgZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 10:36:25 -0400
Message-ID: <51F137D4.7000609@kernel.dk>
Date: Thu, 25 Jul 2013 08:36:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Weird trim test results
References: <CAF+0mvm8_89BhXRcs46d-AzyGunuVy3E32dcYi=kGThQkhAgfg@mail.gmail.com>
In-Reply-To: <CAF+0mvm8_89BhXRcs46d-AzyGunuVy3E32dcYi=kGThQkhAgfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

On 07/24/2013 02:22 PM, Matthew Eaton wrote:
> Hi guys,
> 
> I'm using this simple trim test on a raw SSD but getting very low
> performance.  Bandwidth seems to be tied to the block size.  Am I
> doing something wrong?

What kernel are you on? This looks like a missing unplug issue. If you
run a blktrace for a few seconds while the test is ongoing, the output
of blkparse should reveal if you are seeing timer unplugs.

-- 
Jens Axboe

