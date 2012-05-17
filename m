Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36288 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2EQIuh (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 May 2012 04:50:37 -0400
Received: by bkcji2 with SMTP id ji2so1321680bkc.19
        for <fio@vger.kernel.org>; Thu, 17 May 2012 01:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMJ=ptCSGPwF+QWLw27XePB9kbJ-PxjtOtvJ3UbmzAqaZsYrGQ@mail.gmail.com>
References: <CAMJ=ptCSGPwF+QWLw27XePB9kbJ-PxjtOtvJ3UbmzAqaZsYrGQ@mail.gmail.com>
Date: Thu, 17 May 2012 01:50:36 -0700
Message-ID: <CAMJ=ptBgv_YKz9zQOnsyMzXbLO=pUusNY9YEWJzqQWgr_TvRyw@mail.gmail.com>
Subject: blocking shutdown?
From: George Pang <xilvar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've been configuring a server for a colocation recently using ubuntu
12.04 desktop (the server dist dislikes my only keyboard) and I
noticed that if I am running an fio test and I initiate a shutdown the
shutdown kills off everything as usual, but fio appears to keep
running and block shutdown. (from either the desktop ui or with
"shutdown now")

Thus on a remote server any user with privileges to run fio could
accidentally, or maliciously prevent system shutdown from completing,
effectively taking a server out of service until physical access was
achieved.

George
