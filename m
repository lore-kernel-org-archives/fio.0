Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:44287 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbcAQOLL (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 17 Jan 2016 09:11:11 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 4AEB24B433
	for <fio@vger.kernel.org>; Sun, 17 Jan 2016 14:03:54 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qH5HLzPDqAME for <fio@vger.kernel.org>;
	Sun, 17 Jan 2016 14:03:53 +0000 (UTC)
Received: from My-MBP.local (c-67-164-250-65.hsd1.ut.comcast.net [67.164.250.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Sun, 17 Jan 2016 14:03:53 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: fio newer than 2.2.12 segfaults on examples/tiobench-example.fio
Message-ID: <569B9F48.3010808@cran.org.uk>
Date: Sun, 17 Jan 2016 07:03:52 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm seeing a crash when running anything newer than 2.2.12 (I've tried 
2.2.13 and 2.3) on my openSUSE Tumbleweed system: "./fio 
examples/tiobench-example.fio" causes a segfault in pthreads (apparently 
via fio_mutex_down).

-- 
Bruce
