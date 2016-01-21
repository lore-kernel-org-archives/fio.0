Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:30649 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbcAUVxs (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Jan 2016 16:53:48 -0500
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A1536A.6060308@cran.org.uk>
Date: Thu, 21 Jan 2016 14:53:46 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 01/21/2016 02:43 PM, Jeff Furlong wrote:
> Building version 2.5 on Windows appears broken:
>
>
> server.c:272:11: error: 'MSG_DONTWAIT' undeclared (first use in this function)
>     flags = MSG_DONTWAIT;
>             ^
> server.c:272:11: note: each undeclared identifier is reported only once for each function it appears in

Yeah, there's also a problem with strcasestr.c. I'm working on fixing 
both problems just now.

---
Bruce
