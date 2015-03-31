Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:48515 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbCaLuh convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 31 Mar 2015 07:50:37 -0400
Received: from mail.micron.com (ntxboicas04.micron.com [137.201.20.214])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id t2VBobWo019756
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 31 Mar 2015 05:50:37 -0600
From: "Fabio Salvati (fabiosalvati)" <fabiosalvati@micron.com>
Subject: FIO for Android
Date: Tue, 31 Mar 2015 11:50:36 +0000
Message-ID: <E26AACDDD6E52E468D75FD5694C1733801295EB2B5@NTXBOIMBX07.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I need to run FIO on an ARM platform with Android OS.

I tried without success to build FIO configured for targetos=Android and cpu=ARM.

The build error was:

.o blktrace.o trim.o profiles/tiobench.o lib/linux-dev-lookup.o fio.o -lrt  -lpthread -lm   -ldl
backend.o: In function `thread_main':
/home/sys-lab/Desktop/fio/fio-
2.2.6/backend.c:1610: undefined reference to `cgroup_shutdown'
/home/sys-lab/Desktop/fio/fio-2.2.6/backend.c:1462: undefined reference to `cgroup_setup'
backend.o: In function `fio_backend':
/home/sys-lab/Desktop/fio/fio-2.2.6/backend.c:2246: undefined reference to `cgroup_kill'
collect2: ld returned 1 exit status
make: *** [fio] Error 1

Could you please help me to build FIO for ANDROID (ARM platform) ?

Any FIX? 

Any how to?

Thanks
