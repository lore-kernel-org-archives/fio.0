Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:42141 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbbF2XBR (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jun 2015 19:01:17 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 80A1927334A
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 17:01:17 -0600 (MDT)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id N18w4Ml_F-WA for <fio@vger.kernel.org>;
	Mon, 29 Jun 2015 17:01:17 -0600 (MDT)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 17:01:17 -0600 (MDT)
Message-ID: <5591CE3C.60203@cran.org.uk>
Date: Mon, 29 Jun 2015 17:01:16 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: t/stest failures
References: <5591CD2C.2080806@cran.org.uk>
In-Reply-To: <5591CD2C.2080806@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 6/29/2015 4:56 PM, Bruce Cran wrote:
> Is something broken in the t/stest program? It's reporting lots of 
> failures:
>
> $ ./t/stest
> fail at 128205317, size 978

Rather obviously from the console output (and tested), it works if the 
loop if changed from:

while (total < 128*1024*1024UL) {
to
while (total < 128*1000*1000UL) {

-- 
Bruce
