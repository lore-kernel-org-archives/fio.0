Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:45225 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1HHHH6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Aug 2011 03:07:58 -0400
Message-ID: <4E3F8B4F.7000406@kernel.dk>
Date: Mon, 08 Aug 2011 09:07:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix a typo in fio.1
References: <1312786744-11648-1-git-send-email-gaoyang.zyh@taobao.com>
In-Reply-To: <1312786744-11648-1-git-send-email-gaoyang.zyh@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: fio@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>

On 2011-08-08 08:59, Zhu Yanhai wrote:
> softrandommap requires an bool argument actually.

Indeed it does, good catch. Same bug in the HOWTO, fixed that one up
too.

Thanks.

-- 
Jens Axboe

