Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-000fd501.pphosted.com ([67.231.144.242]:57642 "EHLO
        mx0a-000fd501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753982AbdF0Xuh (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 27 Jun 2017 19:50:37 -0400
Received: from pps.filterd (m0045961.ppops.net [127.0.0.1])
        by mx0a-000fd501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5RNdi28006873
        for <fio@vger.kernel.org>; Tue, 27 Jun 2017 16:41:53 -0700
Received: from dlb-xchpw06.dolby.net (dce-outbound.dolby.com [199.71.239.48])
        by mx0a-000fd501.pphosted.com with ESMTP id 2bbwc58n37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Tue, 27 Jun 2017 16:41:53 -0700
From: "Forrest, Jon" <Jon.Forrest@dolby.com>
Subject: Recommended Job File For Stress Testing PCI-E
Date: Tue, 27 Jun 2017 23:41:51 +0000
Message-ID: <69642c93a0234662a88941156a91bc1f@DLB-XCHPW05.dolby.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I have a system running CentOS 7.3 with 512GB of RAM and
3 Oracle F80 800GB PCIe Flash Accelerators. We have reason to
believe that there is a problem with the PCI-E hardware that
we'd like to trigger by sending lots of data on the PCI-E bus.

We thought that using fio would be a good way of doing this.
I'm wondering if someone can recommend a job file that would
access 12 disks simultaneously with as much I/O as possible.
Since these disks are flash disks, I'm hoping to do way more
reads than writes.

Thanks for any suggestions.

Jon Forrest
Dolby Labs
