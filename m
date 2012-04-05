Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44664 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755638Ab2DES32 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Thu, 5 Apr 2012 14:29:28 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.4/8.14.4) with SMTP id q35ITCPq017800
	for <fio@vger.kernel.org>; Thu, 5 Apr 2012 11:29:28 -0700
Received: from mail.thefacebook.com (corpout1.snc1.tfbnw.net [66.220.144.38])
	by mx0b-00082601.pphosted.com with ESMTP id 141g5b829e-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 05 Apr 2012 11:29:28 -0700
From: Lucian Grijincu <lucian@fb.com>
Subject: Usage of group reporting
Date: Thu, 5 Apr 2012 18:29:23 +0000
Message-ID: <CBA33231.13A4%lucian@fb.com>
In-Reply-To: <4F7DAF3D.2050000@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB4ADE87252965448D8419DD0AE4F1D9@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


On 4/5/12 7:42 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
> Most people don't use the group reporting


Why do you say that?

For example I'm trying to find those parameters (direct-io, fadvise,
number of threads, libaio/mmap/sync, etc.) that give an overall "best
performance" (whatever that means) on a simulated workload.

I'm using group reporting, because I want numbers for the entire system,
not for an individual thread.

Am I using "fio" wrong or is "fio" mostly used for other kinds of
benchmarking?
--
Lucian

