Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35417 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2ABNxF (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 2 Jan 2012 08:53:05 -0500
Message-ID: <4F01B217.2000303@fusionio.com>
Date: Mon, 2 Jan 2012 14:33:11 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix a typo
References: <1325326596-19908-1-git-send-email-gaoyang.zyh@taobao.com>
In-Reply-To: <1325326596-19908-1-git-send-email-gaoyang.zyh@taobao.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: fio@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>

On 2011-12-31 11:16, Zhu Yanhai wrote:
> The man page line of 'fadvise_hit' is exactly opposite to its true meaning.

That is worded a bit strange. Thanks, applied.

-- 
Jens Axboe

