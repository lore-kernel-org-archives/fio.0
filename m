Return-Path: <fio-owner@vger.kernel.org>
Received: from srv.wefi.net ([80.66.32.76]:36864 "EHLO srv.wefi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab1IAMmG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Sep 2011 08:42:06 -0400
Received: from [10.0.0.4] (88-117-101-94.adsl.highway.telekom.at [88.117.101.94])
	by srv.wefi.net (Postfix) with ESMTPSA id 22A1A494200
	for <fio@vger.kernel.org>; Thu,  1 Sep 2011 14:33:40 +0200 (CEST)
Subject: Linux I/O stack design question
From: Werner Fischer <devlists@wefi.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 14:33:38 +0200
Message-ID: <1314880418.11001.6.camel@werner-t410>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Dear fio users and developers,

I have a question regarding the Linux I/O stack (not directly regarding
fio, but I think fio user's and developers have a lot of knowledge
here):

I'm trying to better understand the different layers of the Linux I/O
stack and how they play together. So I have started a diagram showing
the different layers of the I/O stack:
http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png

Is this diagram correct or are there any errors in there?

Any feedback is welcome.

Thanks in advance,
Werner

-- 
: Werner Fischer
: Technology Specialist
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki

