Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:54359 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLRA5G (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Dec 2014 19:57:06 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 720531FD739
	for <fio@vger.kernel.org>; Wed, 17 Dec 2014 17:56:57 -0700 (MST)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id g6lLUE2niE0l for <fio@vger.kernel.org>;
	Wed, 17 Dec 2014 17:56:57 -0700 (MST)
Received: from [10.0.10.100] (c-24-10-204-217.hsd1.ut.comcast.net [24.10.204.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed, 17 Dec 2014 17:56:56 -0700 (MST)
Message-ID: <5492265F.6090100@cran.org.uk>
Date: Wed, 17 Dec 2014 17:57:03 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: 'fio: no option found at offset'
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed when running examples/tiobench-example.fio on both Windows and 
FreeBSD that several "fio: no option found at offset x" messages were 
displayed.   Are they supposed to be printed?

-- 
Bruce
