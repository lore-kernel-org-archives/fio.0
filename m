Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:47710 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758438Ab3CINA3 (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 9 Mar 2013 08:00:29 -0500
Received: from localhost.localdomain (unknown [195.251.29.103])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id 4621518051
	for <fio@vger.kernel.org>; Sat,  9 Mar 2013 15:00:27 +0200 (EET)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH] LFSR: Fix spin related bug
Date: Sat,  9 Mar 2013 15:00:42 +0200
Message-Id: <1362834043-6735-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

Thanks for the inclusion in your code, hopefully it was easy to review.
I stumbled upon a silly bug which may affect some rare cases, so you may
want to include that patch too, just in case.

Regards,
Alex

Alex Pyrgiotis (1):
  Fix spin related bug

 lib/lfsr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

-- 
1.8.1.4

