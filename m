Return-Path: <fio-owner@vger.kernel.org>
Received: from mx4.framestore.com ([193.203.83.5]:53976 "EHLO
	mx4.framestore.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3F0I6z (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Jun 2013 04:58:55 -0400
Received: from vm-zimbra.ldn.framestore.com ([172.16.73.68] helo=zimbra.framestore.com)
	by mx4.framestore.com with esmtp (Exim 4.72)
	(envelope-from <james.vanns@framestore.com>)
	id 1Us7nJ-0000oy-Ai
	for fio@vger.kernel.org; Thu, 27 Jun 2013 09:43:11 +0100
Received: from mailbox1.framestore.com (mailbox1.framestore.com [172.16.73.65])
	by zimbra.framestore.com (Postfix) with ESMTP id A8C4F1E50052
	for <fio@vger.kernel.org>; Thu, 27 Jun 2013 09:41:59 +0100 (BST)
Date: Thu, 27 Jun 2013 09:37:52 +0100 (BST)
From: James Vanns <james.vanns@framestore.com>
Reply-To: james.vanns@framestore.com
Message-ID: <803980722.30163228.1372322272381.JavaMail.root@framestore.com>
In-Reply-To: <255129448.30162533.1372322165642.JavaMail.root@framestore.com>
Subject: Simulating bursts at different rates at irregular intervals?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi. I'm new to fio and though I've read the HOWTO from the git repo several times now, I'm unsure if it is possible to achieve what I want;

I can simulate a mix of sequential and random writes for a duration at an average rate or throughput of say, 5.4MB/s.
I presume that fio will attempt to sustain that rate? My real question is this - is it possible in either the same job
or a different job in the same file to simulate bursts of higher rates? I.e. on average attempt to write at nMB/s but
at random or irregular intervals during this period attempt a 'burst' of 138MB/s for 5 minutes and then return to the 'normal' rate. Then again at some other point a burst of 57MB/s for 30minutes etc.

Is this possible? Presently I've found that I cannot do this. Or rather, thinking about it, I'd have to specify n jobs 
for each different rate and then perhaps use 'ratecycle' and 'thinktime'? I can't see how to skew 'thinktime' randomly though?

Regards,

Jim Vanns

-- 
Jim Vanns
Senior Software Developer
Framestore

