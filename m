Return-Path: <fio-owner@vger.kernel.org>
Received: from mail4.conversis.de ([213.203.219.181]:38790 "EHLO
	mail4.conversis.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3HFWI5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 18:08:57 -0400
Received: from [192.168.2.118] (p5DCF632E.dip0.t-ipconnect.de [93.207.99.46])
	by mail4.conversis.de (Postfix) with ESMTP id 40D52157002D
	for <fio@vger.kernel.org>; Wed,  7 Aug 2013 00:08:56 +0200 (CEST)
Message-ID: <520173F7.6000104@conversis.de>
Date: Wed, 07 Aug 2013 00:08:55 +0200
From: Dennis Jacobfeuerborn <dennisml@conversis.de>
MIME-Version: 1.0
Subject: no slat log
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,
when I try to create logs with fio I get bw, iops, lat, clat and slat 
logs but the slat log always has a size of 0 bytes. Is this a bug or is 
data for this log only generated with specific options for fio?

Regards,
   Dennis
