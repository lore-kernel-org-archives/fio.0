Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:36024 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbBYW7s (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Feb 2015 17:59:48 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 3BA4D1FDA11
	for <fio@vger.kernel.org>; Wed, 25 Feb 2015 15:50:30 -0700 (MST)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xgWkROdyBfFz for <fio@vger.kernel.org>;
	Wed, 25 Feb 2015 15:50:29 -0700 (MST)
Received: from [70.58.38.65] (muon.int.bluestop.org [70.58.38.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed, 25 Feb 2015 15:50:29 -0700 (MST)
Message-ID: <54EE51B4.8050606@cran.org.uk>
Date: Wed, 25 Feb 2015 15:50:28 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Plain "./fio" segfaults on FreeBSD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The latest code from git (built using clang) causes a segfault after 
printing the usage text when "./fio" is run:

[New LWP 100111]
No jobs(s) defined

fio-2.2.5-28-g93eeb
[usage text]
[New Thread 801c06400 (LWP 100111/fio)]

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 801c06400 (LWP 100111/fio)]
flist_empty (head=0x802000040) at flist.h:119
119             return head->next == head;
Current language:  auto; currently minimal
(gdb) p head
$1 = (const struct flist_head *) 0x802000040

Also, could we update -std=gnu99 to -std=c11 and use _Static_assert in 
compiler.h? Currently, turning optimizations off in the Makefile causes 
linker failures such as "fio/libfio.c:308: undefined reference to 
`__compiletime_assert_308'".

-- 
Bruce
