Return-Path: <fio-owner@vger.kernel.org>
Received: from onlyone.friendlyhosting.spb.ru ([46.4.40.135]:35458 "EHLO
	onlyone.friendlyhosting.spb.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab3CFPVM (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 6 Mar 2013 10:21:12 -0500
Received: from lion.home.serebryakov.spb.ru (unknown [IPv6:2001:470:923f:1:9421:367:9d7d:512b])
	(Authenticated sender: lev@serebryakov.spb.ru)
	by onlyone.friendlyhosting.spb.ru (Postfix) with ESMTPA id 773824AC58
	for <fio@vger.kernel.org>; Wed,  6 Mar 2013 19:12:06 +0400 (MSK)
Date: Wed, 6 Mar 2013 19:12:04 +0400
From: Lev Serebryakov <lev@serebryakov.spb.ru>
Message-ID: <809551062.20130306191204@serebryakov.spb.ru>
Subject: How to layout sparce files before run? Why all files for all jobs have same size?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello, Fio.

  How could I tell fio to don't write anything but last byte into
 files used for jobs? I need to test random write to sparse files with
 read only from written parts (like dumb torrent clients does).

  And why when I have N jobs with "filesize=2G-4G" all filesizes for
 all jobs are equal?

-- 
// Black Lion AKA Lev Serebryakov <lev@serebryakov.spb.ru>

