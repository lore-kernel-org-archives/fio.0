Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3AJS6N (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 13:58:13 -0500
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3] helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1TtNKO-0004qR-W5
	for fio@vger.kernel.org; Thu, 10 Jan 2013 18:58:13 +0000
Received: from localhost (localhost [127.0.0.1])
	by kernel.dk (Postfix) with ESMTP id 5E08F56325
	for <fio@vger.kernel.org>; Thu, 10 Jan 2013 19:58:11 +0100 (CET)
Date: Thu, 10 Jan 2013 19:58:11 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: fio heads up
Message-ID: <20130110185811.GA14170@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

After 2.0.13 was tagged yesterday, I pulled the configure branch into
the master branch. The configure branch attempts to get rid of the
special casing and weak helper lib by instead doing a "typical"
configure compile and runtime test before building fio. I did NOT use
autogen/conf (I think it's crap), I just rolled my own based on what
qemu also has.

Basically what this means is that you must run ./configure before
building fio. Fio will do this automatically, if it hasn't already been
run, when make is invoked.

Not only does this get rid of the guessing we currently have to do, it
also gets rid of the need to use EXTRA_ for cflags/libs. For instance,
it will automatically build the RDMA engine or use the libnuma support,
if it's available at build time. Much easier.

If you use git to update, please do a make clean after pulling in
everything!

And please do report any issues you found, either configure not working
right or mis-detections (failure to find foo, or finding foo when it's
not really there). Windows build is currently broken, but apart from
that, I think it should work mostly everywhere.

-- 
Jens Axboe

