Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:13541 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaBKXsN convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 11 Feb 2014 18:48:13 -0500
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 79781E73A9
	for <fio@vger.kernel.org>; Tue, 11 Feb 2014 23:48:10 +0000 (GMT)
Received: from [10.0.10.11] (c-67-177-60-232.hsd1.ut.comcast.net [67.177.60.232])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id 24BEAE73A5
	for <fio@vger.kernel.org>; Tue, 11 Feb 2014 23:48:09 +0000 (GMT)
Message-ID: <52FAB6D5.5070903@cran.org.uk>
Date: Tue, 11 Feb 2014 16:48:37 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: New build warnings on Windows
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

There are some new warnings in 2.1.5 when building on Windows:

In file included from io_u.c:14:0:
err.h: In function =EF=BF=BDERR_PTR=EF=BF=BD:
err.h:18:9: warning: cast to pointer from integer of different size=20
[-Wint-to-pointer-cast]
return (void *) error;
^
err.h: In function =EF=BF=BDPTR_ERR=EF=BF=BD:
err.h:23:9: warning: cast from pointer to integer of different size=20
[-Wpointer-to-int-cast]
return (long) ptr;
^
err.h: In function =EF=BF=BDIS_ERR=EF=BF=BD:
err.h:28:22: warning: cast from pointer to integer of different size=20
[-Wpointer-to-int-cast]
return IS_ERR_VALUE((unsigned long)ptr);
^
err.h:14:27: note: in definition of macro =EF=BF=BDIS_ERR_VALUE=EF=BF=BD
#define IS_ERR_VALUE(x) ((x) >=3D (unsigned long)-MAX_ERRNO)
^
err.h: In function =EF=BF=BDIS_ERR_OR_NULL=EF=BF=BD:
err.h:33:30: warning: cast from pointer to integer of different size=20
[-Wpointer-to-int-cast]
return !ptr || IS_ERR_VALUE((unsigned long)ptr);
^
err.h:14:27: note: in definition of macro =EF=BF=BDIS_ERR_VALUE=EF=BF=BD
#define IS_ERR_VALUE(x) ((x) >=3D (unsigned long)-MAX_ERRNO)

--=20
Bruce
