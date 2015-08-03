Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:42314 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbHCSRH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Aug 2015 14:17:07 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 4471847DF8
	for <fio@vger.kernel.org>; Mon,  3 Aug 2015 18:07:22 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Ur2FWSW-bYRh for <fio@vger.kernel.org>;
	Mon,  3 Aug 2015 18:07:22 +0000 (UTC)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Mon,  3 Aug 2015 18:07:22 +0000 (UTC)
From: Bruce Cran <bruce@cran.org.uk>
Subject: valgrind error "invalid read of size 4" in get_jobs_eta
Message-ID: <55BFADD9.2090303@cran.org.uk>
Date: Mon, 3 Aug 2015 12:07:21 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Running fio built from git master is reporting the following error:

==26208== Invalid read of size 4
==26208==    at 0x429FF7: get_jobs_eta (eta.c:604)
==26208==    by 0x41B8B5: show_thread_status_json (stat.c:1080)
==26208==    by 0x420A80: __show_run_stats (stat.c:1579)
==26208==    by 0x451714: fio_backend (backend.c:2292)
==26208==    by 0x40CD3F: main (fio.c:54)
==26208==  Address 0x15197a3c is 124 bytes inside a block of size 125 
alloc'd
==26208==    at 0x4C2AE25: calloc (in 
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==26208==    by 0x429FCB: get_jobs_eta (eta.c:594)
==26208==    by 0x41B8B5: show_thread_status_json (stat.c:1080)
==26208==    by 0x420A80: __show_run_stats (stat.c:1579)
==26208==    by 0x451714: fio_backend (backend.c:2292)
==26208==    by 0x40CD3F: main (fio.c:54)

-- 
Bruce
