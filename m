Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:6275 "EHLO
	mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755260AbcEWOYM (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 23 May 2016 10:24:12 -0400
Received: from pps.filterd (m0075555.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4NENfgJ020324
	for <fio@vger.kernel.org>; Mon, 23 May 2016 10:24:11 -0400
Received: from mail-ob0-f197.google.com (mail-ob0-f197.google.com [209.85.214.197])
	by mx0a-00003501.pphosted.com with ESMTP id 2343hx801q-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Mon, 23 May 2016 10:24:11 -0400
Received: by mail-ob0-f197.google.com with SMTP id yu3so259361155obb.3
        for <fio@vger.kernel.org>; Mon, 23 May 2016 07:24:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 May 2016 08:24:10 -0600
Message-ID: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
Subject: testing thin provisioned block device
From: Tim Walker <tim.t.walker@seagate.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello-

I need to do random writes/reads to some thin-provisioned block
devices.  Writes are no problem, but I have to make sure the reads
come from blocks that have already been written (or else the device
synthesizes fill data).  Pre-filling the device is not desirable since
they are 8-12 TiB, plus that isn't the way they are really used.

IO at the block level is our customer's requirement, but I'd also be
interested in the same concept at the file level, where fio randomly
reads from files that it has randomly written.

I'm sure I'm not the first person who has come up against this, but
I've searched/Googled the best I can and have come up empty. Can
somebody point me to the correct switches to force reads to be
randomly selected from the blocks that have been written by that test
sequence?

Thanks in advance.

Best regards,
-Tim

-- 
Tim Walker
Product Design Systems Engineering, Seagate Technology
