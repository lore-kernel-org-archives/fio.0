Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35803 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbFDPg1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Jun 2015 11:36:27 -0400
Received: by qczw4 with SMTP id w4so19147965qcz.2
        for <fio@vger.kernel.org>; Thu, 04 Jun 2015 08:36:26 -0700 (PDT)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 4 Jun 2015 10:35:45 -0500
Message-ID: <CAB-428k1q6kGKkJTKHUq7Q46-9gqbxisk5u+rLm_k=rjcp4FqA@mail.gmail.com>
Subject: Wired Latency Reporting in the FIO results
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Would you please kindly let me know what is the difference between
disable_lat and disable_clat options ?

I have run a test job with disable_clat=1 and disable_slat=1 and got
following lat results:

   lat (msec): min=309, max=30312, avg=15285.13, stdev=8664.28
   READ: io=15658MB, aggrb=534390KB/s, minb=534390KB/s,
maxb=534390KB/s, mint=30004msec, maxt=30004msec


These results are certainly wrong because my storage has faster
response time than reported 15 seconds avg lat. 15 seconds avg lat is
certainly noticeable in run time if that was the case.

Then, I have enabled clat and slat and got following results:

    slat (usec): min=2, max=31893, avg= 7.78, stdev=50.65
    clat (usec): min=218, max=73714, avg=3813.82, stdev=3948.53
     lat (usec): min=262, max=73718, avg=3821.84, stdev=3947.77
     READ: io=15694MB, aggrb=535627KB/s, minb=535627KB/s,
maxb=535627KB/s, mint=30003msec, maxt=30003msec

These results are making more sense. However, my intention was to cut
some gettimeofday() overhead by disabling clat and slat. Which seems
for some reason my logic is not correct.

I appreciate your input,
--Alireza
