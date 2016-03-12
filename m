Return-Path: <fio-owner@vger.kernel.org>
Received: from AUSXIPPS310.us.dell.com ([143.166.148.211]:7254 "EHLO
	ausxipps310.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbcCLWU1 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 12 Mar 2016 17:20:27 -0500
From: <Kurt_Dorsey@Dell.com>
Subject: Monitor IO while fio is running
Date: Sat, 12 Mar 2016 22:20:24 +0000
Message-ID: <e0428ae214c0407bb565172a563e79ad@AUSX13MPC103.AMER.DELL.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I may just not know how to do this
I know about the ability to touch /tmp/fio-dump-status which will dump the output of fio to a file or stdout while the test is running.  What I am looking for is to be able to dump the write_iops_log while fio is running so that I can see the point in time average IOps for a given interval
For example if I have log_avg_msec=60000 it will write an iops.log file with 60second intervals, unfortunately this file doesn't get created until fio exits.  Is there a way to get this to dump on a regular basis (or by touching a file in /tmp) so that I can tail the output?

I am looking for a way to get point in time status via a script and the output from tmp-dump-status only gives me averages from the start of time rather than the last interval

Thank you,
Kurt
