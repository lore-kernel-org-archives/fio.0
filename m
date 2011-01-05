Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:47684 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1AEKES (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Jan 2011 05:04:18 -0500
Message-ID: <4D24421D.1080003@fusionio.com>
Date: Wed, 5 Jan 2011 11:04:13 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Close iolog file if reading version string fails
References: <1294219323-3809-1-git-send-email-stefanha@linux.vnet.ibm.com>
In-Reply-To: <1294219323-3809-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: fio@vger.kernel.org

On 2011-01-05 10:22, Stefan Hajnoczi wrote:
> Avoid leaking the iolog file if reading the version string fails.

Thanks Stefan, applied.

-- 
Jens Axboe

