Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:44223 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab3BFXml (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 Feb 2013 18:42:41 -0500
Message-ID: <5112EA6E.4050005@cran.org.uk>
Date: Wed, 06 Feb 2013 23:42:38 +0000
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Running fio on Windows 64 bits with offset, zonesize and zoneskip
 and fio stops to respond
References: <843E15216120C047928F6879B0E2D9240F6F05E5@SACEXCMBX02-PRD.hq.netapp.com>
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6F05E5@SACEXCMBX02-PRD.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 06/02/2013 21:15, Neto, Antonio Jose Rodrigues wrote:
> When I run, I've got a pop-up message on windows - fio.exe has stopped working ...
>
> NOTE: If I remove zoneskip and zonesize- everything works.
>
> Could you please help me understand what am I doing wrong?

It's a divide by zero bug in eta.c:160:

bytes_total /= (td->o.zone_skip / td->o.zone_size);

It seems that td->o.zone_size isn't getting set via the zonesize setting 
in the job file and so the default of the entire size is used.

-- 
Bruce Cran
