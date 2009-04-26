Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f112.google.com ([209.85.221.112]:62954 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZDZCpy (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Apr 2009 22:45:54 -0400
Received: by qyk10 with SMTP id 10so517438qyk.33
        for <fio@vger.kernel.org>; Sat, 25 Apr 2009 19:45:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 25 Apr 2009 21:38:53 -0500
Message-ID: <6863f0c90904251938v2fd125egaf900257c1eb33dd@mail.gmail.com>
Subject: "directory=" option not working??
From: John Cagle <jcagle@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I just tried the new ssd-test config file, and it uses a "directory="
option in the global section.

I specify "directory=/mnt" but it doesn't work.  I have an SSD mounted
at /mnt, but the files created by fio keep appearing in the cwd.

Can someone double check this on their system?  I'm working with the
latest source of fio, building it on Ubuntu x86_64.

John
