Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3HFP6w (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 11:58:52 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1V6jet-0001bo-KB
	for fio@vger.kernel.org; Tue, 06 Aug 2013 15:58:51 +0000
Received: from [10.50.3.138] (unknown [216.51.42.66])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by kernel.dk (Postfix) with ESMTPSA id A59E120ADA
	for <fio@vger.kernel.org>; Tue,  6 Aug 2013 15:58:47 +0000 (UTC)
Message-ID: <52011D0F.5060308@kernel.dk>
Date: Tue, 06 Aug 2013 09:58:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: 2.1.2 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Folks,

I tagged the release of 2.1.2 this morning. The basic changes since
2.1.1 are:

- The big graphing rework from Erwan.
- A fix for a potential verification failure, courtesy of Josef Bacik.
- Support for randomness of reads and writes independently.
- Support for setting block sizes (or ranges) for random of sequential
  IO.
- Support for multicast network IO in the net ioengine, from Shawn
  Bohrer.
- RDMA io engine should now compile and work again, was broken with the
  recent rewrites. From Yufei Ren.

65 commits in total, of which I only did 8 of them. I believe that is a
new record! Thanks a lot for your contributions, keep them coming.

-- 
Jens Axboe

