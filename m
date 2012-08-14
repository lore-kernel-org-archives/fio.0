Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35659 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2HNGYT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 02:24:19 -0400
Received: by obbuo13 with SMTP id uo13so73991obb.19
        for <fio@vger.kernel.org>; Mon, 13 Aug 2012 23:24:19 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Aug 2012 16:24:18 +1000
Message-ID: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
Subject: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I need to simulate strict synchronous, round robin i/o to a group of
files. I am on Windows 7 32-bit.
fio is very nearly working, except that even with a queue depth of 1,
it is still resulting in a disk queue that is > 1, because the
"iodepth" parameter is not global - it is per thread. (correct?)

I've tried using the "sync" engine, however that doesn't work at all -
just spews out errors.

Any assistance much appreciated.

Greg.
