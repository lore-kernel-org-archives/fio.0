Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:14831 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3HBPKb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 Aug 2013 11:10:31 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 9BFD6127B6
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 17:10:29 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 99CB47BB110
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 17:10:29 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O38LR8giif3A for <fio@vger.kernel.org>;
	Fri,  2 Aug 2013 17:10:29 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 4A68B766C56
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 17:10:29 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eix9vebgU7gy for <fio@vger.kernel.org>;
	Fri,  2 Aug 2013 17:10:29 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id E5C0A72D02E
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 17:10:28 +0200 (CEST)
Message-ID: <51FBCBE4.1070303@enovance.com>
Date: Fri, 02 Aug 2013 17:10:28 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Adding more information in the logging files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

As you know, I've been working on having graphing tools into fio.
I'm running many benchmarks and organize the output by using genfio to 
name both files and logs.

But, there is always a but, it's impossible while taking a log file to 
understand in which setup fio ran to produce this log.

So I'd like to add several things inside the log file:
1- the role of each column
2- an header that reports what was fio setting for this log

Pro:
- Taking a log file is enough to understand the performance inside

Cons:
- That would break the current format : I'm thinking about commenting 
thoses lines.

Any ideas, comments ?

Cheers,
