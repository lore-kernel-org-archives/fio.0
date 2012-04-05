Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50905 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755916Ab2DEUXr convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Thu, 5 Apr 2012 16:23:47 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.4/8.14.4) with SMTP id q35KIPtv002803
	for <fio@vger.kernel.org>; Thu, 5 Apr 2012 13:23:46 -0700
Received: from mail.thefacebook.com (corpout1.snc1.tfbnw.net [66.220.144.38])
	by mx0b-00082601.pphosted.com with ESMTP id 141hmkr2kd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 05 Apr 2012 13:23:46 -0700
From: Lucian Grijincu <lucian@fb.com>
Subject: difference between "bandwidth (KB/s)" and "Bw (KB/s) mean"
Date: Thu, 5 Apr 2012 20:23:44 +0000
Message-ID: <CBA34831.13C5%lucian@fb.com>
In-Reply-To: <CBA3410B.13C2%lucian@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <210CD586C6A35C459F4CAB4F99A30BE8@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I was expecting these two to be the same value.

You give this example in the HOWTO:
  write: io=    32MB, bw=   666KB/s, iops=89 , runt= 50320msec
    slat (msec): min=    0, max=  136, avg= 0.03, stdev= 1.92
    clat (msec): min=    0, max=  631, avg=48.50, stdev=86.82
    bw  (KB/s) : min=    0, max= 1196, per=51.00%, avg=664.02, stdev=681.68

There's a small difference between them: 666KB/s vs 664.02KB/s


bw=     Average bandwidth rate

     bw=Bandwidth. Same names as the xlat stats, but also includes
        an approximate percentage of total aggregate bandwidth
        this thread received in this group. This last value is

     slat=Submission latency (avg being the average, stdev being the
        standard deviation).

From these descriptions I'd guess they are supposed to be the same value.



From tests I can see big differences between them (at least with
group_reporting):
- bandwidth (KB/s) - increases with number of threads and plateaus
- Bw (KB/s) mean   - decreases with number of threads and plateaus

--
Lucian

