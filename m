Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:40798 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbcEYBnw (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 May 2016 21:43:52 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 72C566DCC
	for <fio@vger.kernel.org>; Wed, 25 May 2016 01:38:47 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ErMy3-yeBzNk for <fio@vger.kernel.org>;
	Wed, 25 May 2016 01:38:47 +0000 (UTC)
Received: from [10.0.10.17] (c-67-171-116-44.hsd1.ut.comcast.net [67.171.116.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed, 25 May 2016 01:38:47 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: hash.h warning - left shift count
Message-ID: <531cbdb4-b115-c103-5eac-f83fa1b3119f@cran.org.uk>
Date: Tue, 24 May 2016 19:38:46 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm seeing a new compiler warning on Windows. Since 'long' is 32 bits:


hash.h: In function ‘__hash_long’:
hash.h:58:2: warning: left shift count >= width of type
   n <<= 33;
   ^

-- 
Bruce

