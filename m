Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:56368 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaBSPMY (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 10:12:24 -0500
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Wed, 19 Feb 2014 15:12:23 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9B73B2190061
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:18 +0000 (GMT)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1JFC9sv57671868
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:09 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1JFCKh1005080
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 08:12:20 -0700
Message-ID: <5304C9D3.4070301@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 16:12:19 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [patch 0/9] Collection of various fio fixes and extensions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com

As it is usually we needed a few little extensions to support the old use
cases we wanted to migrate to the new benchmark. Also we found a few issues
in the fio code that we had to fix.

All that happened a long time back and we always wanted to cotribute our
changes to the project which after a loooong legal process now is finally
possible. To make things worse the code was affected by some bit rot due
to that legal waiting time which in turn stalled me making it ready for
submission again.

I'm happy that I finally found some time to update the patches to match to
the current fio git. It passed my 18 test cases which are based on the
examples delivered with fio new for the new functionality added.

Looking forward to your review,
Christian

The patch series includes:
[patch 1/9] fio: fix job clone mem leak
[patch 2/9] fio: allow general repeatability
[patch 3/9] fio: allow milliseconds on all time specifiers
[patch 4/9] fio: provide an option for a startdelay range
[patch 5/9] fio: add multi directory support
[patch 6/9] fio: allow combined output (default and terse)
[patch 7/9] fio: flush log files on test end
[patch 8/9] fio: fix last block never being touched by random offsets
[patch 9/9] fio: allow 0 as compress percentage

  backend.c     |    5 +--
  engines/net.c |    2 -
  eta.c         |   14 +++++----
  file.h        |    8 ++++-
  filesetup.c   |   70 +++++++++++++++++++++++++++++++++++++++++-----
  fio.1         |   48 +++++++++++++++++++++++--------
  fio.h         |    6 +++
  init.c        |   64 +++++++++++++++++++++++++++++++++++++-----
  io_u.c        |    2 -
  iolog.c       |    2 -
  iolog.h       |    1  options.c     |   88 
++++++++++++++++++++++++++++++++++++++++++++++------------
  options.h     |    2 +
  parse.c       |   48 ++++++++++++++++++++++---------
  stat.c        |   83 
++++++++++++++++++++++++++++++++++++++----------------
  time.c        |    2 -
  16 files changed, 349 insertions(+), 96 deletions(-)



