Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:45765 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbbBQPxW (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Feb 2015 10:53:22 -0500
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 9C6CE808437
	for <fio@vger.kernel.org>; Tue, 17 Feb 2015 16:00:25 +0100 (CET)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 9AADC5A8DC38
	for <fio@vger.kernel.org>; Tue, 17 Feb 2015 16:00:25 +0100 (CET)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id WKXS_XzM0dX4 for <fio@vger.kernel.org>;
	Tue, 17 Feb 2015 16:00:24 +0100 (CET)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 6B9D87BB219
	for <fio@vger.kernel.org>; Tue, 17 Feb 2015 16:00:24 +0100 (CET)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id t5q2NUniWprb for <fio@vger.kernel.org>;
	Tue, 17 Feb 2015 16:00:24 +0100 (CET)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 533F55A8DC41
	for <fio@vger.kernel.org>; Tue, 17 Feb 2015 16:00:24 +0100 (CET)
Message-ID: <54E35788.2000400@enovance.com>
Date: Tue, 17 Feb 2015 16:00:24 +0100
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Potential leaks & errors on current trunk
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've been playing with clang 3.3 on 
495288a1e627c3d1b29897786b786eb6008841a3 and found the following items 
interesting.

Before making any PR, I'd like your insights on them.

http://git.kernel.dk/?p=fio.git;a=blob;f=filesetup.c;h=0fb5589b7c33ce1aa154c21ecf42cf52a682c4d8;hb=HEAD#l424
On that part of the code, it's not clear for me if we want to return ret 
or always 0.
So we have to remove ret=0 _or_ change to return ret;
As some code is considering that __file_invalidate_cache can be 
different from 0, I think it's the latter case.


http://git.kernel.dk/?p=fio.git;a=blob;f=client.c;h=760ec85087b73bba197c95b033154f08c245bc7f;hb=HEAD#l1572
We have an issue on this dprint as it use eta that I've been freed in 
fio_client_dec_jobs_eta().
So using dprint could lead to a very weird message print here.
Shall we keep that dprint which could be buggy ? If we still want it, 
that would mean put extra variable to save the required info for 
printing it.


http://git.kernel.dk/?p=fio.git;a=blob;f=iolog.c;h=99f8bc18d8694cca0c141c51d116aced1b4130f2;hb=HEAD#l863
In that function, if we do return 1 we do leak ic.buf, we shall free it 
before the return

http://git.kernel.dk/?p=fio.git;a=blob;f=lib/axmap.c;h=164300f254014b10ed6e04e3e06b7263aa917aac;hb=HEAD#l127
Here, we surely miss the free of the axmap. We did free its internal 
structure but not axmap itself.


Erwan Velu,

-- 
eNovance from Redhat

