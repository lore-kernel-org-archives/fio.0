Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59061 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbZDIStX (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Apr 2009 14:49:23 -0400
Received: by fxm2 with SMTP id 2so728778fxm.37
        for <fio@vger.kernel.org>; Thu, 09 Apr 2009 11:49:21 -0700 (PDT)
Subject: question about fork_main()
From: Francis Moreau <francis.moro@gmail.com>
Date: Thu, 09 Apr 2009 20:49:10 +0200
Message-ID: <m2eiw1fys9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hello,

I just took a look to fio source code (great tool BTW), and I'm
wondering about the fork_main() comment:

/*
 * We cannot pass the td data into a forked process, so attach the td
 * and pass it to the thread worker.
 */

Since after a fork(2) the child inherits the attached shared memory
segments from its parent, I don't see the point of this comment.

Could anybody enlight me ?

thanks.
-- 
Francis
