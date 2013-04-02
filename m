Return-Path: <fio-owner@vger.kernel.org>
Received: from mil.milestoneintelligence.com ([108.179.229.144]:43396 "EHLO
	mil.milestoneintelligence.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932539Ab3DBPsD (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 2 Apr 2013 11:48:03 -0400
Received: from localhost.localdomain ([127.0.0.1]:32924 helo=webmail.milestoneintelligence.com)
	by mil.milestoneintelligence.com with esmtpa (Exim 4.80)
	(envelope-from <steve.johnson@milestoneintelligence.com>)
	id 1UN2nT-0006nx-R4
	for fio@vger.kernel.org; Tue, 02 Apr 2013 11:06:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Apr 2013 11:06:51 -0400
From: steve.johnson@milestoneintelligence.com
Subject: Output questions
Message-ID: <02f3eb14c814cc7ac953bd1177dbc70b@milestoneintelligence.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fio 2.0.12.1, using group reporting, wrapping a script around fio to 
collect other metrics.

1) Looking for slat as described in the documentation, but I only see 
lat and clat - is lat in the output the same as slat in the 
documentation?

2) I also see IO latencies in the documentation but only IO depths, 
submit, complete, and issued in the output.

3) Also looking for io_queue= and util= but don't see them in the 
output.

Thanks for a great tool - it seems to have an issue starting my 147 
processes sometimes, but generally works great.  I'll provide more data 
on that later.

Thanks again.



