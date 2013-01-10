Return-Path: <fio-owner@vger.kernel.org>
Received: from server505a.appriver.com ([98.129.35.4]:3507 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753639Ab3AJTOv convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 10 Jan 2013 14:14:51 -0500
From: Carl Zwanzig <cpz@coraid.com>
Date: Thu, 10 Jan 2013 13:14:33 -0600
Subject: RE: problems writing on windows
Message-ID: <27A430545AF420468AEE097737EE633A0C47E3D4D9@MBX29.exg5.exghost.com>
References: <27A430545AF420468AEE097737EE633A0C47E3D471@MBX29.exg5.exghost.com>
 <50EF080D.2020405@cran.org.uk>
In-Reply-To: <50EF080D.2020405@cran.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

> From: Bruce Cran [mailto:bruce@cran.org.uk]
> Sent: Thursday, January 10, 2013 10:27 AM
> I suspect the problem is that Windows blocks writes to areas of a raw
> disk which contain volumes.

Almost. (z slaps head, should have checked this)

In Server Manager/Disk Management, Windows had the disks marked "offline". Setting the disk online, which makes it appear there as "not initialized", allows writing. Funny that you can read from an offline disk w/o error.

(Also, just setting the disk online with diskpart does not do it, had to use the GUI. Not going to investigate that at the moment.)

Is there any convenient way for fio to check that status and report an error?

Thanks,

z!

