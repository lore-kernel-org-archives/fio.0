Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:31423 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3HGJKU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Aug 2013 05:10:20 -0400
Message-ID: <52020EFA.6060208@enovance.com>
Date: Wed, 07 Aug 2013 11:10:18 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: no slat log
References: <520173F7.6000104@conversis.de>
In-Reply-To: <520173F7.6000104@conversis.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/08/2013 00:08, Dennis Jacobfeuerborn wrote:
> Hi,
> when I try to create logs with fio I get bw, iops, lat, clat and slat 
> logs but the slat log always has a size of 0 bytes. Is this a bug or 
> is data for this log only generated with specific options for fio?
>
Dennis,

I've been trying this on my 2.1.2 with the following job :

[read-sda-4k-para]
bs=4k
filename=/dev/sda
rw=read
write_lat_log=lat.log

On my side, the slat file is perfectly filled.

Can you provide a testing procedure & the version you use ?

Cheers,

