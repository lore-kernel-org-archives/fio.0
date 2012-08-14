Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64893 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2HNE5a (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 00:57:30 -0400
Received: by obbuo13 with SMTP id uo13so7967018obb.19
        for <fio@vger.kernel.org>; Mon, 13 Aug 2012 21:57:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaS=QzLW_CcDATeZnWXPEiVEGRJr9UHdohyJo53M4pp+hh27g@mail.gmail.com>
References: <CAHaS=QzLW_CcDATeZnWXPEiVEGRJr9UHdohyJo53M4pp+hh27g@mail.gmail.com>
Date: Tue, 14 Aug 2012 14:57:29 +1000
Message-ID: <CAHaS=Qw-2ZvfvhyAHUN_y9HADFihuB=h5g=JmV9_wa27S=1Lag@mail.gmail.com>
Subject: Re: "Invalidate" not functional on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I need to perform reads without using any caching. I have the line
"invalidate=1" in my job file, however it is still using the cache.  I
am running Windows 7 32-bit. Is the "invalidate" command supposed to
be functional on Windows? If so, what am I doing wrong?

That aside, what a great utility this is - thankyou!!

Regards.,
Greg.
