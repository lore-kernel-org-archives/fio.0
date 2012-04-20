Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37321 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2DTOmh (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 10:42:37 -0400
Received: by wibhq7 with SMTP id hq7so776224wib.1
        for <fio@vger.kernel.org>; Fri, 20 Apr 2012 07:42:36 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Apr 2012 09:42:36 -0500
Message-ID: <CAE9DZUSnWRuC+Be__-nAQhjP=C__XLtYfiF5UOU4=tYa3tKAnw@mail.gmail.com>
Subject: problems writing from windows
From: Dallas Clement <dallas.a.clement@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm having a bit of usage trouble on Windows 2008 Server R2.  I'm able
to execute a sequential read test just fine, but sequential writes are
not working.  There aren't any actual writes happening.  fio doesn't
return any errors, it just doesn't report any write activity to the
screen.

Here are the contents of my config file:

[rw]
rw=write
ioengine=windowsaio
direct=1
iodepth=256
blocksize=256K
filename=\\.\PhysicalDrive1

Anyone have some ideas for me?  Is there some kind of write protect
active by default in Windows?  I've never seen anything like this in
Linux.

Thanks
