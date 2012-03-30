Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48139 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934464Ab2C3UBU convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Mar 2012 16:01:20 -0400
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.4/8.14.4) with SMTP id q2UJwohZ002963
	for <fio@vger.kernel.org>; Fri, 30 Mar 2012 13:01:20 -0700
Received: from mail.thefacebook.com (corpout1.snc1.tfbnw.net [66.220.144.38])
	by m0004347.ppops.net with ESMTP id 13wjt4r2c4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Fri, 30 Mar 2012 13:01:20 -0700
From: Lucian Grijincu <lucian@fb.com>
Subject: units for latency in --minimal mode
Date: Fri, 30 Mar 2012 20:01:18 +0000
Message-ID: <CB9B5F1E.12E9%lucian@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <371D883455A19B4FA15D637FBF0E6BEA@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

While describing the output format, the HOWTO says:

slat= [...] This
   value can be in milliseconds or microseconds, fio will choose
   the most appropriate base and print that. In the example
   above, milliseconds is the best scale.

Does this apply to --minimal mode too?

--
Lucian

