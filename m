Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53697
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932543Ab3EONYG (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 15 May 2013 09:24:06 -0400
Received: from kernel.dk ([54.225.238.116])
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Ucbgb-00078q-M1
	for fio@vger.kernel.org; Wed, 15 May 2013 13:24:05 +0000
Received: from localhost (87-104-106-3-dynamic-customer.profibernet.dk [87.104.106.3])
	by kernel.dk (Postfix) with ESMTPA id 5A74F20671
	for <fio@vger.kernel.org>; Wed, 15 May 2013 13:24:02 +0000 (UTC)
Date: Wed, 15 May 2013 15:24:04 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Fio 2.1 has been tagged
Message-ID: <20130515132404.GB4728@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I tagged version 2.1 of fio this morning. The slight jump in versions
(from 2.0.x to 2.1) is meant to signify that the experimental gfio gtk
frontend has now been merged into the main branch. Other changes:

- Support for specifying the randomness of a random workload. Instead of
  having an on/off switch for random vs sequential, add a
  percentage_random= option that allows you to have a workload that is
  eg 80% random and 20% sequential by setting percentage_random=80.

- Make initial file fill honor the compression settings for compressible
  IO buffers. Also caught a bug in that logic, where it could hang if
  compress_chunk wasn't also set.

- gfio frontend. It should work fine for running various job files, on
  the local machine or on a remote machine (it supports sockets or
  tcp/ip v4/v6). There's very limited and not-very-tested support for
  editing existing job files. Still some work to be done here.

- Fixes of the log_*() functions, we now catch incorrectly used format
  specifiers just like we would with eg printf().

- Better Android integration

- Various other little fixes, tweaks, and even features.

Go forth and update, test, and report any anomalies!

-- 
Jens Axboe

