Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59593 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760402Ab3DINaY (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Apr 2013 09:30:24 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1UPYcy-0002jv-9f
	for fio@vger.kernel.org; Tue, 09 Apr 2013 13:30:24 +0000
Received: from localhost (87-104-106-3-dynamic-customer.profibernet.dk [87.104.106.3])
	by kernel.dk (Postfix) with ESMTPA id 9773F20551
	for <fio@vger.kernel.org>; Tue,  9 Apr 2013 13:30:23 +0000 (UTC)
Date: Tue, 9 Apr 2013 15:30:06 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Fio 2.0.15 tagged
Message-ID: <20130409133006.GF12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

As you may have noticed in the automated daily commit mailing, version
2.0.15 of fio was tagged yesterday. In no particular order, the changes
and new features are:

- Various fixes to Android, both on the build front (better integration
  and cross-build support) and adding IO priority support as well. This
  from Aaron Carroll.

- The newly introduced LFSR support was overhauled, switching to a
  galois based one which is more suitable. From Alex Pyrgiotis.

- A new --eta-newline command line parameter was added. This is mostly
  useful for long running jobs, where you want a new line in there every
  x amount of time. Gives you a visual clue on how the job rates change
  over time, for the cases where you don't really want or need full
  logging.

- Addition of a --parse-only command line option. Checks the validity of
  a job, without actually running it.

- A few fixes for Solaris/SunOS, fixing the net engine nodelay pickup
  and man page installation.

- A fix for a bug where fio would re-run a job section.

- Rework of the shared file locking, should work better now.

- A bug in the random map where the minimum and maximum block sizes
  differed by more than a factor 64.

- Fix for a bug that could cause skewed latencies if rate_iops= was
  used. From SEOKYOUNG KO.

- Fix bandwidth output being all zeroes with the json output format
  selected.

- CPU clock fixes, notably for powerpc.

All users of 2.x should upgrade.

-- 
Jens Axboe

