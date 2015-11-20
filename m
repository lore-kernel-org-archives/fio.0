Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33752 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888AbbKTRdj (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Nov 2015 12:33:39 -0500
Received: by qgea14 with SMTP id a14so77530674qge.0
        for <fio@vger.kernel.org>; Fri, 20 Nov 2015 09:33:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
Date: Fri, 20 Nov 2015 09:33:38 -0800
Message-ID: <CAF+0mvkth9kQXxniQiMuxCV08cQgua4MxRBGSYJAFHrt=S+9Pg@mail.gmail.com>
Subject: Re: Bug with --buffer_compress_percentage
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On Fri, Nov 20, 2015 at 9:29 AM, Matthew Eaton <m.eaton82@gmail.com> wrote:
> I noticed that sometimes using --buffer_compress_percentage would not
> result in the desired compression.  After running some tests I found
> that only some block sizes are affected.

Forgot to mention my fio version is: fio-2.2.11-17-gd883ef
