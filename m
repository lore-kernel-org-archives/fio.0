Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaCFRmE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Mar 2014 12:42:04 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 0/2] Two small ./configure fixes
Date: Thu,  6 Mar 2014 18:41:57 +0100
Message-Id: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@fb.com

My hopes of cross-compiling fio for Windows were dashed when I realized
pthreads is needed (I guess only Cygwin supports it, not mingw).

On the plus side, here are two small fixes for ./configure.

Stefan Hajnoczi (2):
  Honor ./configure --cc= option
  Detect Windows operating system in ./configure

 configure | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
1.8.5.3

