Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:56400 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaBLPM3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 10:12:29 -0500
From: "Daniel Gollub" <daniel.gollub@t-online.de>
Subject: [PATCH 0/2] Make fio.h a bit more C++ safe
Date: Wed, 12 Feb 2014 15:51:53 +0100
Message-Id: <1392216715-9539-1-git-send-email-d.gollub@telekom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

Following patches allow to include fio.h for a C++ based
(external) ioengine to be compiled with g++.

(Preparing two fio engines: one internal for CEPH RBD
another external for CEPH FileStore)

Daniel Gollub (2):
  Make file.h C++ safe by casting fio_file_flags
  Make parse.h C++ safe by avoiding "or" keyword

 file.h    |    4 ++--
 options.c |    6 +++---
 parse.c   |    4 ++--
 parse.h   |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.10.4

