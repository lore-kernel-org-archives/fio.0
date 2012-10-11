Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487Ab2JKA20 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Oct 2012 20:28:26 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3] helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.76 #1 (Red Hat Linux))
	id 1TM6dV-0001kU-3b
	for fio@vger.kernel.org; Thu, 11 Oct 2012 00:28:25 +0000
Received: from [10.64.87.188] (70-90-212-91-saltlake.hfc.comcastbusiness.net [70.90.212.91])
	by kernel.dk (Postfix) with ESMTPA id 1A16A561AB
	for <fio@vger.kernel.org>; Thu, 11 Oct 2012 02:27:53 +0200 (CEST)
Message-ID: <50761288.8070703@kernel.dk>
Date: Wed, 10 Oct 2012 18:27:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Fio 2.0.10
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I have tagged and released version 2.0.10 today. There are a few new
interesting features that I'd like to highlight:

- Fio now supports a third output format, json. The other two are normal
  output, or terse output. The terse output has traditionally been used
  for automated runs, where scripts collect and present the results to
  humans. But the csv based terse format was impossible to read as a
  human, and it was fragile whenever changes needed to be made. The JSON
  format is both easily parseable and humanly readable, and new items
  can be added without breaking existing scripts. I'd encourage most
  people that currently use the minimal/terse output to switch to the
  json output. You can select this output by adding:

        --output-format=json

  to your fio script. The format should be self-explanatory. Thanks to
  Shaohua Li for this nice addition.

- Fio now supports trim as a primary directive, similar to reads and
  writes. This means you can do rw=randtrim, for instance, to run random
  trims on a device. Currently this only works on raw block devices.
  Again, thanks to Shaohua Li for adding this code.

- There was a nasty bug with windowsaio and posixaio that had
  synthetically long latencies. Issue was that the two engines always
  completed from the front of the IO busy list, however new entries were
  not added at the tail. Hence completed IO could be sitting at the end
  of the list for a long time, depending on the IO reaping options being
  set. Credit goes to Bruce Cran for finding this bug.

- Not one, but three new IO engines:

        - e4defrag. Engine that moves extents on an ext4 file system for
          write events. Thanks to Dmitry Monakhov, and for also adding
          sample job files showing how to use it.

        - falloc. Engine that exercises fallocate on read/write/trim
          operations. Dmitry added this one as well, again with nice
          sample job files.

        - Fusion-io atomic IO engine. Engine that is able to exercise
          atomic writes on Fusion-io ioDrives. Thanks to Santhosh
          Koundinya for doing this work.

Various other little fixes and improvements that I either forgot or
didn't find notable enough to highlight. I'm excited to have both new
and repeat contributors to fio.  I haven't done the math on all previous
releases, but it looks like this release is the first one where I
haven't done the majority of the commits. Out of 50 commits, 25 of them
are mine, and 2 of them are just merges. Good stuff! Thanks a lot, and
do keep the improvements/features/fixes coming.

-- 
Jens Axboe

