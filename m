Return-Path: <fio-owner@vger.kernel.org>
Received: from LMX20.aig.com ([167.230.202.19]:45083 "EHLO lmx20.aig.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaDJEjZ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 10 Apr 2014 00:39:25 -0400
Received: from livp3msmt04.mail.aig.net (LIVP3MSMT04.mail.aig.net [10.92.68.110])
	by livplpps20.aig.com (8.14.4/8.14.4) with ESMTP id s3A2qeet030456
	for <fio@vger.kernel.org>; Wed, 9 Apr 2014 22:52:46 -0400
From: "Carino, Mario" <Mario.Carino@AIG.com>
Date: Wed, 9 Apr 2014 22:52:44 -0400
Subject: fio on AIX - fallocate error
Message-ID: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi.
We're trying to run fio 2.1.7 on AIX 6 and we can't seem to eliminate these errors:

fio: posix_fallocate fails: Invalid argument
fio: pid=0, err=22/file:filesetup.c:418, func=invalidate_cache, error=Invalid argument

we always get one or the other. It doesn't matter too much what command we run, what options,  etc. We saw a web page which indicates that fio requires an Asynch IO package to be installed and running on AIX. Is that correct? We're trying to find out if we have it installed on our test box. (We're lowly non-root DBA's so getting anything done requires a committee.)

Any ideas?

Thanks

Mario Carino
