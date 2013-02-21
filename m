Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50959
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab3BUSgn (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 21 Feb 2013 13:36:43 -0500
Received: from brick.kernel.dk ([87.104.106.3] helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1U8b0c-0006Ux-Tb
	for fio@vger.kernel.org; Thu, 21 Feb 2013 18:36:43 +0000
Received: from localhost (nelson.home.kernel.dk [192.168.0.33])
	by kernel.dk (Postfix) with ESMTP id 553445637E
	for <fio@vger.kernel.org>; Thu, 21 Feb 2013 19:36:41 +0100 (CET)
Date: Thu, 21 Feb 2013 19:35:09 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Fio 2.0.14 has been tagged
Message-ID: <20130221183509.GY25617@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

The 2.0.14 release is now finally out. I knew this was going to be a
longer cycle, mainly due to the planned introduction of a hand rolled
configure script. This makes it easier to support a variety of
platforms, or even the same platform in different versions. It went a
lot easier than expected, let me know if you run into build related
issues due to this. But I do believe I've checked basically all
platforms. In general, if it builds and works on AIX, it must be
perfect.

Of new notable features, the idle profiling is pretty nifty. The idea is
to use any available cycles in the system, showing how much oomph would
be leftover when running a particular workload. For now it wont work
very well with hyperthreading (or SMT in general), though, since load on
one thread will impact the other due to the shared execution units. But
for non-SMT, it works really well. See setion 9 of the HOWTO.

Another feature that will improve the experience, is a new verify option
that greatly reduces the memory required for doing a verify. For a
classic verify, fio will store a little piece info on each written
block. It's a small piece, but for big (or many) devices, it adds up and
has been seen to cause OOM issues in the wild. That's particularly
annoying since it will happen many hours into the run. The option is not
documented yet, but it's experimental_verify. For 2.0.15, it will be
officially supported, but it should work fine as-is. Basically fio will
rewind any needed states when the write phase has finished, then replay
the same part doing the verify.

Apart from that, there's been a bigger-than-usual number of great bug
fixes. So I would encourage any user to upgrade to 2.0.14, and any
packager to do the same.

Of notable commit stats, we have 12 different committers this time, with
a total of 136 commits and:

 112 files changed, 3741 insertions(+), 2174 deletions(-)

Thanks!

-- 
Jens Axboe

