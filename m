Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:58939 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaDKV5T (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Apr 2014 17:57:19 -0400
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 12936E7496
	for <fio@vger.kernel.org>; Fri, 11 Apr 2014 22:57:18 +0100 (BST)
Received: from [10.0.10.15] (c-67-177-56-43.hsd1.ut.comcast.net [67.177.56.43])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id A9E73E73B0
	for <fio@vger.kernel.org>; Fri, 11 Apr 2014 22:57:17 +0100 (BST)
Message-ID: <5348653E.2010909@cran.org.uk>
Date: Fri, 11 Apr 2014 15:57:18 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: No output when insufficient parameters given on the commandline
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

When an incomplete job file is run, fio displays an error - but when 
insufficient parameters are specified on the commandline, fio just exits 
with no messages:

 > fio --iodepth 32
 >

 > fio --filename test --iodepth 8 --rw randrw --size 4g --thread 
--runtime 120 --time_based
 > echo $?
0
 >

-- 
Bruce
