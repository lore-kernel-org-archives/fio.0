Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:39554 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1AHT1A (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 8 Jan 2011 14:27:00 -0500
Message-ID: <4D28BA78.60807@fusionio.com>
Date: Sat, 8 Jan 2011 20:26:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Document that write_iolog is unsafe for concurrent jobs
References: <1294312426-3121-1-git-send-email-stefanha@linux.vnet.ibm.com>
In-Reply-To: <1294312426-3121-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: fio@vger.kernel.org

On 2011-01-06 12:13, Stefan Hajnoczi wrote:
> The write_iolog parameter should not be used in the global section since
> each job will independently write to the same file.  The output will be
> interspersed and the file will be corrupt.
> 
> Document that each job should write to its own iolog file.  This will
> save users time when trying out the iolog feature for the first time.

Thanks, I added this and also updated the man page.


-- 
Jens Axboe

