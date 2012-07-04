Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:36746 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2GDOo3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Jul 2012 10:44:29 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id E7DCBBF311
	for <fio@vger.kernel.org>; Wed,  4 Jul 2012 16:44:27 +0200 (CEST)
Received: from localhost (ate.tks.local [192.168.10.78])
	by iris.tks.local (Postfix) with ESMTP id 9A07D40595
	for <fio@vger.kernel.org>; Wed,  4 Jul 2012 16:44:27 +0200 (CEST)
Received: from mail.thomas-krenn.com ([127.0.0.1])
	by localhost (ate.TKS.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gZXR5F0aXfoE for <fio@vger.kernel.org>;
	Wed,  4 Jul 2012 16:44:18 +0200 (CEST)
Received: from [192.168.1.2] (91-115-77-194.adsl.highway.telekom.at [91.115.77.194])
	by mail.thomas-krenn.com (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Wed,  4 Jul 2012 16:44:18 +0200 (CEST)
Message-ID: <4FF456C1.9070200@thomas-krenn.com>
Date: Wed, 04 Jul 2012 16:44:17 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= 
	<gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Print info if direct I/O is used
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,

it would be nice if an information is printed out if direct I/O has been
used:
Instead of
--------
/usr/local/bin/fio --rw=write --direct=1 --name=usb --filename=/dev/sdb1
usb: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
--------
I suggest
--------
/usr/local/bin/fio --rw=write --direct=1 --name=usb --filename=/dev/sdb1
usb: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, direct=1, iodepth=1
--------
So I can verify if the page cache has been used for a test when
inspecting the output files.

-Georg
