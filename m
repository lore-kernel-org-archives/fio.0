Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:49133 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714Ab3CLEyo (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 00:54:44 -0400
Received: From
	[10.13.1.8] ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Tue, 12 Mar 2013 15:54:42 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Tue, 12 Mar 2013 15:54:15 +1100
Message-ID: <513EB4F7.3040204@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: configure/make target machine
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

It would be nice to make fio a little more cross compile friendly.  Right now 
configure determines the target by checking for C defines and falling back to 
uname.  The makefile then reads uname again.  Is there any reason we can't 
propagate the host/target from configure to makefile?

Thanks,
  -- Aaron

