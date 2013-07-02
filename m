Return-Path: <fio-owner@vger.kernel.org>
Received: from mx4.framestore.com ([193.203.83.5]:47523 "EHLO
	mx4.framestore.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3GBPkH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Jul 2013 11:40:07 -0400
Received: from vm-zimbra.ldn.framestore.com ([172.16.73.68] helo=zimbra.framestore.com)
	by mx4.framestore.com with esmtp (Exim 4.72)
	(envelope-from <james.vanns@framestore.com>)
	id 1Uu2gS-0005BJ-Ji
	for fio@vger.kernel.org; Tue, 02 Jul 2013 16:40:05 +0100
Received: from mailbox1.framestore.com (mailbox1.framestore.com [172.16.73.65])
	by zimbra.framestore.com (Postfix) with ESMTP id C82EF1E50003
	for <fio@vger.kernel.org>; Tue,  2 Jul 2013 16:38:47 +0100 (BST)
Date: Tue, 2 Jul 2013 16:34:34 +0100 (BST)
From: James Vanns <james.vanns@framestore.com>
Reply-To: james.vanns@framestore.com
Message-ID: <335085150.31083401.1372779274187.JavaMail.root@framestore.com>
In-Reply-To: <27943043.31081549.1372778944376.JavaMail.root@framestore.com>
Subject: Prevention of full device?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi. In attempting to get a single job to create files before allowing further jobs to perform I/O on them, I cannot
see how to restrict the sum total of all the files on the device. I wish to create n files ranging in size from i-j
with a cap of m in total (so the sum of n does not exceed m). For example;

[file-generator]
numjobs=1
create_only=1
create_on_open=0
time_based=0
fill_fs=0
fill_device=0
filesize=4k-20m
size=512m
nrfiles=256
fallocate=posix
fadvise_hint=1
filename_format=\$filenum.dat
directory=/tmp/fio

I'd expect the above to create 256 files ranging from 4k to 20m and a 'du -sh' on /tmp/fio to result in
512m. However, it always seems to fill the device! How can I stop this?

Cheers,

Jim

-- 
Jim Vanns
Senior Software Developer
Framestore

