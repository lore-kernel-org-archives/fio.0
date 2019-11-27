Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:13542 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbfK0Xof (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 27 Nov 2019 18:44:35 -0500
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: fio successful completions followed by segfault
Date: Wed, 27 Nov 2019 23:39:43 +0000
Message-ID: <AT5PR8401MB11691BED1083329B6E369811AB440@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <MN2PR18MB287796333F64B6B6F78B0169C44C0@MN2PR18MB2877.namprd18.prod.outlook.com>
 <DM6PR18MB2874CA8E0E01B4F6AB0A2B6EC44E0@DM6PR18MB2874.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB2874CA8E0E01B4F6AB0A2B6EC44E0@DM6PR18MB2874.namprd18.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Joseph DeVincentis <jdevincentis@marvell.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of
> Joseph DeVincentis
> Sent: Thursday, November 21, 2019 6:00 AM
> To: fio@vger.kernel.org
> Subject: RE: fio successful completions followed by segfault
...
> +			ret = pthread_join(td->thread, NULL);
> +			if (ret) {
> +				log_err("pthread_join: %s\n", strerror(ret));

Including the thread ID might be helpful.

If the thread is already gone and this returns ESRCH, is log_err
appropriate or should it be quiet?



