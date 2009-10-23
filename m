Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.oss.co.nz ([202.37.225.46]:48673 "EHLO mail.oss.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZJWDmT (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 22 Oct 2009 23:42:19 -0400
Received: from localhost (mail.oss.co.nz [127.0.0.1])
	by mail.oss.co.nz (Postfix) with ESMTP id 5224D208091
	for <fio@vger.kernel.org>; Fri, 23 Oct 2009 16:12:11 +1300 (NZDT)
Received: from mail.oss.co.nz ([127.0.0.1])
	by localhost (sunburn.oss.co.nz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G57Tkho66nNT for <fio@vger.kernel.org>;
	Fri, 23 Oct 2009 16:12:08 +1300 (NZDT)
Received: from zimbra.oss.co.nz (unknown [192.168.213.216])
	by mail.oss.co.nz (Postfix) with ESMTP id B878220808F
	for <fio@vger.kernel.org>; Fri, 23 Oct 2009 16:12:08 +1300 (NZDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra.oss.co.nz (Postfix) with ESMTP id BE584338058
	for <fio@vger.kernel.org>; Fri, 23 Oct 2009 16:12:07 +1300 (NZDT)
Received: from zimbra.oss.co.nz ([127.0.0.1])
	by localhost (zimbra.oss.co.nz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T2RiC2wagCaE for <fio@vger.kernel.org>;
	Fri, 23 Oct 2009 16:12:07 +1300 (NZDT)
Received: from zimbra.oss.co.nz (zimbra.oss.co.nz [192.168.213.216])
	by zimbra.oss.co.nz (Postfix) with ESMTP id 8875E278004
	for <fio@vger.kernel.org>; Fri, 23 Oct 2009 16:12:07 +1300 (NZDT)
Date: Fri, 23 Oct 2009 16:12:07 +1300 (NZDT)
From: Glen Ogilvie <gogilvie@oss.co.nz>
Message-ID: <364891921.82961256267527287.JavaMail.root@zimbra.oss.co.nz>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one MD?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Which release is this bug fixed in?  We experienced this bug as well.

Also, We have a problem where running fio on a DRBD device seems to cause
a complete system lockup sometimes.   Any ideas?

Regards
-- 
Glen Ogilvie
Open Systems Specialists
Level 1, 162 Grafton Road
http://www.oss.co.nz/

Ph: +64 9 984 3000
Mobile: +64 21 684 146
GPG Key: ACED9C17
