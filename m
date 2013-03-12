Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:59152 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755040Ab3CLI3j (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 04:29:39 -0400
Received: from localhost.localdomain (ppp-94-66-127-201.home.otenet.gr [94.66.127.201])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id 879FB18051
	for <fio@vger.kernel.org>; Tue, 12 Mar 2013 10:29:36 +0200 (EET)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH] LFSR:Fix verification and spin bugs
Date: Tue, 12 Mar 2013 10:28:34 +0200
Message-Id: <1363076915-1140-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

As Jiri had previously noticed, verification did not work, which led to
some ugly bugs slipping through the code (sorry about that).
This patch not only fixes that but has some performance tweaks that
should make the code perform almost twice as fast for most cases.

These have come at the expense of code readability, so I added some more
comments where necessary.

Regards,
Alex

Alex Pyrgiotis (1):
  Fix verification and spin bugs

 lib/lfsr.c    | 35 +++++++++++++++++++++++------------
 lib/lfsr.h    |  1 +
 t/lfsr-test.c |  6 ++++--
 3 files changed, 28 insertions(+), 14 deletions(-)

-- 
1.8.1.4

