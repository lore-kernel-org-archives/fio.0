Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53074 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbaBQNfh (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 17 Feb 2014 08:35:37 -0500
From: Daniel Gollub <d.gollub@telekom.de>
Subject: [PATCH] librbd ioengine support v2
Date: Mon, 17 Feb 2014 14:35:27 +0100
Message-Id: <1392644128-25678-1-git-send-email-d.gollub@telekom.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

Same as v1 - only diffence:
 - revert unintended changes in options.c to windowsaio options struct

Daniel Gollub (1):
  librbd ioengine support

 Makefile      |    3 +
 configure     |   30 ++++
 engines/rbd.c |  449 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 options.c     |    5 +
 options.h     |    2 +
 5 files changed, 489 insertions(+)
 create mode 100644 engines/rbd.c

-- 
1.7.10.4

