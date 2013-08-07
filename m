Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:23358 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab3HGMaZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Aug 2013 08:30:25 -0400
Message-ID: <52023DE0.1000807@enovance.com>
Date: Wed, 07 Aug 2013 14:30:24 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: no slat log
References: <520173F7.6000104@conversis.de> <52020EFA.6060208@enovance.com> <52022323.2030208@conversis.de>
In-Reply-To: <52022323.2030208@conversis.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/08/2013 12:36, Dennis Jacobfeuerborn wrote:
>
> I just tested the job above and these are the files produced:
>
> [dennis@nexus fio]$ ls -l
> total 11272
> -rw-r--r--. 1 root   root   5767080  7. Aug 12:31 lat.log_clat.log
> -rw-r--r--. 1 root   root   5767087  7. Aug 12:31 lat.log_lat.log
> -rw-r--r--. 1 root   root         0  7. Aug 12:31 lat.log_slat.log
> -rw-rw-r--. 1 dennis dennis      84  7. Aug 12:31 logtest.fio
>
> There are not errors or warnings during the fio run so it's not clear 
> why the file ends up being empty.

Are you running 2.1.2 ?
If so, can you provides the complete output of fio while running ?

Cheers,

