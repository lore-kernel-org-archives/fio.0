Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:26107 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbaJFWcn (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Oct 2014 18:32:43 -0400
Received: from [10.0.10.100] (c-67-182-239-81.hsd1.ut.comcast.net [67.182.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id 8B1701D6688
	for <fio@vger.kernel.org>; Mon,  6 Oct 2014 16:27:39 -0600 (MDT)
Message-ID: <54331757.8000000@cran.org.uk>
Date: Mon, 06 Oct 2014 16:27:35 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: fio exits with 0 with some bad job files
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

If you run fio with --parse-only and a job file such as 
examples/tiobench-example.fio that's had the semi-colons removed from 
the first two lines, fio prints an error message but still exits with 0:

% ./fio examples/tiobench-example.fio --parse-only
fio: option <tiobench like setup, add more fX files between the 
stonewalls to> outside of [] job section
% echo $?
0
%

I'd have expected it to exit with a non-zero value.

-- 
Bruce
