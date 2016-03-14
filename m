Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx1.hgst.com ([199.255.44.36]:19521 "EHLO
	sjc00mx1.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbcCNR4m convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 14 Mar 2016 13:56:42 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: Monitor IO while fio is running
Date: Mon, 14 Mar 2016 17:55:57 +0000
Message-ID: <BN3PR0401MB1457AF32B8D51A1BC9512D4AF7880@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <e0428ae214c0407bb565172a563e79ad@AUSX13MPC103.AMER.DELL.COM>
In-Reply-To: <e0428ae214c0407bb565172a563e79ad@AUSX13MPC103.AMER.DELL.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kurt_Dorsey@Dell.com" <Kurt_Dorsey@Dell.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

You might add --eta=always and --eta-newline=1 to get the current IOPs rate every 1s, printed to stdout.  You can parse that current IOPs rate via a script and do something.  I believe the IOPs rate is recalculated every 1s, not the average from beginning of test.

Not sure why --eta and --eta-newline is not in the latest HOWTO notes.

Regards,
Jeff

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Kurt_Dorsey@Dell.com
Sent: Saturday, March 12, 2016 2:20 PM
To: fio@vger.kernel.org
Subject: Monitor IO while fio is running

I may just not know how to do this
I know about the ability to touch /tmp/fio-dump-status which will dump the output of fio to a file or stdout while the test is running.  What I am looking for is to be able to dump the write_iops_log while fio is running so that I can see the point in time average IOps for a given interval For example if I have log_avg_msec=60000 it will write an iops.log file with 60second intervals, unfortunately this file doesn't get created until fio exits.  Is there a way to get this to dump on a regular basis (or by touching a file in /tmp) so that I can tail the output?

I am looking for a way to get point in time status via a script and the output from tmp-dump-status only gives me averages from the start of time rather than the last interval

Thank you,
Kurt
--
To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

