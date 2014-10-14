Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41084 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaJNT6L (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Oct 2014 15:58:11 -0400
Received: by mail-ob0-f176.google.com with SMTP id m8so28305obr.21
        for <fio@vger.kernel.org>; Tue, 14 Oct 2014 12:58:10 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Oct 2014 13:58:10 -0600
Message-ID: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com>
Subject: BUG - Cannot build fio on redhat 5
From: Tim Delaney <2timdelaney@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Trying to make fio on redhat 5.9 results in:

    lex: unknown flag '-'.  For usage, try
            lex --help
    make: *** [lex.yy.c] Error 1

Changeset "c9fa1c8d (Stephen M. Cameron  2014-10-06 17:58:32 -0500
270)" introduced the lex '--header-file' option, but that option is
not valid on redhat 5.

Makefile diff...

     ifdef CONFIG_ARITHMETIC
     lex.yy.c: exp/expression-parser.l
    -       $(QUIET_LEX)$(LEX) exp/expression-parser.l
    +       $(QUIET_LEX)$(LEX) --header-file=lexer.h exp/expression-parser.l
