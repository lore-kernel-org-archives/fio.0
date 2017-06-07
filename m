Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36126 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdFGUTE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2017 16:19:04 -0400
Received: by mail-lf0-f65.google.com with SMTP id x81so1707301lfb.3
        for <fio@vger.kernel.org>; Wed, 07 Jun 2017 13:19:03 -0700 (PDT)
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/5] fixes for ignore_error option
Date: Wed,  7 Jun 2017 23:18:44 +0300
Message-Id: <20170607201849.9448-1-tkusumi@tuxera.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>


Tomohiro Kusumi (5):
  fix wrong malloc size for ignore_error buffer
  don't leave ignore_error_nr[etype] with 4 on blank input or error
  use enum error_type_bit for ignore_error index
  use ARRAY_SIZE() for ignore_error_nr[etype]
  HOWTO: mention some details of ignore_error= option

 HOWTO      |  6 ++++--
 options.c  | 15 ++++++++++-----
 td_error.c |  3 +--
 td_error.h |  3 ++-
 4 files changed, 17 insertions(+), 10 deletions(-)

-- 
2.9.4

