Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:53441 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2EBJVT (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 May 2012 05:21:19 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 4B26EBC2D3
	for <fio@vger.kernel.org>; Wed,  2 May 2012 11:15:15 +0200 (CEST)
Received: from localhost (ate.tks.local [192.168.10.78])
	by iris.tks.local (Postfix) with ESMTP id F1CB93FAAF
	for <fio@vger.kernel.org>; Wed,  2 May 2012 11:15:14 +0200 (CEST)
Received: from mail.thomas-krenn.com ([127.0.0.1])
	by localhost (ate.TKS.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WghiozTwQfeV for <fio@vger.kernel.org>;
	Wed,  2 May 2012 11:15:05 +0200 (CEST)
Received: from [10.1.102.103] (unknown [91.223.201.22])
	by mail.thomas-krenn.com (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed,  2 May 2012 11:15:05 +0200 (CEST)
Message-ID: <4FA0FB19.6010506@thomas-krenn.com>
Date: Wed, 02 May 2012 11:15:05 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= 
	<gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Tell fio to only lay out files
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello Everyone,

is it possible to tell fio to only lay out the data files and not carry
out any tests?
The thing is that I need to sync my Flashcache device after laying out
the files and before starting the read tests. Therefore it would be
helpful if I could do the following:
-Start fio and tell him to only lay out data files
-Sync my cache
-Start fio again with the previous layed out files and do the tests

Another option would be the parameter "filename", which tells fio to use
that file. But what if I am using multiple processes, can I specify a
file on command line for each process?

Thanks, Georg


