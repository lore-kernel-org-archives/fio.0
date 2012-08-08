Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56369 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2HHSaL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Aug 2012 14:30:11 -0400
Received: by obbuo13 with SMTP id uo13so1474030obb.19
        for <fio@vger.kernel.org>; Wed, 08 Aug 2012 11:30:10 -0700 (PDT)
MIME-Version: 1.0
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Wed, 8 Aug 2012 11:29:50 -0700
Message-ID: <CACiQ3FDXKEV0VVjrxaUH9U4CkXhHmVrz_d0eW6QyHKE2HHwacw@mail.gmail.com>
Subject: raw device size used by fio
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was running a number of tests with raw devices and no size set (but
did use offsets).
In the case where a raw device is specified  but no size, what
happens? does fio have a way to figure out the size of the raw device?

What is the usage of the size parameter when there are multiple raw devices.
For example if I have multiple raw devices

      filename=/dev/rdsk/c4t3d0p0:/dev/rdsk/c4t4d0p0

and a set size

     size=8000m

will it treat the 8000m as the total size of the two devices or is the
8000m the size of each?
If it's the total, then I guess fio can't work with multiple raw
devices of different sizes?

Thanks


-- 
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
