Return-Path: <fio-owner@vger.kernel.org>
Received: from [12.204.100.226] ([12.204.100.226]:45466 "EHLO gluster.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbZENKi2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 May 2009 06:38:28 -0400
Received: from [115.108.23.204] (helo=[192.168.1.90])
	by gluster.com with esmtpa (Exim 4.69)
	(envelope-from <shehjart@zresearch.com>)
	id 1M4XgN-0005YN-DC
	for fio@vger.kernel.org; Thu, 14 May 2009 02:56:55 -0700
Message-ID: <4A0BEB65.7070406@zresearch.com>
Date: Thu, 14 May 2009 15:29:01 +0530
From: Shehjar Tikoo <shehjart@zresearch.com>
MIME-Version: 1.0
Subject: close() in fio measurements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens

Does fio include  the close() syscall in its measurements?
This is significant because close() actually does a lot of things
when the underlying file system is a NFS mount.

Thanks
Shehjar
