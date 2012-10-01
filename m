Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45590 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2JASKz (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 1 Oct 2012 14:10:55 -0400
Received: by oagh16 with SMTP id h16so5360427oag.19
        for <fio@vger.kernel.org>; Mon, 01 Oct 2012 11:10:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Oct 2012 11:10:54 -0700
Message-ID: <CAN2qFaq_1yBQRhzg8YQ-t0ChDCAAD+oRPwbcnDcD5LJm=rFkbw@mail.gmail.com>
Subject: How to perform limited IO on large file over entire extent of file?
From: Matt Hayward <matt.hayward@delphix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
   I frequently want to perform a set amount (e.g. 1 GB) of random I/O
over very large files or devices (e.g. 1 TB).

   I have noticed that when using the "size" argument to control the
amount of I/O, it also has the side effect of constraining the I/O to
the first "size" bytes of the file.

   Is there a way to tell FIO to perform X bytes of random I/O on a
file of size Y and have the random I/O distributed throughout the
extent of Y where Y > X?

-- 
Matthew Hayward
Director Professional Services
Delphix

M: 206.849.6389
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
