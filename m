Return-Path: <fio-owner@vger.kernel.org>
Received: from blu004-omc1s2.hotmail.com ([65.55.116.13]:51971 "EHLO
	BLU004-OMC1S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbbISRcs (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 19 Sep 2015 13:32:48 -0400
Message-ID: <BLU406-EAS1200B1366C5B77840349795E0580@phx.gbl>
From: Jon Tango <cheerios123@outlook.com>
Subject: Latency Output Question
Date: Sat, 19 Sep 2015 12:32:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


Hello All, I took a measurement with an 4k workload with a 90% mixture of
reads and 10 % writes.

The latency output in the test result is:

Read lat avg=490.27
Write lat avg=191.78

Is this the correct way to calculate the latency? 490+192 is 682, and then
682/2?

Or, do I need to account for the 90/10 distribution when I calculate
latency?

Alos, is there a way to just get one average latency output, instead of a
separate one for read, and write?
