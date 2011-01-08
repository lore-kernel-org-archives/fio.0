Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:39611 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1AHTv0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 8 Jan 2011 14:51:26 -0500
Message-ID: <4D28C03A.90707@fusionio.com>
Date: Sat, 8 Jan 2011 20:51:22 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] setgid first, setuid second
References: <1294433885-12177-1-git-send-email-stefanha@linux.vnet.ibm.com>
In-Reply-To: <1294433885-12177-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: fio@vger.kernel.org

On 2011-01-07 21:58, Stefan Hajnoczi wrote:
> Setting a new effective gid requires privileges.  We must set the gid
> while we potentially still have superuser privileges.  Otherwise
> setgid(2) fails because we've already changed to an unprivileged uid.

Thanks, applied!

-- 
Jens Axboe

