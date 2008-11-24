Return-Path: <fio-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:6417 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYKXWMS (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 24 Nov 2008 17:12:18 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2456426wfd.4
        for <fio@vger.kernel.org>; Mon, 24 Nov 2008 14:12:17 -0800 (PST)
Message-ID: <e2a756a20811241412s4dcc391bq65a5e82f839e3ea5@mail.gmail.com>
Date: Mon, 24 Nov 2008 14:12:17 -0800
From: "Daniel Buggie" <danielabuggie@gmail.com>
Subject: Extra Latency fields with terse output
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm not sure if this is a bug or a documentation glitch, but I'm
getting an extra 11 values when using terse output.  Based on the sum
of the numbers it appears that it is generating data for both usec and
msec as opposed to the expected "<=2, 4, ..., 1000, >=2000" break down
detailed in the man page.  Unfortunately this also means I don't know
what the values of the fields are...

The output was generated with:

"fio --name="write-64-8-2" --ioengine=libaio --file=$DEVICE --direct=1
--bs=8k --numjobs=64 --iodepth=1 --size=4096m --group_reporting
--minimal"
1xSSD-write-64-8-2;0;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;8388608;331811;25888;6;11639;92.527601;27.001639;1;20834;1484.959225;253.256387;0;13254;1.528887%;5073.016621;172.144842;0.341511%;1.632573%;1202192;0;449;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.01%;0.09%;0.01%;0.01%;0.03%;0.06%;0.08%;0.51%;4.57%;78.44%;5.03%;3.41%;5.11%;2.67%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%

In this case the last 22 fields sum to 100.04%, the 0.04% being a
reasonable rounding error.  I seem to be consistently getting these
results on any RHEL5 system using the Fio RPM from Dag or compiled
from source.

Daniel
