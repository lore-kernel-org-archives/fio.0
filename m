Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:58834 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103Ab3BFV3o convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 6 Feb 2013 16:29:44 -0500
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: RE: Running fio on Windows 64 bits with offset, zonesize and
 zoneskip and fio stops to respond
Date: Wed, 6 Feb 2013 21:29:42 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6F0763@SACEXCMBX02-PRD.hq.netapp.com>
References: <843E15216120C047928F6879B0E2D9240F6F05E5@SACEXCMBX02-PRD.hq.netapp.com>
 <5112CAD7.6020005@cran.org.uk>
In-Reply-To: <5112CAD7.6020005@cran.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 06/02/2013 21:15, Neto, Antonio Jose Rodrigues wrote:
> When I run, I've got a pop-up message on windows - fio.exe has stopped working ...
>
> NOTE: If I remove zoneskip and zonesize- everything works.
>
> Could you please help me understand what am I doing wrong?

I saw fio crash yesterday when I ran it on a disk that contained volumes. Windows prevented writes to that area of the disk and fio crashed - I'm working on fixing it today.

--
Bruce Cran

Thank you so much my friend, but I don't have volumes... I am using the whole physical disk. Great when you have a fix I will download and I will test. 
