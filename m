Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43174 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2DRWOn (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Apr 2012 18:14:43 -0400
Received: by eekc41 with SMTP id c41so2039097eek.19
        for <fio@vger.kernel.org>; Wed, 18 Apr 2012 15:14:41 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Apr 2012 15:14:41 -0700
Message-ID: <CAN8qX8busH4Nu=0BuAYxeMOJSp+PC_z5JK3LPLaGAzb3Wy_Oug@mail.gmail.com>
Subject: Issue with verify and Mix read/writes
From: Suresh Dhanarajan <sureshdrajan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

I am using the verify option with mix read and write case.
When verify option is I am seeing that the results are not reflecting
the actual percentage given in the jobfile.
When i don't use verify option the results are exactly as per the
percentage given in the jobfile.

Please fin the result for various cases with and without verify option,

withverify sequential :-
Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
2988;2436;594;1256
10240;6565;1603;1597
===================
wthoutverify sequential :-
Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
3124;2460;600;1300
7116;5605;1368;1300
===================

random with verify
Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
3088;431;105;7322
10240;1363;332;7693
===============

random without verify
Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
3076;430;105;7311
7164;1003;244;7311

I used 70% read and 30% write option.
Is it that when verify is used the mix percentage wont be honored?
I had mentioned size has 10mb but when verify is used even that is not
getting honored.
Is there a way to make this case to honor the percentage set in the job file?

Thanks,
Suresh.D
