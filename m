Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43606 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab2HaPXE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 31 Aug 2012 11:23:04 -0400
Message-ID: <5040D6D5.4010703@fusionio.com>
Date: Fri, 31 Aug 2012 08:23:01 -0700
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fio:modify a deprecated parameter(change timeout to runtime)
References: <CADu=CFpi4SSsCYVefXqZkECbw7JNhLs92TJT2Q_fd-k8E+_BGw@mail.gmail.com>
In-Reply-To: <CADu=CFpi4SSsCYVefXqZkECbw7JNhLs92TJT2Q_fd-k8E+_BGw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: liang xie <xieliang007@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-08-31 08:15, liang xie wrote:
> since "timeout" had been deprecated long long ago, we should replace
> to "runtime" both in code and docs

Better, applied :-)

-- 
Jens Axboe

