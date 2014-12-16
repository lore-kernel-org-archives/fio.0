Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:29538 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaLPVqj convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 16 Dec 2014 16:46:39 -0500
Received: from mail.micron.com (ntxboicas01.micron.com [137.201.84.60])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id sBGLkcQ1025869
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 16 Dec 2014 14:46:38 -0700
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: Random overwrite and verify workload
Date: Tue, 16 Dec 2014 21:46:37 +0000
Message-ID: <5A8251503902B84E89CE171AD126BCFB963D31@NTXBOIMBX01.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I am interested in generating a workload consisting of mixed-length random overwrites followed by final verification, i.e.:

rw=randwrite
norandommap=1
bsrange=1k:4k
blockalign=512
verify=meta
do_verify=1
...

Of course, verification is incompatible with norandommap when used with multiple blocksizes, so this won't work currently.

Is such a feature on the fio roadmap?

Would a patch implementing such a feature be considered?

Thanks,
Justin
